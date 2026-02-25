"""
Anubis GCM (Galois/Counter Mode) implementation.
Compatible with Go's crypto/cipher interface.
"""
import os
import struct
from typing import Optional, Tuple
from collections.abc import Iterable

# Import Anubis from the previous implementation
from anubis import Anubis

class GCM:
    """
    Galois/Counter Mode for Anubis.
    Implements authenticated encryption with associated data.
    """
    
    # Block size in bytes (Anubis is 128-bit)
    _BLOCK_SIZE = 16
    
    # Standard GCM tag sizes
    _TAG_SIZE = 16  # Default tag size
    
    def __init__(self, cipher: Anubis, nonce: Optional[bytes] = None, tag_size: int = 16):
        """
        Initialize GCM mode.
        
        Args:
            cipher: Anubis cipher instance
            nonce: Nonce/IV (if None, will be generated)
            tag_size: Size of authentication tag in bytes (must be between 12 and 16)
        
        Raises:
            ValueError: If tag_size is invalid
        """
        if tag_size < 12 or tag_size > 16:
            raise ValueError("tag_size must be between 12 and 16 bytes")
        
        self.cipher = cipher
        self.tag_size = tag_size
        self._ghash_key = None
        
        if nonce is None:
            # Generate random nonce (96 bits recommended by NIST)
            self.nonce = os.urandom(12)
        else:
            self.nonce = nonce
        
        # Initialize counter
        self._counter = 1
        self._init_ghash()
    
    def _init_ghash(self):
        """Initialize GHASH key (H)."""
        # H = E_K(0^128)
        zero_block = bytes(self._BLOCK_SIZE)
        self._ghash_key = self.cipher.encrypt(zero_block)
    
    def _ghash(self, data: bytes) -> bytes:
        """
        GHASH function (Galois Hash).
        
        Args:
            data: Data to hash (must be multiple of 16 bytes)
        
        Returns:
            16-byte hash
        """
        if not data:
            return bytes(self._BLOCK_SIZE)
        
        # Pad data to multiple of 16 bytes if necessary
        if len(data) % self._BLOCK_SIZE != 0:
            padding = self._BLOCK_SIZE - (len(data) % self._BLOCK_SIZE)
            data = data + bytes(padding)
        
        # Convert H to integer for multiplication
        H = int.from_bytes(self._ghash_key, 'big')
        
        # Initialize result
        result = 0
        
        # Process 16-byte blocks
        for i in range(0, len(data), self._BLOCK_SIZE):
            block = data[i:i + self._BLOCK_SIZE]
            # Convert block to integer (big-endian)
            block_int = int.from_bytes(block, 'big')
            
            # Multiply: result = (result XOR block) * H in GF(2^128)
            result ^= block_int
            result = self._gmult(result, H)
        
        return result.to_bytes(self._BLOCK_SIZE, 'big')
    
    def _gmult(self, x: int, y: int) -> int:
        """
        Multiplication in GF(2^128) with irreducible polynomial
        x^128 + x^7 + x^2 + x + 1.
        
        Args:
            x: First 128-bit integer
            y: Second 128-bit integer
        
        Returns:
            Product in GF(2^128)
        """
        # Russian peasant algorithm
        z = 0
        v = y
        
        # Process 128 bits
        for i in range(127, -1, -1):
            if (x >> i) & 1:
                z ^= v
            
            # Reduce v if MSB is set
            if v & 1:
                v = (v >> 1) ^ 0xE1000000000000000000000000000000
            else:
                v >>= 1
        
        return z
    
    def _inc32(self, counter_block: bytes) -> bytes:
        """
        Increment the rightmost 32 bits of a 16-byte block.
        
        Args:
            counter_block: 16-byte counter block
        
        Returns:
            Incremented counter block
        """
        # Extract the last 4 bytes (32 bits)
        counter_int = int.from_bytes(counter_block[12:], 'big')
        counter_int = (counter_int + 1) & 0xFFFFFFFF
        
        # Reconstruct the block
        return counter_block[:12] + counter_int.to_bytes(4, 'big')
    
    def _compute_tag(self, ciphertext: bytes, associated_data: bytes) -> bytes:
        """
        Compute authentication tag.
        
        Args:
            ciphertext: Encrypted data
            associated_data: Associated data
        
        Returns:
            Authentication tag
        """
        # Encode lengths
        len_a = len(associated_data) * 8  # bits
        len_c = len(ciphertext) * 8       # bits
        
        len_block = struct.pack('>QQ', len_a, len_c)
        
        # GHASH input: A || C || len(A) || len(C)
        # Note: A and C are zero-padded to 16-byte boundaries
        auth_data = associated_data
        if len(auth_data) % self._BLOCK_SIZE != 0:
            padding = self._BLOCK_SIZE - (len(auth_data) % self._BLOCK_SIZE)
            auth_data = auth_data + bytes(padding)
        
        cipher_data = ciphertext
        if len(cipher_data) % self._BLOCK_SIZE != 0:
            padding = self._BLOCK_SIZE - (len(cipher_data) % self._BLOCK_SIZE)
            cipher_data = cipher_data + bytes(padding)
        
        ghash_input = auth_data + cipher_data + len_block
        
        # Compute GHASH
        S = self._ghash(ghash_input)
        
        # Compute tag: T = MSB_t(GCTR_K(J0, S))
        # where J0 is the initial counter block
        if len(self.nonce) == 12:
            # For 96-bit nonce: J0 = nonce || 0^31 || 1
            J0 = self.nonce + b'\x00\x00\x00\x01'
        else:
            # For other nonce lengths: J0 = GHASH_H(nonce || 0^{s+64} || len(nonce))
            s = (16 - (len(self.nonce) % 16)) % 16
            nonce_padded = self.nonce + bytes(s) + b'\x00\x00\x00\x00\x00\x00\x00\x00' + struct.pack('>Q', len(self.nonce) * 8)
            J0 = self._ghash(nonce_padded)
        
        # Encrypt J0 to get tag
        tag_full = self._gctr(J0, S)
        
        # Truncate to tag_size
        return tag_full[:self.tag_size]
    
    def _gctr(self, icb: bytes, X: bytes) -> bytes:
        """
        GCTR function (Counter Mode).
        
        Args:
            icb: Initial counter block
            X: Data to encrypt/decrypt
        
        Returns:
            Encrypted/decrypted data
        """
        if not X:
            return b''
        
        # Calculate number of blocks
        n = (len(X) + self._BLOCK_SIZE - 1) // self._BLOCK_SIZE
        
        Y_blocks = []
        cb = icb
        
        for i in range(n):
            # Encrypt counter block
            encrypted_cb = self.cipher.encrypt(cb)
            
            # Determine block size (full block except for last)
            if i == n - 1:
                block_size = len(X) % self._BLOCK_SIZE
                if block_size == 0:
                    block_size = self._BLOCK_SIZE
            else:
                block_size = self._BLOCK_SIZE
            
            # XOR with plaintext
            block_start = i * self._BLOCK_SIZE
            block_end = block_start + block_size
            X_block = X[block_start:block_end]
            
            Y_block = bytes(x ^ y for x, y in zip(X_block, encrypted_cb[:block_size]))
            Y_blocks.append(Y_block)
            
            # Increment counter
            cb = self._inc32(cb)
        
        return b''.join(Y_blocks)
    
    def encrypt(self, plaintext: bytes, associated_data: bytes = b'') -> Tuple[bytes, bytes]:
        """
        Encrypt plaintext with authenticated encryption.
        
        Args:
            plaintext: Data to encrypt
            associated_data: Associated data to authenticate (but not encrypt)
        
        Returns:
            Tuple of (ciphertext, tag)
        """
        # Generate initial counter block
        if len(self.nonce) == 12:
            # For 96-bit nonce: J0 = nonce || 0^31 || 1
            icb = self.nonce + b'\x00\x00\x00\x01'
        else:
            # For other nonce lengths
            s = (16 - (len(self.nonce) % 16)) % 16
            nonce_padded = self.nonce + bytes(s) + b'\x00\x00\x00\x00\x00\x00\x00\x00' + struct.pack('>Q', len(self.nonce) * 8)
            icb = self._ghash(nonce_padded)
        
        # Increment ICB for first data block
        cb = self._inc32(icb)
        
        # Encrypt plaintext using GCTR
        ciphertext = self._gctr(cb, plaintext)
        
        # Compute authentication tag
        tag = self._compute_tag(ciphertext, associated_data)
        
        return ciphertext, tag
    
    def decrypt(self, ciphertext: bytes, tag: bytes, associated_data: bytes = b'') -> Optional[bytes]:
        """
        Decrypt ciphertext with authentication.
        
        Args:
            ciphertext: Data to decrypt
            tag: Authentication tag
            associated_data: Associated data
        
        Returns:
            Decrypted plaintext or None if authentication fails
        """
        # Verify tag
        expected_tag = self._compute_tag(ciphertext, associated_data)
        
        # Constant-time comparison
        if not self._constant_time_compare(tag, expected_tag):
            return None
        
        # Generate initial counter block (same as encryption)
        if len(self.nonce) == 12:
            icb = self.nonce + b'\x00\x00\x00\x01'
        else:
            s = (16 - (len(self.nonce) % 16)) % 16
            nonce_padded = self.nonce + bytes(s) + b'\x00\x00\x00\x00\x00\x00\x00\x00' + struct.pack('>Q', len(self.nonce) * 8)
            icb = self._ghash(nonce_padded)
        
        # Increment ICB for first data block
        cb = self._inc32(icb)
        
        # Decrypt ciphertext using GCTR (same as encryption)
        plaintext = self._gctr(cb, ciphertext)
        
        return plaintext
    
    def _constant_time_compare(self, a: bytes, b: bytes) -> bool:
        """
        Constant-time comparison to prevent timing attacks.
        
        Args:
            a: First byte string
            b: Second byte string
        
        Returns:
            True if strings are equal, False otherwise
        """
        if len(a) != len(b):
            return False
        
        result = 0
        for x, y in zip(a, b):
            result |= x ^ y
        
        return result == 0


