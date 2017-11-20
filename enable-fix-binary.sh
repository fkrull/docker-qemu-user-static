#!/bin/sh
for file in /var/lib/binfmts/qemu-*; do
    sed -i '10s/.*/yes/' $file
done
