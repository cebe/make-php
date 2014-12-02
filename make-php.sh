#!/bin/sh -e

if [ "$2" = "" ] ; then
	echo "usage: $0 <conf> <php-version>"
	echo ""
	echo "<conf>        - the name of the config file without .conf"
	echo "<php-version> - the PHP version to build. e.g. 5.6.2"
	exit 1
fi

PHP="php-$2"
BUILD_NAME=$1
BUILD_TARGET="/srv/php"

URL="http://de1.php.net/get/$PHP.tar.bz2/from/this/mirror"
SIG="http://de1.php.net/get/$PHP.tar.bz2.asc/from/this/mirror"

echo "preparing to build PHP $PHP with config $BUILD_NAME..."
# get build conf
if [ ! -f $BUILD_NAME.conf ] ; then
	echo "$BUILD_NAME.conf does not exist!"
	exit 1
fi
MAKECONFIG=$(while read line; do echo -n "$line "; done < $BUILD_NAME.conf)

mkdir -p build
cd build

# download sources if not already done
if [ ! -d $PHP ] ; then

	wget $URL -O $PHP.tar.bz2
	wget $SIG -O $PHP.tar.bz2.asc

	gpg --trust-model always --verify $PHP.tar.bz2.asc

	tar xjf $PHP.tar.bz2
fi

cd $PHP

apt-get -y install libicu-dev libmcrypt-dev libreadline-dev

# get pecl packages to compile statically into the binary
if [ -f "../../$BUILD_NAME.pecl.conf" ] ; then
	apt-get -y install autoconf automake
	while read line
	do
		cd ext
		if [ ! -d $line ] ; then
			pecl download $line
			mv $line*.tgz $line.tgz
			gzip -d < $line.tgz | tar -xvf -
			mv $line-* $line
		fi
		cd ..
	done < ../../$BUILD_NAME.pecl.conf
	rm configure
	./buildconf --force
fi

# conigure PHP
echo ""
echo "running configure..."
echo ""
PREFIX="$BUILD_TARGET/${PHP}_$BUILD_NAME"
./configure --prefix=$PREFIX --sysconfdir=/etc --mandir=$PREFIX/man --with-config-file-path=$PREFIX/conf $MAKECONFIG

echo ""
echo "make..."
echo ""
make
make install

echo ""
echo "success! Your PHP installation is now in $PREFIX."
echo ""

cd .. # exit $PHP
cd .. # exit build



