#!/bin/bash

# ensure that this script is run as root
if [ $(id -u) -ne 0 ]; then
  sudo $0
  exit
fi

# update debian templates
for DIST in $(ls /var/cache/lxc/debian); do
  echo "Updating ${DIST} ..."
  chroot "/var/cache/lxc/debian/${DIST}" apt-get update 
  chroot "/var/cache/lxc/debian/${DIST}" apt-get dist-upgrade -y
  chroot "/var/cache/lxc/debian/${DIST}" apt-get autoremove -y
  chroot "/var/cache/lxc/debian/${DIST}" apt-get clean
done
