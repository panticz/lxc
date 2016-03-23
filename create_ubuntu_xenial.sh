#!/bin/bash

[ -z ${CONTAINER} ] && CONTAINER=xenial
LANG=en_US.UTF-8

# force, remove previous container
if [ "$1" == "-f" ]; then
  [ $(sudo lxc-ls ${CONTAINER} | wc -l) -gt 0 ] && sudo lxc-destroy -f -n ${CONTAINER}
  shift
fi

# create container
sudo lxc-create -t ubuntu -n ${CONTAINER} -- template-options -r xenial $@

# workaround for "Failed to mount cgroup at /sys/fs/cgroup/systemd: Permission denied"
echo "lxc.aa_profile = unconfined" | sudo tee -a /var/lib/lxc/${CONTAINER}/config

# start container in background
sudo lxc-start -d -n ${CONTAINER}

# wait 3 seconds until network is up
sleep 3

# copy APT proxy configuration from host
APT_PROXY=$(grep -h "Acquire::http::Proxy" /etc/apt/* -r | head -1)
[ -n "${APT_PROXY}" ] && echo ${APT_PROXY} | sudo tee /var/lib/lxc/${CONTAINER}/rootfs/etc/apt/apt.conf.d/01proxy

# update packages in container
sudo lxc-attach -n ${CONTAINER} -- apt-get update
sudo lxc-attach -n ${CONTAINER} -- apt-get dist-upgrade -y

# show containers status
sudo lxc-ls ${CONTAINER} -f
