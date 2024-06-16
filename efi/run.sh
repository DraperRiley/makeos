#!/bin/bash

BOOTLOADER=~/uefibootloader/boot/uefi
BOOTBUILD=$BOOTLOADER/build/images

make clean
make

(cd $BOOTLOADER && make clean && make)
cp myOS $BOOTBUILD

(cd $BOOTLOADER && ./uefiqemu.sh)
