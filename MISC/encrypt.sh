#!/bin/bash

# This is a script to take an existing directory and zip it up and encrypt it.
# First it zips up the directory, then it generates an AES key and uses it to encrypt the zip file.
# Then it uses a public key to encrypt the AES key. That encrypted key file and the encrypted zip
# file are then transmitted to the other party.
#
# This was made for test purposes. Although the process itself can be FIPS 140-2 compliant, the way
# the process is implemented in this script isn't necessarily all compliant.
#
# Usage:
#   ./encrypt.sh
#
# Notes:
#  - run the generate-rsa-keypair.sh script first to generate the RSA public/private key pair
#  - the directory to be encrypted must be named "archive" and must be under the current directory
#
# It produces 3 files:
#   - aeskey (this is the encrypted AES key)
#   - archive.zip (this is the encrypted zip file)
#   - checksum.sha256 (this is a sha256 checksum of the encrypted zip file)
#

PUB_KEY_PATH=$(pwd)/rsakey.pub.pem

TARGET_DIR=$(pwd)
ARCHIVE_FILE="$TARGET_DIR"/archive
ZIP_ARCHIVE_FILE="$ARCHIVE_FILE".zip.raw
ENC_ZIP_ARCHIVE_FILE="$ARCHIVE_FILE".zip
SYM_KEY_FILE="$TARGET_DIR"/aeskey.txt
ENC_SYM_KEY_FILE=aeskey
CHECKSUM_FILE=checksum.sha256

cd $TARGET_DIR

# Compress the archive
# gzip < "$ARCHIVE_FILE" > "$ZIP_ARCHIVE_FILE"
echo "Zipping directory to $ZIP_ARCHIVE_FILE..."
zip -r "$ZIP_ARCHIVE_FILE" "$ARCHIVE_FILE"

# Generate a random key and IV
echo "Generating a random AES key and IV..."
KEY=`openssl rand -hex 32`
IV=`openssl rand -hex 16`
echo "key = $KEY"
echo "IV  = $IV"
printf "key=$KEY\niv =$IV" > "$SYM_KEY_FILE"

# Generate aes-256 key and use it to encrypt the compressed archive
echo "Encrypting zip file with AES key..."
openssl enc -e -aes-256-cbc -in "$ZIP_ARCHIVE_FILE" -K "$KEY" -iv "$IV" -nosalt -out "$ENC_ZIP_ARCHIVE_FILE"

# Encrypt aes key w/ pub key
echo "Encrypting AES key with public key..."
openssl rsautl -encrypt -pubin -inkey "$PUB_KEY_PATH" -in "$SYM_KEY_FILE" -out "$ENC_SYM_KEY_FILE"

# Generate checksum
echo "Generating checksum..."
openssl dgst -sha256 "$ENC_ZIP_ARCHIVE_FILE" > "$CHECKSUM_FILE"
cat "$CHECKSUM_FILE" | sed -e 's/^SHA256(.*)= //g' > "$CHECKSUM_FILE"2
mv "$CHECKSUM_FILE"2 "$CHECKSUM_FILE"

# Hide intermediate files
echo "Cleaning up..."
rm "$SYM_KEY_FILE"
rm "$ZIP_ARCHIVE_FILE"
echo "Done"
