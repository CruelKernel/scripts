#!/bin/bash

CWD=$(pwd)

rm -fr *
unzip "$1" Kernel.tar.gz
tar xf Kernel.tar.gz
rm Kernel.tar.gz

find . -type f \( -name '*.dts' -o -name '*.dtsi' -o -name '*.[ch]' -o -name '*.ihex' -o -name Kbuild -o -name Kconfig -o -name Makefile \) -executable -print0 | xargs -0 -n5000 -P$(nproc) chmod -x

#git checkout `git status | grep deleted | cut -d ':' -f 2 | cut -d ' ' -f 5`

find . -type f -print | fgrep -v './firmware' | fgrep -v './.git' | fgrep -v './toolchain' | xargs -n5000 -P$(nproc) dos2unix -q

git checkout `git diff --no-color | fgrep --color=never -B 2 -e "new mode" | fgrep --color=never diff | cut -d '/' -f 2- | cut -d ' ' -f 1`

find . -type f -name '*.bin' -exec "$CWD"/toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9/bin/aarch64-linux-android-objcopy -I binary -O ihex '{}' '{}'.ihex \;

find . -type f -name '*.fw' -exec "$CWD"/toolchain/gcc-cfp/gcc-cfp-jopp-only/aarch64-linux-android-4.9/bin/aarch64-linux-android-objcopy -I binary -O ihex '{}' '{}'.ihex \;

sed -i -e 's/\r/\n/g' drivers/video/fbdev/exynos/dpu20/mcd_hdr/mcd_cm_def.h
sed -i -e 's/\r/\n/g' drivers/video/fbdev/exynos/dpu20/mcd_hdr/mcd_cm_lut.h

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep arm64 | \grep boot | \grep dts | \grep -v samsung | \grep -v exynos)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep Documentation)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep arm64 | \grep configs)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep build | \grep config)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \grep fiq_debugger)

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \fgrep 'npu-config.h')

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \fgrep 'olog.pb.h')

git checkout $(\git status | \grep deleted | cut -d ':' -f 1- | cut -d ' ' -f 5- | \fgrep 'w9020_davinci.fw.ihex')

rm -fr security/samsung/defex_lsm/build_defex_log security/dsms/ security/defex_lsm/