class GCMAnubis:
    """
    Convenience wrapper for Anubis-GCM.
    Compatible with Go's AEAD interface.
    """
    
    def __init__(self, key: bytes):
        """
        Initialize Anubis-GCM.
        
        Args:
            key: Encryption key (16 bytes for 128-bit Anubis)
        """
        self.cipher = Anubis(key)
        self._key = key
    
    @property
    def nonce_size(self) -> int:
        """Return the recommended nonce size (96 bits)."""
        return 12
    
    @property
    def overhead(self) -> int:
        """Return the tag size (overhead)."""
        return 16  # Default tag size
    
    def seal(self, nonce: bytes, plaintext: bytes, associated_data: bytes) -> bytes:
        """
        Encrypt and authenticate plaintext.
        
        Args:
            nonce: Nonce/IV (must be nonce_size bytes)
            plaintext: Data to encrypt
            associated_data: Associated data
        
        Returns:
            Ciphertext with appended tag
        """
        gcm = GCM(self.cipher, nonce)
        ciphertext, tag = gcm.encrypt(plaintext, associated_data)
        return ciphertext + tag
    
    def open(self, nonce: bytes, ciphertext: bytes, associated_data: bytes) -> Optional[bytes]:
        """
        Decrypt and verify ciphertext.
        
        Args:
            nonce: Nonce/IV (must be nonce_size bytes)
            ciphertext: Ciphertext with appended tag
            associated_data: Associated data
        
        Returns:
            Decrypted plaintext or None if authentication fails
        """
        if len(ciphertext) < 16:  # Minimum tag size is 12, but we use 16
            return None
        
        # Split ciphertext and tag
        tag = ciphertext[-16:]  # Last 16 bytes is tag
        ciphertext_only = ciphertext[:-16]
        
        gcm = GCM(self.cipher, nonce)
        return gcm.decrypt(ciphertext_only, tag, associated_data)


