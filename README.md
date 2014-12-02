make-php
========

A simple script to build different PHP versions

Installation
------------

At least the following packages are needed to run this:

```
apt-get install autoconf automake
```

You may also need these for some build options of PHP:

```
apt-get install libicu-dev libmcrypt-dev libreadline-dev
```

Adjust the `BUILD_TARGET` in the script. By default PHP binaries are installed to `/srv/php`.

Usage
-----

Create a `*.conf` file for each build config and a `*.pecl.conf` file if you want to statically link pecl extensions into the binary.

Run the script (assuming your config is `myconfig.conf`):

```
./make-php myconfig 5.6.2
```
