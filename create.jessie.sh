#!/bin/bash

[ -z $CONTAINER ] && CONTAINER=jessie

LANG=en_US.UTF-8
sudo lxc-create -t debian -n ${CONTAINER} -- template-options -r jessie

# workaround for "Failed to mount cgroup at /sys/fs/cgroup/systemd: Permission denied"
sudo echo "lxc.aa_profile = unconfined" | tee -a /var/lib/lxc/${CONTAINER}/config

sudo lxc-start -d -n ${CONTAINER}

sudo lxc-attach -n ${CONTAINER} -- apt-get update
sudo lxc-attach -n ${CONTAINER} -- apt-get dist-upgrade -y
