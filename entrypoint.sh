#!/bin/sh

set -e

echo -n 'Activate SSH agent: '
eval $(ssh-agent -s)

if [ -n "$SSH_PRIVATE_KEY" ]; then
    echo 'Add SSH private key from environment ...'
    echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null
fi

if [ -n "$SSH_KNOWN_HOSTS" ]; then
    echo 'Add SSH known hosts from environment ...'
    echo "$SSH_KNOWN_HOSTS" > ~/.ssh/known_hosts
fi

echo "$@"
exec "$@"
