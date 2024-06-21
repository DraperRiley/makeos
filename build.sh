#!/bin/bash

export CC=gcc
export LD=ld
export CXX=g++
cmake --build . --verbose

if [ -f MakeOS ]; then
	echo "MakeOS built, creating ISO image"
	mkdir -p isodir/boot/grub
	cp grub.cfg isodir/boot/grub
	cp MakeOS isodir/boot/
	grub-mkrescue -o MakeOS.iso isodir/
else
	echo "Unable to find OS image"
fi
