#!/bin/bash

array=(
commits...
)

for i in ${array[*]}
do
	cd common/
	git clean -d -f
	git checkout "$i"
	cd -
	diff -r common/ samsung_kernel/ | grep -v 'Only in' > "$i.diff"
done

ls -Ssr1 *.diff

