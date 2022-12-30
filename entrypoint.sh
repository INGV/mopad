#!/bin/bash

# An interactive shell is one started without non-option arguments and without
# the -c option whose standard input and error are both connected to terminals
# ... or one started with the -i option.

if [ "$1" == "piped" ]; then
	shift
	FLAG_PIPED=yes
fi

if [ $# -eq 0 ]; then
	# bash -i
	/etc/init.d/fcgiwrap start && nginx -g 'daemon off;'
else
	case $1 in
		plot|gmt|decompose|convert)
			if [ "${FLAG_PIPED}" == "yes" ]; then
				# output by cat last argument which must be option -f filename
				# Examples:
				#     docker run --rm  mopad piped plot 0,1,-1,0,0,0 -f tmp.svg > out.svg
				#     docker run --rm  mopad piped plot 0,1,-1,0,0,0 -f tmp.png > out.png
				bash -c "mopad $* && cat ${@: -1}"
			else
				echo "Your container args are ($#): \"$@\""
				bash -i -c "mopad $*"
			fi
			;;
		*)
			# escamotage to launch command like this:
			# Examples:
			#     docker run --rm mopad "mopad plot 0,1,-1,0,0,0 -f tmp.png && cat tmp.png" > out.png
			bash -c "$*"
			;;
	esac
fi