def newGCM(cipher: Anubis) -> GCM:
    """
    Create a new GCM instance with random nonce.
    Compatible with Go's crypto/cipher.NewGCM.
    
    Args:
        cipher: Anubis cipher instance
    
    Returns:
        GCM instance
    """
    return GCM(cipher)


def newGCMWithNonceAndTagSize(cipher: Anubis, nonce: bytes, tag_size: int) -> GCM:
    """
    Create a new GCM instance with specified nonce and tag size.
    
    Args:
        cipher: Anubis cipher instance
        nonce: Nonce/IV
        tag_size: Tag size in bytes
    
    Returns:
        GCM instance
    """
    return GCM(cipher, nonce, tag_size)


def newGCMWithNonce(cipher: Anubis, nonce: bytes) -> GCM:
    """
    Create a new GCM instance with specified nonce.
    
    Args:
        cipher: Anubis cipher instance
        nonce: Nonce/IV
    
    Returns:
        GCM instance
    """
    return GCM(cipher, nonce)


# Test function
def test_gcm():
    """Test GCM mode with Anubis."""
    print("Anubis-GCM Test")
    print("=" * 60)
    
    # Test key and data
    key = bytes([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                  0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F])
    nonce = bytes([0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
                    0x18, 0x19, 0x1A, 0x1B])
    plaintext = b"Hello, World! This is a test message for Anubis-GCM."
    associated_data = b"Test Associated Data"
    
    # Create cipher and GCM
    cipher = Anubis(key)
    gcm = GCM(cipher, nonce)
    
    print(f"Key:          {key.hex()}")
    print(f"Nonce:        {nonce.hex()}")
    print(f"Plaintext:    {plaintext[:50]}...")
    print(f"Associated:   {associated_data}")
    
    # Encrypt
    ciphertext, tag = gcm.encrypt(plaintext, associated_data)
    print(f"\nCiphertext:   {ciphertext.hex()[:50]}...")
    print(f"Tag:          {tag.hex()}")
    
    # Decrypt (should succeed)
    decrypted = gcm.decrypt(ciphertext, tag, associated_data)
    print(f"\nDecrypted:    {decrypted[:50]}...")
    print(f"Success:      {decrypted == plaintext}")
    
    # Test with wrong tag (should fail)
    wrong_tag = bytes([(b + 1) & 0xFF for b in tag])
    decrypted_wrong = gcm.decrypt(ciphertext, wrong_tag, associated_data)
    print(f"Wrong tag:    {decrypted_wrong is None}")
    
    # Test with wrong associated data (should fail)
    wrong_ad = b"Wrong Associated Data"
    decrypted_wrong_ad = gcm.decrypt(ciphertext, tag, wrong_ad)
    print(f"Wrong AD:     {decrypted_wrong_ad is None}")
    
    # Test with Go-compatible interface
    print("\n" + "-" * 60)
    print("Go-compatible interface test:")
    
    gcm_go = GCMAnubis(key)
    sealed = gcm_go.seal(nonce, plaintext, associated_data)
    opened = gcm_go.open(nonce, sealed, associated_data)
    
    print(f"Sealed size:  {len(sealed)} bytes")
    print(f"Opened:       {opened[:50]}...")
    print(f"Success:      {opened == plaintext}")
    
    # Test empty plaintext
    print("\n" + "-" * 60)
    print("Empty plaintext test:")
    
    empty_plaintext = b""
    ciphertext_empty, tag_empty = gcm.encrypt(empty_plaintext, associated_data)
    decrypted_empty = gcm.decrypt(ciphertext_empty, tag_empty, associated_data)
    
    print(f"Empty encrypt: {ciphertext_empty.hex()}")
    print(f"Empty tag:     {tag_empty.hex()}")
    print(f"Empty decrypt: {decrypted_empty == empty_plaintext}")
    
    # Test without associated data
    print("\n" + "-" * 60)
    print("No associated data test:")
    
    ciphertext_no_ad, tag_no_ad = gcm.encrypt(plaintext, b"")
    decrypted_no_ad = gcm.decrypt(ciphertext_no_ad, tag_no_ad, b"")
    
    print(f"No AD encrypt: {decrypted_no_ad[:50]}...")
    print(f"No AD success: {decrypted_no_ad == plaintext}")


if __name__ == "__main__":
    test_gcm()
