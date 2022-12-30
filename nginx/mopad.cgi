#!/bin/bash
echo "Content-Type: image/png"
echo ""

# Only for debug
# date >> /tmp/mopad_exec_time 2>&1

# https://www.parckwart.de/computer_stuff/bash_and_cgi_parsing_get_and_post_requests
function urldecode {
        local url_encoded="${1//+/ }"
        printf '%b' "${url_encoded//%/\\x}"
}

OIFS=$IFS
IFS='=&'
parm_get=($QUERY_STRING)
parm_post=($POST_STRING)
IFS=$OIFS

declare -A get
declare -A post

for ((i=0; i<${#parm_get[@]}; i+=2)); do
        get[${parm_get[i]}]=$(urldecode ${parm_get[i+1]})
done

for ((i=0; i<${#parm_post[@]}; i+=2)); do
        post[${parm_post[i]}]=$(urldecode ${parm_post[i+1]})
done

# Color
MOPAD_OPT_COLOR="red"

if [ ! -z "${get[color]}" ]; then
        MOPAD_OPT_COLOR="${get[color]}"
fi

# Lamber projection
MOPAD_OPT_PROJECTION="-p l"
# Complete mopad options
MOPAD_OPT="${MOPAD_OPT_PROJECTION} -r ${MOPAD_OPT_COLOR}"

TMPFILE=$(mktemp /tmp/mopad.XXXXXXXXX.png)

python -m mopad plot ${get["plot_arg"]} ${MOPAD_OPT} -f ${TMPFILE} && cat ${TMPFILE}

rm -f ${TMPFILE}

