#!/usr/bin/env bash

# Update LiveCD
sudo zypper refresh
sudo zypper update

# Localization
sudo zypper install glibc-locale glibc-i18ndata glibc-gconv-modules-extra
sudo localedef -i en_US -f UTF-8 en_US.UTF-8

# Partitions
DISK="/dev/nvme0n1"
sudo parted $DISK mklabel gpt
sudo parted $DISK mkpart primary fat32 1MiB 1GiB
sudo parted $DISK set 1 esp on
sudo parted $DISK mkpart primary xfs 1GiB 1.5GiB
sudo parted $DISK mkpart primary xfs 1.5GiB 100%
sudo parted $DISK print

EFIP="/dev/nvme0n1p1"
BOOTP="/dev/nvme0n1p2"
ROOTP="/dev/nvme0n1p3"
sudo cryptsetup luksFormat $ROOTP
sudo cryptsetup open $ROOTP lvm
sudo pvcreate /dev/mapper/lvm
sudo vgcreate vg0 /dev/mapper/lvm
sudo lvcreate -L 4G -n swap vg0
sudo lvcreate -l 100%FREE -n root vg0

sudo mkfs.vfat -F 32 -n EFI $EFIP
sudo mkfs.xfs -L boot $BOOTP
sudo mkfs.xfs -L root /dev/vg0/root
sudo mkswap -L swap /dev/vg0/swap
sudo swapon /dev/vg0/swap

# Mount
sudo mkdir -p /mnt/os
sudo mount /dev/vg0/root /mnt/os
sudo mkdir /mnt/os/boot/
sudo mount $BOOTP /mnt/os/boot
sudo mkdir /mnt/os/boot/efi
sudo mount $EFIP /mnt/os/boot/efi

sudo mkdir /mnt/os/{proc,sys,dev,run}
sudo mount --types proc /proc /mnt/os/proc
sudo mount --rbind /sys /mnt/os/sys
sudo mount --make-rslave /mnt/os/sys
sudo mount --rbind /dev /mnt/os/dev
sudo mount --make-rslave /mnt/os/dev
sudo mount --bind /run /mnt/os/run
sudo mount --make-slave /mnt/os/run

# Base system
sudo zypper --root /mnt/os ar --refresh https://download.opensuse.org/tumbleweed/repo/oss/ oss
sudo zypper --root /mnt/os in kernel-default grub2-x86_64-efi zypper bash man vim shadow util-linux cryptsetup lvm2 xfsprogs
sudo zypper --root /mnt/os in --no-recommends NetworkManager

# Chroot
cat <<'EOS' > /mnt/os/setup.sh
#!/bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
EOS
sudo chmod +x /mnt/os/setup.sh
sudo chroot /mnt/os /bin/bash /setup.sh
