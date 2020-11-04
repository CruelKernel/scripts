#!/usr/bin/env bash

NODEFAULTS=1 ./cruelbuild flash \
	model=G973F toolchain=cruel \
	+samsung \
	+magisk \
	+nohardening \
	+nodebug \
	+noswap +nozram +noksm +nomodules \
	+noatime \
	+noaudit \
	+sdfat \
	+boeffla_wl_blocker \
	+io_noop \
	+fake_config "$@"
