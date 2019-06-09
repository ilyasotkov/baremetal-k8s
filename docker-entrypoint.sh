#!/bin/bash

if [ "$1" = 'ssh' ]; then
    ssh $2
elif [ "$1" = 'bash' ]; then
    bash -c "$@"
else
    ansible-playbook -vv $@
fi
