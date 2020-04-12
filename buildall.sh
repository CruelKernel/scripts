#!/bin/bash

V=$1

export ARCH=arm64
export ANDROID_MAJOR_VERSION=q
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
                +sdfat           \
                +ntfs            \
                +morosound       \
                +boeffla_wl_blocker
	mv boot.img CruelKernel-$model-$V.img
done
