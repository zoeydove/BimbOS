#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="bimbos-main"
iso_label="BIMBO_$(date +%Y%m)"
iso_publisher="Katie Sarah <https://github.com/katiegirlsarah/>"
iso_application="BimbOS main"
iso_version="0.0.1"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="erofs"
airootfs_image_tool_options=('-zlz4hc,12')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/passwd"]="0:0:644"
  ["/home/bambi/Desktop/install.sh"]="1000:1000:777"
)
