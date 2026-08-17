#!/bin/bash

source ../../lib/single_arg/single_arg.sh
single_arg $@

# check a file was passed
[ -z $1 ] || ! [ -f $1 ] && { echo 'Usage $0 file'; exit 1; }

# gather names
BASE_NAME="$(basename $1)"
DIR_NAME="$(dirname $1)"

# copy and ask to overwrite
cp -i "$1" \
"$DIR_NAME/$BASE_NAME-$USER-$(date "+%Y-%m-%d_%H-%M-%S" ).bak"

