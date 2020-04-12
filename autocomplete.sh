#!/usr/bin/env bash -x

_build_completions() {
	current="${COMP_WORDS[COMP_CWORD]}"
	commands=("config" "build" "mkimg" "flash")
	now_commands=(":build" ":mkimg" ":flash")

	#if [[ ${COMP_CWORD} == 1 ]]
	#then
	#	COMPREPLY+=($(compgen -W "${commands[@]}" -- ${current}))
	#	return 0
	#fi

	special=("name=" "os_patch_level=" "model=")

	default_enabled=()
	for i in kernel/configs/cruel+*.conf
	do
		flag="$(echo $(basename "$i" .conf) | cut -d '+' -f 2)"
		default_enabled+=("${flag}")
	done

	default_disabled=()
	for i in kernel/configs/cruel-*.conf
	do
		flag="$(echo $(basename "$i" .conf) | cut -d '-' -f 2)"
		default_disabled+=("${flag}")
	done

	enabled=()
	disabled=()
	for i in "${COMP_WORDS[@]}"
	do
		if [[ " ${array[@]} " =~ " ${i} " ]]
		then
		fi
	done

	for i in "${enabled[@]}" "${disabled[@]}"
	do
		COMPREPLY+=("$i")
	done
}

 complete -F _build_completions build
