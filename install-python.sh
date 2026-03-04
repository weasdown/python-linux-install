#!/bin/bash

# Always download to the Downloads folder.
cd ~/Downloads

# Download and extract Python 3.14.3.
wget -q --show-progress https://www.python.org/ftp/python/3.14.3/Python-3.14.3.tar.xz
tar -xf Python-3.14.3.tar.xz

# Compile Python
cd Python-3.14.3
./configure --enable-optimizations --with-openssl=/usr/local --with-ensurepip=install CFLAGS="-I/usr/include" LDFLAGS="-L/usr/lib"

num_cores=$(nproc --all)  # Get number of available CPU cores.

make -j$num_cores
make test -j$num_cores
sudo make altinstall -j$num_cores

# Verify Python installation
printf "\nNew Python 3.14 version: %s\n" "$(python3.14 --version)"
printf "\nPython 3.14 installed in: %s\n" "$(which python3.14)"
