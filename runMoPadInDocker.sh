#!/bin/bash

DIRNAME="`dirname $0`"

# General based on ifconfig
MYIP="`ifconfig | grep -w inet | egrep -v -w "127.0.0.1" | awk '{print $2}' | head -n 1`"

xhost +${MYIP} || exit

docker run --rm -it \
	-e DISPLAY=${MYIP}:0 \
	--mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
	ingv/mopad \
	$@
