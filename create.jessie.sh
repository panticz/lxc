#!/bin/bash

[ -z ${CONTAINER} ] && CONTAINER=jessie
LANG=en_US.UTF-8

# create container
sudo lxc-create -t debian -n ${CONTAINER} -- template-options -r jessie

# workaround for "Failed to mount cgroup at /sys/fs/cgroup/systemd: Permission denied"
echo "lxc.aa_profile = unconfined" | sudo tee -a /var/lib/lxc/${CONTAINER}/config

# start container in background
sudo lxc-start -d -n ${CONTAINER}

# update packages in container
sudo lxc-attach -n ${CONTAINER} -- apt-get update
sudo lxc-attach -n ${CONTAINER} -- apt-get dist-upgrade -y
