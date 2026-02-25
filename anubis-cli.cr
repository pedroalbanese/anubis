# anubis_cli.cr
require "option_parser"
require "./anubis_gcm"

begin
  key_hex = ""
  aad = ""
  infile = ""
  outfile = ""
  decrypt_mode = false

  OptionParser.parse do |parser|
    parser.banner = "Usage: anubis-gcm [options]"
    parser.on("-k HEX", "--key=HEX", "Key in hexadecimal (16,20,24,28,32,36,40 bytes)") { |k| key_hex = k }
    parser.on("-i FILE", "--in=FILE", "Input file (stdin if omitted)") { |f| infile = f }
    parser.on("-o FILE", "--out=FILE", "Output file (stdout if omitted)") { |f| outfile = f }
    parser.on("-a STRING", "--aad=STRING", "Associated data") { |a| aad = a }
    parser.on("-d", "--decrypt", "Decryption mode") { decrypt_mode = true }
    parser.on("-h", "--help") { puts parser; exit }
  end

  if key_hex.empty?
    STDERR.puts "Error: Key is required"
    STDERR.puts "Usage: anubis-gcm -k <key_hex> [-i <infile>] [-o <outfile>] [-a <aad>] [-d]"
    STDERR.puts ""
    STDERR.puts "Format:"
    STDERR.puts "  Encrypt output: nonce(12) || ciphertext || tag(16)"
    STDERR.puts "  Decrypt input: nonce(12) || ciphertext || tag(16)"
    exit 1
  end

  # Limpar strings hex
  key_hex = key_hex.gsub(/[^0-9A-Fa-f]/, "")

  # Converter key
  begin
    key = key_hex.hexbytes
  rescue e
    STDERR.puts "Error: Invalid key hex string"
    exit 1
  end
  
  # Validar tamanho da chave Anubis (128-320 bits, múltiplos de 32)
  key_bits = key.size * 8
  unless [128, 160, 192, 224, 256, 288, 320].includes?(key_bits)
    STDERR.puts "Error: Anubis key must be 128, 160, 192, 224, 256, 288, or 320 bits"
    STDERR.puts "  Current key size: #{key.size} bytes (#{key_bits} bits)"
    exit 1
  end

  # Converter AAD se fornecido
  aad_bytes = aad.empty? ? Bytes.new(0) : aad.to_slice

  # Ler dados de entrada
  input_data = if !infile.empty?
                 if File.exists?(infile)
                   File.read(infile).to_slice
                 else
                   STDERR.puts "Error: Input file not found: #{infile}"
                   exit 1
                 end
               else
                 STDIN.gets_to_end.to_slice
               end

  if input_data.empty?
    STDERR.puts "Error: Input data is empty"
    exit 1
  end

  # Criar instância do Anubis-GCM
  aead = Anubis::AEAD.new(key)

  if decrypt_mode
    # Modo decriptação
    if input_data.size < 28  # 12 (nonce) + 16 (tag) = 28 minimum
      STDERR.puts "Error: Input too short (must be at least 28 bytes: nonce(12) + tag(16))"
      exit 1
    end
    
    # Extrair nonce (primeiros 12 bytes)
    nonce = Bytes.new(12)
    12.times { |i| nonce[i] = input_data[i] }
    
    # O resto é ciphertext + tag
    ciphertext_with_tag = input_data[12, input_data.size - 12]
    
    plaintext = aead.open(nonce, ciphertext_with_tag, aad_bytes)
    
    if plaintext.nil?
      STDERR.puts "Error: Authentication failed - invalid tag or corrupted data"
      exit 1
    end
    
    if !outfile.empty?
      File.write(outfile, plaintext)
      STDERR.puts "✓ Decrypted to #{outfile}"
    else
      STDOUT.write(plaintext)
    end

  else
    # Modo encriptação
    # Gerar nonce aleatório de 12 bytes
    nonce = Random::Secure.random_bytes(12)
    
    # Encriptar: ciphertext + tag
    result = aead.seal(nonce, input_data, aad_bytes)
    
    # Formato de saída: nonce (12) || ciphertext (variável) || tag (16)
    output = Bytes.new(nonce.size + result.size)
    
    # Copiar nonce
    nonce.size.times { |i| output[i] = nonce[i] }
    
    # Copiar resultado (ciphertext + tag)
    result.size.times { |i| output[nonce.size + i] = result[i] }
    
    if !outfile.empty?
      File.write(outfile, output)
      STDERR.puts "✓ Encrypted to #{outfile}"
    else
      STDOUT.write(output)
    end
  end

rescue e : Exception
  STDERR.puts "Error: #{e.message}"
  if ENV["DEBUG"]?
    STDERR.puts e.backtrace.join("\n")
  end
  exit 1
end
