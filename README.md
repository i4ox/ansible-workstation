# Ansible Workstation

This repository aims to automating the setup of my OpenSUSE workstations using [Ansible](https://www.ansible.com/).

This repo works in combination with my [dotfiles]() and my [utils]().

## Basic OpenSUSE installation

1. Download a `LiveCD` ISO image from the [official sources](https://download.opensuse.org/tumbleweed/iso/openSUSE-Tumbleweed-XFCE-Live-x86_64-Current.iso).
2. Create a bootable USB drive.
3. Install OpenSUSE
  > [!INFORMATION]
  > The OpenSUSE installation itself can be automated using [AutoYaST](https://doc.opensuse.org/projects/autoyast/).

  - I install OpenSUSE with chroot and build script.
  - I usually set up the encrypted LVM.
  - I don't create a root user, only a normal user, who will automatically be placed in the `sudo` group.
  - I only install the standard system utilities and the SSH server - Ansible will take care of everything.

```sh
export DISK="/dev/nvme0n1"
curl -s https://raw.githubusercontent.com/i4ox/ansible-workstation/refs/heads/main/scripts/opensuse-chroot-install.sh | bash
```
