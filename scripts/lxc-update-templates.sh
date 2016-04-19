#!/bin/bash

# ensure that this script is run as root
if [ $(id -u) -ne 0 ]; then
  sudo $0
  exit
fi

# set language to english
LANG=en_US.UTF-8

# update APT rootfs (Debian and Ubuntu)
for DIST in $(find /var/cache/lxc/*/* -maxdepth 0 -type d); do
  echo "Updating ${DIST} ..."
  chroot "${DIST}" apt-get update -qq
  chroot "${DIST}" apt-get dist-upgrade -qq -y
  chroot "${DIST}" apt-get autoremove -qq -y
  chroot "${DIST}" apt-get clean
done
