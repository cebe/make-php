#!/bin/sh
#
# Adds all people who have signed PHP releases to GPG
# http://php.net/downloads.php#gpg-7.1
#

KEYS=""
KEYS="$KEYS C2BF0BC433CFC8B3" # Ferenc Kovacs <tyrael@php.net>
KEYS="$KEYS FE857D9A90D90EC1" # Julien Pauli <jpauli@php.net>
KEYS="$KEYS C13C70B87267B52D" # David Soria Parra <dsp@php.net>
KEYS="$KEYS 2F7956BC5DA04B5D" # Stanislav Malyshev (PHP key) <stas@php.net>
KEYS="$KEYS 7DEC4E69FC9C83D7" # Johannes Schlüter <johannes@php.net>
KEYS="$KEYS BCAA30EA9C0D5763" # Anatol Belski <ab@php.net>
KEYS="$KEYS F50ABC807BD5DCD0" # Davey Shafik <davey@php.net>
KEYS="$KEYS F9BA0ADA31CBD89E" # Joe Watkins <krakjoe@php.net>
KEYS="$KEYS DC9FF8D3EE5AF27F" # Remi Collet <remi@php.net>

# alternative keyserver: pgp.mit.edu
if [ "$1" != "" ] ; then
    KEYSERVER="$1"
fi
if [ "$KEYSERVER" = "" ] ; then
    KEYSERVER="pool.sks-keyservers.net"
fi
gpg --batch --keyserver $KEYSERVER --recv-keys $KEYS

