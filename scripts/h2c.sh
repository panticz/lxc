#!/bin/bash

# Configure parameter
ORIGIN_HOST=foo.example.com
CONTAINER_NAME=bar.example.com
CONTAINER_REALASE=xenial

# Create new LXC container
sudo lxc-create -t ubuntu -n ${CONTAINER_NAME} -- template-options -r ${CONTAINER_REALASE}

# Disable confinement of the container
echo "lxc.apparmor.profile = unconfined" | sudo tee -a /var/lib/lxc/${CONTAINER_NAME}/config

# Backup container filesystem
sudo mv /var/lib/lxc/${CONTAINER_NAME}/rootfs /var/lib/lxc/${CONTAINER_NAME}/rootfs.org
sudo mkdir /var/lib/lxc/${CONTAINER_NAME}/rootfs

# Pre-sync running system to container
sudo rsync \
    -avz \
    -e "ssh -i ${HOME}/.ssh/id_rsa -F ${HOME}/.ssh/config" \
    --delete \
    --numeric-ids \
    --exclude=dev/* \
    --exclude=proc/* \
    --exclude=sys/* \
    --exclude=tmp/* \
    --log-file=/tmp/${CONTAINER_NAME}.rsync.log \
    root@${ORIGIN_HOST}:/ /var/lib/lxc/${CONTAINER_NAME}/rootfs

# Restore /dev directory
sudo rm -r /var/lib/lxc/${CONTAINER_NAME}/rootfs/dev
sudo cp -a /var/lib/lxc/${CONTAINER_NAME}/rootfs.org/dev /var/lib/lxc/${CONTAINER_NAME}/rootfs/

# Disable mounts in fstab
sudo mv /var/lib/lxc/${CONTAINER_NAME}/rootfs/etc/fstab /var/lib/lxc/${CONTAINER_NAME}/rootfs/etc/fstab.org
sudo touch /var/lib/lxc/${CONTAINER_NAME}/rootfs/etc/fstab

# Optional: Reconfigure network
sudo mv /var/lib/lxc/${CONTAINER_NAME}/rootfs/etc/network/interfaces /var/lib/lxc/${CONTAINER_NAME}/rootfs/etc/network/interfaces.org
cat << EOF | sudo tee /var/lib/lxc/${CONTAINER_NAME}/rootfs/etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

# Start container
sudo lxc-start -n ${CONTAINER_NAME} --logfile /tmp/${CONTAINER_NAME}.out

# Login into container
sudo lxc-attach -n ${CONTAINER_NAME}
