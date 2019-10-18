#!/bin/bash

# This isn't really a script, more a collection of commands you can run manually to reverse the steps from encrypt.sh


# 1. Verify checksum
# This generates a SHA256 checksum of the archive, that you can then manually compare to the checksum in checksum.sha256
openssl dgst -sha256 archive.zip

# 2. Decrypt sym key
openssl rsautl -decrypt -inkey rsakey -in aeskey -out aeskey.txt

# 3. Decrypt archive
# fill in the key and IV values from the decrypted AES key file (aeskey.txt)
openssl enc -d -aes-256-cbc -K <key-value-from-aeskey.txt> -iv <iv-value-from-aeskey.txt> -in archive.zip -out archive.zip.raw

# 4. Unzip archive
unzip -d . archive.zip.raw
