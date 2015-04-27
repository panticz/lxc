#!/bin/bash

[ -z $CONTAINER ] && CONTAINER=wheezy

LANG=en_US.UTF-8
sudo lxc-create -t debian -n ${CONTAINER} -- template-options -r wheezy
sudo lxc-start -d -n ${CONTAINER}

sudo lxc-attach -n ${CONTAINER} -- apt-get clean
sudo lxc-attach -n ${CONTAINER} -- apt-get update
sudo lxc-attach -n ${CONTAINER} -- apt-get dist-upgrade -y
