#!/bin/bash

# ensure that this script is run as root
if [ $(id -u) -ne 0 ]; then
  sudo $0
  exit
fi

# set language to english
LANG=en_US.UTF-8

# update APT rootfs (Debian and Ubuntu)
for DIST in $(ls /var/cache/lxc/debian); do
  echo "Updating ${DIST} ..."
  chroot "/var/cache/lxc/debian/${DIST}" apt-get update 
  chroot "/var/cache/lxc/debian/${DIST}" apt-get dist-upgrade -y
  chroot "/var/cache/lxc/debian/${DIST}" apt-get autoremove -y
  chroot "/var/cache/lxc/debian/${DIST}" apt-get clean
done
