#!/usr/bin/env bash

# Profile
source /etc/profile
export PS1="(chroot) ${PS1}"

# UUID's
UUID_EFI=$(blkid -s UUID -o value /dev/nvme0n1p1)
UUID_BOOT=$(blkid -s UUID -o value /dev/nvme0n1p2)
UUID_LUKS=$(blkid -s UUID -o value /dev/nvme0n1p3)
UUID_ROOT=$(blkid -s UUID -o value /dev/mapper/vg0-root)
UUID_SWAP=$(blkid -s UUID -o value /dev/mapper/vg0-swap)

# Fstab
cat <<EOS > /etc/fstab
UUID=${UUID_EFI}    /boot/efi      vfat    defaults,noatime     0 2
UUID=${UUID_BOOT}   /boot          xfs     defaults,noatime     0 2
UUID=${UUID_ROOT}   /              xfs     defaults,noatime     0 1
UUID=${UUID_SWAP}   none           swap    sw                   0 0
EOS

# Crypttab
cat <<EOS > /etc/crypttab
lvm UUID=${UUID_LUKS} none luks
EOS

# Grub
sed -i "s/^GRUB_CMDLINE_LINUX=\".*\"/GRUB_CMDLINE_LINUX=\"rd.luks.uuid=${UUID_LUKS} root=\/dev\/mapper\/vg0-root\"/" /etc/default/grub
dracut --regenerate-all --force
grub2-mkconfig -o /boot/grub2/grub.cfg
grub2-install --efi-directory=/boot/efi --target=x86_64-efi --bootloader-id=opensuse

# Create user
USERNAME="al"
groupadd wheel
useradd -m -G wheel,users -s /bin/zsh $USERNAME
echo 'Root password!'
passwd
echo 'User password!'
passwd $USERNAME
visudo
# Exit
exit
