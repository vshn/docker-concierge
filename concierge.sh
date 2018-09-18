#!/usr/bin/env bash

NOCOLOR='\033[0m'
PURPLE='\033[1;35m'
BLUE='\033[1;34m'

set -e

CONFIGS=/app/configs

if [ -d ${CONFIGS} ]; then

    for DIR in ${CONFIGS}/*; do
        COMMAND="msync update"
        DIRNAME=$(basename ${DIR})
        HEADER="=== ${PURPLE}${COMMAND}${NOCOLOR} ${BLUE}${DIRNAME}${NOCOLOR} ==="

        echo && echo -e ${HEADER}
        cd ${DIR} && ${COMMAND} && cd - > /dev/null
    done
else
    echo "No configs folder found."
fi
