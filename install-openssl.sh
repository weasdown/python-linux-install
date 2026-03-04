#!/bin/bash
# Script for installing the openssl library.

version="3.6.1"  # TODO make openssl library version an agrument.
library="openssl-$version"

# Always download to the Downloads folder.
user="$(whoami)"
downloads="/home/$user/Downloads"
cd $downloads
printf "Switched to %s\n\n" "$(pwd)"

# Remove any existing copies of this version of the library to ensure we start from fresh.
printf "Removing any existing copies of %s...\n\n" $library
rm -rf $library*

# Download and extract openssl 3.6.1.
filename="$library.tar.gz"
url="https://www.openssl.org/source/$filename"
printf "Downloading %s from %s...\n" $library $url
# Download openssl archive. --no-check-certificate argument is required because we assume we do not have a working install of openssl.
wget -q --show-progress --no-check-certificate $url

printf "Extracting %s...\n" $filename
tar -zxf $filename  # Extract downloaded archive.
rm $filename  # Remove downloaded archive.

# Setup variables for log files.
logs_dir="openssl-logs"
mkdir -p $logs_dir  # -p argument ignores an existing directory.
configure_log="$downloads/$logs_dir/openssl-$version-configure.log"
make_log="$downloads/$logs_dir/openssl-$version-make.log"
make_install_log="$downloads/$logs_dir/openssl-$version-make-install.log"

# Remove old log files.
printf "\nRemoving old logs\n"
rm -f $configure_log
rm -f $make_log
rm -f $make_install_log

## Compile openssl.
# Configure openssl.
cd openssl-3.6.1
printf "\nSwitched to %s\n" "$(pwd)"
printf "Configuring %s...\n" $library

./config &> $configure_log
configure_code=$(echo $?)    # echo $? gives the return code of the most recent command - 0 for success.
if [[ $configure_code -eq 0 ]]; then
    printf "\t- Success!\n"
else
    printf "\n\t- Configure failed with code %d!\n" $configure_code
    exit
fi

num_cores=$(nproc --all)  # Get number of available CPU cores.

# Make openssl.
printf "\nMaking %s... This will take a while.\n" $library
make -j$num_cores &> $make_log

make_code=$(echo $?)
if [[ $make_code -eq 0 ]]; then
    printf "\t- Success!\n"
else
    printf "\n\t- Make failed with code %d!\n" $make_code
    exit
fi

# Make install openssl.
printf "\nMake installing %s... This will take a while.\n" $library
sudo make install -j$num_cores &> $make_install_log

make_install_code=$(echo $?)
if [[ $make_install_code -eq 0 ]]; then
    printf "\t- Success!\n"
else
    printf "\n\t- Make install failed with code %d!\n" $make_install_code
    exit
fi

# Copy libraries for openssl to /usr/lib.
system_library_path="/usr/lib"
sudo cp libssl.so.3 $system_library_path #-r libssl.so.3 $system_library_path  # FIXME remove -r version - ?breaks sudo
sudo cp libcrypto.so.3 $system_library_path #-r libcrypto.so.3 $system_library_path  # FIXME remove -r version - ?breaks sudo
printf "\nLibraries copied to %s\n" $system_library_path

# Update library links.
library_update_command="sudo ldconfig $system_library_path"
$($library_update_command)
library_update_code=$(echo $?)
if [[ $library_update_code -eq 0 ]]; then
    printf "\t- Success!\n"
else
    printf "\n\t- \"$library_update_command\" failed with code %d!\n" $library_update_code
    exit
fi

# Update certificates to fix wget.
sudo ln -s  /etc/ssl/certs/ca-certificates.crt /usr/local/ssl/cert.pem

# Verify openssl installation
printf "\nNew openssl version:\n%s\n" "$(openssl version)"
printf "\nopenssl installed in: %s\n" "$(which openssl)"

printf "\nDone!\n\n"
