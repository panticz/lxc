#!/bin/bash

[ -z ${CONTAINER} ] && CONTAINER=wheezy
LANG=en_US.UTF-8

# force, remove previous container
if [ "$1" == "-f" ]; then
  [ $(sudo lxc-ls ${CONTAINER} | wc -l) -gt 0 ] && sudo lxc-destroy -f -n ${CONTAINER}
fi

# create container
sudo lxc-create -t debian -n ${CONTAINER} -- template-options -r wheezy

# set container MAC address if specified
if [ ! -z ${CONTAINER_MAC} ]; then
  sed -i "s|lxc.network.hwaddr = .*|lxc.network.hwaddr = ${CONTAINER_MAC}|" /var/lib/lxc/${CONTAINER}/config
fi

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
