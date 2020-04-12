#!/bin/bash

set -e

export ARCH=arm64
export ANDROID_MAJOR_VERSION=q

for i in arch/arm64/configs/exynos9820-*defconfig
do
	config=$(basename $i)
	make $config
	make olddefconfig
	cp .config $i
done
