#!/bin/bash

# Always download to the Downloads folder.
cd ~/Downloads

# Download and extract Python 3.14.3.
wget -q --show-progress https://www.python.org/ftp/python/3.14.3/Python-3.14.3.tar.xz
tar -xf Python-3.14.3.tar.xz

# Compile Python
cd Python-3.14.3
./configure --enable-optimizations --with-openssl=/usr/local --with-ensurepip=install CFLAGS="-I/usr/include" LDFLAGS="-L/usr/lib"
make
make test
sudo make altinstall

# Verify Python installation
python3.14 --version
which python3.14
