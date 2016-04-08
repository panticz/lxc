#!/bin/bash

# shutdown running containers
for CONTAINER in $(lxc-ls --running); do
    echo ${CONTAINER}
    lxc-stop -t 30 -n ${CONTAINER}
done

# reboot physical host
reboot
