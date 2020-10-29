#!/bin/bash

set -e

V=$1

if [[ "x$V" == "x" ]]; then
	echo "Please, specify the kernel version"
	echo "and don't forget to create a named tag."
	exit 1
fi

export ARCH=arm64
export ANDROID_MAJOR_VERSION=q
git clean -d -x -f
make mrproper

for i in build.mkbootimg.*
do
	model=$(echo $i | cut -d '.' -f 3)
        ./build mkimg            \
                model=$model     \
                name="CRUEL-$V"  \
                +magisk          \
                +nohardening     \
                +ttl             \
                +wireguard       \
                +cifs            \
                +ntfs            \
                +morosound       \
                +boeffla_wl_blocker
	mv boot-$model.img CruelKernel-$model-$V.img
done
