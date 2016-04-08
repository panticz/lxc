#!/bin/bash

FROM=$1
TO=$2

lxc-stop -n ${FROM}
mv /var/lib/lxc/${FROM} /var/lib/lxc/${TO}
sed -i "s|${FROM}|${TO}|g" /var/lib/lxc/${TO}/config
echo ${TO%%.*} > /var/lib/lxc/${TO}/rootfs/etc/hostname
sed -i "s|${FROM}|${TO%%.*}|g" /var/lib/lxc/${TO}/rootfs/etc/hosts
