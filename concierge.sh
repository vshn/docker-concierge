#!/bin/sh

set -e

NOCOLOR='\033[0m'
PURPLE='\033[1;35m'
BLUE='\033[1;34m'

export GIT_COMMIT_MESSAGE="${GIT_COMMIT_MESSAGE:-$(git log -1 --format=%B)}"
export GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-$(git show -q --format=%aN HEAD)}"
export GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-$(git show -q --format=%aE HEAD)}"
export GIT_COMMITTER_NAME="${GIT_COMMITTER_NAME:-$(git show -q --format=%cN HEAD)}"
export GIT_COMMITTER_EMAIL="${GIT_COMMITTER_EMAIL:-$(git show -q --format=%cE HEAD)}"
export GIT_USER_NAME="${GIT_USER_NAME:-${GIT_AUTHOR_NAME}}"
export GIT_USER_EMAIL="${GIT_USER_EMAIL:-${GIT_AUTHOR_EMAIL}}"

git config --global user.name > /dev/null || {
    echo "Configuring Git: user.name '$GIT_USER_NAME'"
    git config --global user.name "$GIT_USER_NAME"
}
git config --global user.email > /dev/null || {
    echo "Configuring Git: user.email '$GIT_USER_EMAIL'"
    git config --global user.email "$GIT_USER_EMAIL"
}

CONFIGS=${1:-configs}

if [ -d ${CONFIGS} ]; then
    echo "user: $(git config --global user.name) <$(git config --global user.email)>"
    echo "author: $GIT_AUTHOR_NAME <$GIT_AUTHOR_EMAIL>"
    echo "committer: $GIT_COMMITTER_NAME <$GIT_COMMITTER_EMAIL>"
    echo "message: $GIT_COMMIT_MESSAGE"

    for DIR in ${CONFIGS}/*; do
        COMMAND="msync update ${MSYNC_ARGS}"
        DIRNAME=$(basename ${DIR})
        HEADER="=== ${PURPLE}${COMMAND} ${BLUE}${DIRNAME}${NOCOLOR} ==="

        echo && echo ${HEADER}
        cd ${DIR} && ${COMMAND} -m "${GIT_COMMIT_MESSAGE}" || exit $?
        cd - > /dev/null
    done
else
    echo "Usage: ${0##*/} [<path/to/configs>]"
    echo "By default ${0##*/} looks in configs/ for module_configs."
    echo
    echo "Configs folder not found: $(realpath ${CONFIGS})"
fi
