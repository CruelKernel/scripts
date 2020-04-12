#!/bin/bash

set -e

if [[ -z "$1" ]]
then
	echo "$0 <firmware.zip>" >&2
	echo "$0 <dir>" >&2
	exit 1
fi

UNPACK="files"

if [[ -f "$1" ]]
then

	rm -fr "$UNPACK"

	set -x

	# Extract zip
	unzip "$1" -d "$UNPACK"
	cd "$UNPACK"
	# Rename md5
	for i in *; do mv $i ${i/.md5/}; done
	# Extract all files
	for i in *;
	do
		dir=$(echo $i | cut -d '_' -f 1)
		# Skip HOME_CSC
		if [[ $dir == HOME ]]
		then
			rm $i
			continue
		fi
		mkdir -p $dir
		tar xf $i -C $dir
		cd $dir
		lz4 --rm -dm *.lz4
		cd -
		rm $i
	done

	cd ..

	set +x

elif [[ -d "$1" ]]
then
	UNPACK="$1"
else
	echo "'$1' not a dir nor a file" >&2
	exit 2
fi

# find pit file
PITFILE=$(find "$UNPACK" -type f -name '*.pit')

if [[ ! -r $PITFILE ]]
then
	echo "Can't find PIT file in dir '$UNPACK'" >&2
	exit 3
fi

HM_ARGS=$(./find_flash_files.pl \
	<(heimdall print-pit --file $PITFILE --no-reboot) \
	<(find "$UNPACK" -type f \( -name '*.img' -or -name '*.bin' \)))

echo heimdall flash --pit $PITFILE $HM_ARGS
