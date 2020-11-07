#!/usr/bin/env bash

NODEFAULTS=y FLASH=y ./cruelbuild \
	toolchain=cruel \
	+samsung \
	+magisk \
	+nohardening \
	+nodebug \
	+noswap +noksm +nomodules \
	+noatime \
	+noaudit \
	+sdfat \
	+boeffla_wl_blocker \
	+fake_config "$@"
