#!/bin/bash
#
# a script to manage different PHP versions on one system
#
# author: Carsten Brandt <mail@cebe.cc>
#

# where are the different php distributions located?
PHPDIR=/srv/php

# function to show usage help
usage(){
	echo "usage:"
	echo "  $0 <buildname>   - switch php to <buildname>"
	echo "  $0 --reset       - reset system to use natively installed php version"
	echo ""
	echo "the following names are available:"
	echo ""
	ls $PHPDIR
	echo ""
	echo "you can add a new one by building php with --prefix=$PHPDIR/<buildname>"
}

# no arg shows help
if [ "$1" = "" ] ; then
	usage
	exit 1
fi

if [ ! "$1" = "--reset" ] ; then
	# check if desired php dist is available
	if [ ! -d "$PHPDIR/$1" ] ; then
		echo "$PHPDIR/$1 does not exist!"
		echo ""
		usage
		exit 1
	fi
fi

echo "removing existing alternatives..."
for p in $(update-alternatives --list php | grep "$PHPDIR") ; do
	update-alternatives --remove php $p
done
for p in $(update-alternatives --list phpize | grep "$PHPDIR") ; do
	update-alternatives --remove phpize $p
done
for p in $(update-alternatives --list php-config | grep "$PHPDIR") ; do
	update-alternatives --remove php-config $p
done
for p in $(update-alternatives --list php-cgi | grep "$PHPDIR") ; do
	update-alternatives --remove php-cgi $p
done
for p in $(update-alternatives --list php-fpm | grep "$PHPDIR") ; do
	update-alternatives --remove php-fpm $p
done
echo "done."

if [ ! "$1" = "--reset" ] ; then
	echo "switching PHP to $1..."

	update-alternatives --install /usr/bin/php php $PHPDIR/$1/bin/php 10 \
	                    --slave /usr/share/man/man1/php.1.gz php.1.gz $PHPDIR/$1/man/man1/php.1
	update-alternatives --set php $PHPDIR/$1/bin/php
	update-alternatives --install /usr/bin/phpize phpize $PHPDIR/$1/bin/phpize 10 \
	                    --slave /usr/share/man/man1/phpize.1.gz phpize.1.gz $PHPDIR/$1/man/man1/phpize.1
	update-alternatives --set phpize $PHPDIR/$1/bin/phpize
	update-alternatives --install /usr/bin/php-config php-config $PHPDIR/$1/bin/php-config 10 \
	                    --slave /usr/share/man/man1/php-config.1.gz php-config.1.gz $PHPDIR/$1/man/man1/php-config.1
	update-alternatives --set php-config $PHPDIR/$1/bin/php-config
	update-alternatives --install /usr/bin/php-cgi php-cgi $PHPDIR/$1/bin/php-cgi 10 \
	                    --slave /usr/share/man/man1/php-cgi.1.gz php-cgi.1.gz $PHPDIR/$1/man/man1/php-cgi.1
	update-alternatives --set php-cgi $PHPDIR/$1/bin/php-cgi
	if [ -f $PHPDIR/$1/sbin/php-fpm ] ; then
		update-alternatives --install /usr/sbin/php-fpm php-fpm $PHPDIR/$1/sbin/php-fpm 10 \
		            --slave /usr/share/man/man8/php-fpm.8.gz php-fpm.8.gz $PHPDIR/$1/man/man8/php-fpm.8
		update-alternatives --set php-fpm $PHPDIR/$1/bin/php-fpm
	fi

	echo "done."
fi


