# Ansible Workstation

```Go
❄️                  Setup / DWM                   ❄️
---------------------------------------------------
╭─ Distro          -> OpenSUSE Tumbleweed
├─ Editor          -> NeoVim
├─ Browser         -> Firefox / qutebrowser
├─ Shell           -> zsh
╰─ Process Viewer  -> btop
 
╭─ Music Player    -> cmus
├─ Compositor      -> picom
├─ Notifications   -> dunst
├─ Media Player    -> mpv
╰─ File Manager    -> superfile

╭─ WM              -> dwm
├─ Terminal        -> st
├─ App Laucher     -> dmenu
├─ Theme           -> pywal
╰─ Font            -> Iosevka NF

╭─ Office toolkit  -> onlyoffice
├─ Pdf viewer      -> zathura
├─ Wallpapers      -> nitrogen
├─ Screenshot tool -> flameshot
╰─ System info     -> fastfetch
```

This repository aims to automating the setup of my OpenSUSE workstations using [Ansible](https://www.ansible.com/).

This repo works in combination with my [dotfiles](https://github.com/i4ox/dotfiles) and my [utils](https://github.com/i4ox/utils).

## Basic OpenSUSE installation

1. Download a `LiveCD` ISO image from the [official sources](https://download.opensuse.org/tumbleweed/iso/openSUSE-Tumbleweed-XFCE-Live-x86_64-Current.iso).
2. Create a bootable USB drive.
3. Install OpenSUSE
  > **Warning**
  > 
  > The OpenSUSE installation itself can be automated using [AutoYaST](https://doc.opensuse.org/projects/autoyast/).

  - I install OpenSUSE with chroot and build script.
  - I usually set up the encrypted LVM.
  - I only install the standard system utilities and the SSH server - Ansible will take care of everything.

> **Warning**
> 
> Don't forget change the names for partitions inside scripts.

```sh
curl -LO https://raw.githubusercontent.com/i4ox/ansible-workstation/refs/heads/main/scripts/opensuse-chroot-install.sh
sudo chroot +x opensuse-chroot-install.sh
./opensuse-chroot-install.sh

# Or

curl -s https://raw.githubusercontent.com/i4ox/ansible-workstation/refs/heads/main/scripts/opensuse-chroot-install.sh | bash
```

## Execute Ansible playbook

I run ansible only locally, because I can.

```sh
ansible-playbook -u al -i localhost -e "ansible_connection=local" --tags "system" playbook.yml
```

### Tags

You can run specific group of tasks with tags:

- *system*: configure the system(zypper, drivers, fonts, wm and etc)
- *hardware*: install or update the hardware
- *opensuse-upgrade*: Upgrade the system