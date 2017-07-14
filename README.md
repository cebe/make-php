make-php
========

A simple script to build different PHP versions

Installation
------------

### Dependencies

At least the following packages are needed to run this:

    apt-get install  build-essential autoconf automake

A more complete set of build tools:

    apt-get install  build-essential autoconf automake git curl pkg-config bison re2c libxml2-dev

You may also need these for some build options of PHP:

    apt-get install  libicu-dev libmcrypt-dev libreadline-dev libxml2-dev libbz2-dev \
                     openssl libssl-dev libcurl4-openssl-dev libjpeg-dev libpng-dev \
                     libfreetype6-dev libmm-dev libpq-dev

### Clone Repo

After installing dependencies you can clone this repository.
The location does not matter, but I use to put it under `/srv/php-src`:

    git clone https://github.com/cebe/make-php /srv/php-src

You may want to adjust the `BUILD_TARGET` in the script.
By default PHP binaries are installed to `/srv/php`.

### GPG

The script will check the signatures of the PHP tar files it downloads, so you need to add the keys of the PHP maintainers to
you GPG trust DB. You can do it manually, or use the `make-php-keyring.sh` script:

```
./make-php-keyring.sh
```

Usage
-----

Create a `*.conf` file for each build config and a `*.pecl.conf` file if you want to statically link pecl extensions into the binary.
See `example.conf` and `example.pecl.conf` for examples.

Run the script (assuming your config is `myconfig.conf`):


    ./make-php myconfig 7.0.12

Afterwards you can use the `switch-php.sh` command to replace the existing `/usr/bin/php*` symlinks using debians `update-alternatives` system. `./switch-php.sh --reset` will restore the original PHP version that may be installed by apt.

> Tip: To enable the switch-php command, you can link it to `/usr/local/bin`:
> `ln -s /srv/php-src/switch-php.sh /usr/local/bin/switch-php`
