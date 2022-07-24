#!/bin/bash

set -e

V=$1

if [[ "x$V" == "x" ]]; then
	echo "Please, specify the kernel version"
	echo "and don't forget to create a named tag."
	exit 1
fi

export ARCH=arm64
export ANDROID_MAJOR_VERSION=r
export PLATFORM_VERSION=11
sudo umount build || true
git clean -d -x -f
make mrproper

mkdir -p ../out
for t in default cruel
do
./cruelbuild pack           \
	model=all           \
	name="Cruel-$V"     \
	toolchain=$t        \
	O=build             \
	+magisk             \
	+nohardening        \
	+force_dex_wqhd     \
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
	+sched_powersave    \
	+sched_performance  \
	+morosound          \
	+boeffla_wl_blocker \
	+dtb

mv CruelKernel.zip ../out/CruelKernel-$V-$t.zip
done

./cruelbuild pack           \
	model=all           \
	name="Cruel-$V"     \
	toolchain=cruel     \
	O=build             \
	+magisk             \
	+nohardening        \
	+force_dex_wqhd     \
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
	+sched_powersave    \
	+sched_performance  \
	+morosound          \
	+boeffla_wl_blocker \
	+dtb                \
	+50hz

mv CruelKernel.zip ../out/CruelKernel-$V-50hz.zip
