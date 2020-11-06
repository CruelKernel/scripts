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

./cruelbuild pack           \
	model=all           \
	name="Cruel-$V"     \
	toolchain=cruel     \
	O=buildtree         \
	+magisk             \
	+nohardening        \
	+ttl                \
	+cifs               \
	+ntfs               \
	+sdfat              \
	+wireguard          \
	+noaudit            \
	+noksm              \
	+nomodules          \
	+fake_config        \
	+usb_serial         \
	+mass_storage       \
	+sched_powersave    \
	+sched_performance  \
	+morosound          \
	+boeffla_wl_blocker
