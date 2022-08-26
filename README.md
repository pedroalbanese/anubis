# Anubis
### Anubis Block Cipher
[Anubis](https://www.garykessler.net/library/crypto/Anubis.pdf) is a block cipher designed by Vincent Rijmen and Paulo S. L. M. Barreto as an entrant in the NESSIE project. Anubis operates on data blocks of 128 bits, accepting keys of length 32N bits (N = 4, ..., 10). The cipher is not patented and has been released by the designers for free public use. Anubis is a Rijndael variant that uses involutions for the various operations. An involution is an operation whose inverse is the same as the forward operation. In other words, when an involution is run twice, it is the same as performing no operation. This allows low-cost hardware and compact software implementations to use the same operations for both encryption and decryption. Both the S-box and the mix columns operations are involutions.

By [Damian Gryski](https://github.com/dgryski).
