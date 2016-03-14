#!/bin/bash

# search logs
for LOG in $(ls /var/log/lxc/*.log | grep -v lxc-monitord.log); do
    FILE="${LOG##*/}"
    FILE="${FILE%.*}"

    # check if container exists
    FOUND=0
    for CONTAINER in $(lxc-ls); do
        if [ "${FILE}" == "${CONTAINER}" ]; then
            FOUND=1
            break
        fi
    done
    
    # remove logs
    if [ ${FOUND} -eq 0 ]; then
        rm "${LOG}"
    fi
done
