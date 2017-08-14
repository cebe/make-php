make-php
========

A simple script to build different PHP versions for development. It uses the debian alternatives system to replace the 
system-wide PHP binaries and allows resetting to defaults if the PHP binaries installed via the package manager should be used.

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

### Building a PHP binary 

Create a `*.conf` file for each build config. If you want to statically link pecl extensions into the binary you may list the
names of the extensions in `*.pecl.conf`.
See `example.conf` and `example.pecl.conf` for examples.

Run the script (assuming your config is `myconfig.conf`):

    ./make-php myconfig 7.0.12

Afterwards you can use the `switch-php.sh` command to replace the existing `/usr/bin/php*` symlinks using debians `update-alternatives` system. `./switch-php.sh --reset` will restore the original PHP version that may be installed by apt.

> Tip: To enable the switch-php command, you can link it to `/usr/local/bin`:
> `ln -s /srv/php-src/switch-php.sh /usr/local/bin/switch-php`

### Builing alpha/beta releases

If you want to install PHP versions that are not officially released or pre-releases like alpha versions, you can specify a URL for the file to download. E.g. to install PHP 7.2.0alpha3 use the following command:

    ./make-php.sh myconfig 7.2.0alpha3 https://downloads.php.net/~remi/php-7.2.0alpha3.tar.bz2 https://downloads.php.net/~remi/php-7.2.0alpha3.tar.bz2.asc

### Applying patches

If you want to apply patches to the PHP source code, e.g. to fix some bugs or apply workarounds in your specific version, you
can place a `.patch` file in the `patches/php-$VERSION` directory. All patch files found in that directory will be applied
before building PHP.

E.g. to apply the [fix for finding cURL on debian](https://github.com/php/php-src/pull/2632) on PHP 7.1.8, you can create a file containing the [patch](https://patch-diff.githubusercontent.com/raw/php/php-src/pull/2632.patch) in `patches/php-7.1.8/curlfix.patch`.

