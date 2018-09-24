#!/bin/sh

set -e

NOCOLOR='\033[0m'
PURPLE='\033[1;35m'
BLUE='\033[1;34m'

CONFIGS="$(pwd)/configs"

if [ -d ${CONFIGS} ]; then

    for DIR in ${CONFIGS}/*; do
        COMMAND="msync update"
        DIRNAME=$(basename ${DIR})
        HEADER="=== ${PURPLE}${COMMAND} ${BLUE}${DIRNAME}${NOCOLOR} ==="

        echo && echo ${HEADER}
        cd ${DIR} && ${COMMAND} || exit $?
        cd - > /dev/null
    done
else
    echo "No configs folder found."
fi
