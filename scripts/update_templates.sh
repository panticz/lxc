#!/bin/bash

# update debian templates
for DIST in $(ls /var/cache/lxc/debian); do
  echo "Updating ${DIST} ..."
  chroot "/var/cache/lxc/debian/${DIST}" apt-get update 
  chroot "/var/cache/lxc/debian/${DIST}" apt-get dist-upgrade -y
  chroot "/var/cache/lxc/debian/${DIST}" apt-get autoremove -y
  chroot "/var/cache/lxc/debian/${DIST}" apt-get clean
done
