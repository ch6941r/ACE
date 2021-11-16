#! /usr/bin/env bash
# CREATED BY: Chris Halsall
# DATE CREATED: 16/11/2021
# VERSION: V0.1

echo "gzipping $1 to /usr/shar/man/man$2"
gzip -k $1
sudo cp "$1.gz" "/usr/share/man/man$2"
rm "$1.gz"
echo "Done"
