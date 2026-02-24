#!/bin/bash

# Prints a "- Complete" message indented by one tab stop.
complete () {
    printf "\t- Complete\n"
}

version="3.6.1"
library="openssl-$version"

# Always download to the Downloads folder.
user="$(whoami)"
cd /home/$user/Downloads
printf "Switched to %s\n\n" "$(pwd)"

# Remove any existing copies of this version of the library to ensure we start from fresh.
printf "\nRemoving any existing copies of %s...\n\n" $library
rm -rf $library*

# Download and extract openssl 3.6.1.
filename="$library.tar.gz"
url="https://www.openssl.org/source/$filename"
printf "Downloading %s from %s...\n" $library $url
wget -q --show-progress $url

printf "Extracting %s...\n" $filename
tar -zxf $filename

# Setup variables for log files.
configure_log="/home/$user/Downloads/openssl-configure.log"
make_log="/home/$user/Downloads/openssl-make.log"
make_install_log="/home/$user/Downloads/openssl-make-install.log"

# Compile openssl.
cd openssl-3.6.1
printf "\nSwitched to %s\n" "$(pwd)"
printf "Configuring %s...\n" $library

./config &> $configure_log
code=$(echo $?)
if [[ $code -eq 0 ]]; then  # echo $? gives the return code of the most recent command - 0 for success.
    printf "\t- Success!"
else
    printf "\nConfigure failed with code %d!\n" $code
    exit
fi

# printf "\nMaking %s...\n" $library
# make &> $make_install_log

# # TODO work out how to run sudo commands
# sudo make install &> $make_install_log

# # Copy libraries for openssl to /usr/lib.
# sudo cp -r libssl.so.3 /usr/lib
# sudo cp -r libcrypto.so.3 /usr/lib

# # Update library links.
# sudo ldconfig /usr/lib

# # Verify openssl installation
# openssl version
# which openssl

# Always return to the Downloads folder.
cd ~/Downloads

printf "\nDone!\n"
