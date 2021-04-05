#!/bin/bash

set -e

CWD=$(pwd)

model="$(echo "$1" | cut -d '-' -f 2 | cut -d '_' -f 1)"

git submodule foreach git checkout default
rm -fr $(ls -A | grep -v toolchain | grep -v .git)
unzip "$1" Kernel.tar.gz
tar xf Kernel.tar.gz
rm Kernel.tar.gz


chmod -x arch/arm64/configs/*
chmod -x drivers/misc/tzdev/startup.tzar || true
chmod -x firmware/tsp_sec/y761_beyond0_phole.bin || true
chmod -x drivers/gator/mali_midgard.mk
chmod -x drivers/net/wireless/broadcom/bcmdhd_100_10/Makefile.kk || true
chmod -x drivers/net/wireless/broadcom/bcmdhd_100_10/Makefile.lp || true
chmod -x drivers/net/ethernet/cadence/macb_ptp.c
chmod -x drivers/gator/COPYING

find . -type f \( -name '*.dts' -o -name '*.dtsi' -o -name '*.[ch]' -o -name '*.ihex' -o -name Kbuild -o -name Kconfig -o -name Makefile \) -executable -print0 | xargs -0 -n5000 -P$(nproc) chmod -x

#git checkout `git status | grep deleted | cut -d ':' -f 2 | cut -d ' ' -f 5`

find . -type f -print | fgrep -v './firmware' | fgrep -v './.git' | fgrep -v './toolchain' | xargs -n5000 -P$(nproc) dos2unix -q

git checkout `git diff --no-color | fgrep --color=never -B 2 -e "new mode" | fgrep --color=never diff | cut -d '/' -f 2- | cut -d ' ' -f 1`

objdump="$CWD"/scripts/toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9/bin/aarch64-linux-android-objcopy

if [[ ! -f $objdump ]]; then
	objdump="$CWD"/toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9/bin/aarch64-linux-android-objcopy
fi

$objdump --version

find . -type f -name '*.bin' -exec $objdump -I binary -O ihex '{}' '{}'.ihex \;
find . -type f -name '*.fw'  -exec $objdump -I binary -O ihex '{}' '{}'.ihex \;

sed -i -e 's/\r/\n/g' drivers/video/fbdev/exynos/dpu20/mcd_hdr/mcd_cm_def.h || true
sed -i -e 's/\r/\n/g' drivers/video/fbdev/exynos/dpu20/mcd_hdr/mcd_cm_lut.h || true

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep arm64 | \grep boot | \grep dts | \grep -v samsung | \grep -v exynos)
#git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep arm64 | \grep boot | \grep dts)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep Documentation)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep arm64 | \grep configs)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep build | \grep config)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep fiq_debugger)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \fgrep 'npu-config.h')

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \fgrep 'olog.pb.h')

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \fgrep 'w9020_davinci.fw.ihex')

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \fgrep 'build.bp')

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \fgrep 'tg3')

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \fgrep 'clang-android')

mv arch/arm64/boot/dts/Makefile arch/arm64/boot/dts/$model.mk
#mv arch/arm64/boot/dts/exynos/Makefile arch/arm64/boot/dts/exynos/$model.mk

rm -f security/defex_lsm/file_list
rm -f security/defex_lsm/build_defex_log

rm -fr security/samsung/defex_lsm/build_defex_log security/dsms/ security/defex_lsm/
#rm -fr scripts/toolchain
#rm -fr toolchain
