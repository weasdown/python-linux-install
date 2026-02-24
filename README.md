# python-linux-install

Scripts to simplify installing Python on Linux. Thanks to [eykamp] for their really useful [guide], without which this would not have been possible.

## Setting up the scripts

First, clone this repository:

`git clone https://github.com/weasdown/python-linux-install.git`

Enter the repository's folder then make the scripts executable:

```bash
cd python-linux-install
chmod +x ./install-openssl.sh
chmod +x ./install-python.sh
```

## Installing openssl

For Python to install properly, you must have a fully working version of the `openssl` library. We assume we cannot trust the version already installed in your system, so we download a fresh copy from the OpenSSL website then compile and install it.

**To install `openssl`, run:**

```bash
sudo ./install-openssl.sh
```

At the time of writing, OpenSSL version 3.6.1 is installed by the script, with no way to choose another version. Selecting a version will be implemented later.

## Installing Python

Once openssl has been correctly installed, we can move on to installing our chosen version of Python.

**To install Python, run:**

```bash
sudo ./install-python.sh
```

At the time of writing, Python version 3.14.3 is installed by the script, with no way to choose another version. Selecting a version will be implemented later.

<!-- Links -->
[eykamp]: https://github.com/eykamp
[guide]: https://gist.github.com/eykamp/93874e8f3adc97a5dea243a4ad8c5f38
