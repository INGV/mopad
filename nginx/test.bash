#!/bin/bash

echo "Content-Type: text/plain"
echo ""

# https://www.parckwart.de/computer_stuff/bash_and_cgi_parsing_get_and_post_requests
function urldecode {
        local url_encoded="${1//+/ }"
        printf '%b' "${url_encoded//%/\\x}"
}

echo "++++++++++++++++++++++++"
OIFS=$IFS
IFS='=&'
parm_get=($QUERY_STRING)
parm_post=($POST_STRING)
IFS=$OIFS

declare -A get
declare -A post

for ((i=0; i<${#parm_get[@]}; i+=2)); do
        get[${parm_get[i]}]=$(urldecode ${parm_get[i+1]})
        echo "GET: ${parm_get[i]} = ${parm_get[i+1]}"
done
# echo ABC: ${get["a"]}

for ((i=0; i<${#parm_post[@]}; i+=2)); do
        post[${parm_post[i]}]=$(urldecode ${parm_post[i+1]})
        echo "POST: ${parm_post[i]} = ${parm_post[i+1]}"
done
echo "++++++++++++++++++++++++"


echo "========================"
set
echo "========================"

echo ""
