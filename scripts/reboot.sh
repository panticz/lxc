#!/bin/bash

# shutdown running containers
for CONTAINER in $(lxc-ls --running); do
    lxc-stop -n ${CONTAINER} --nokill &
done

# wait until all containers are shut down
while [ $(lxc-ls -1 --running | wc -l) -gt 0  ]; do 
    sleep 1
    echo -n .
done

# reboot physical host
reboot
