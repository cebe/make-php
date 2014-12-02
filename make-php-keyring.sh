#!/bin/sh
#
# Adds all people who have signed PHP releases to GPG
# http://php.net/downloads.php#gpg-5.6
#

KEYS=""
KEYS="$KEYS 33CFC8B3" # Ferenc Kovacs <tyrael@php.net>
KEYS="$KEYS 90D90EC1" # Julien Pauli <jpauli@php.net>
KEYS="$KEYS 7267B52D" # David Soria Parra <dsp@php.net>
KEYS="$KEYS 5DA04B5D" # Stanislav Malyshev (PHP key) <stas@php.net>
KEYS="$KEYS FC9C83D7" # Johannes Schlüter <johannes@php.net>

gpg --keyserver pgp.mit.edu --recv-keys $KEYS


