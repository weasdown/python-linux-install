#!/bin/bash

# Always download to the Downloads folder.
cd ~/Downloads

# Download and extract openssl 3.6.1.
wget https://www.openssl.org/source/openssl-3.6.1.tar.gz
tar -zxf openssl-3.6.1.tar.gz

# Compile openssl.
cd openssl-3.6.1
./config
make
sudo make install

# Copy libraries for openssl to /usr/lib.
sudo cp -r libssl.so.3 /usr/lib
sudo cp -r libcrypto.so.3 /usr/lib

# Update library links.
sudo ldconfig /usr/lib

# Verify openssl installation
openssl version
which openssl

# Always return to the Downloads folder.
cd ~/Downloads
