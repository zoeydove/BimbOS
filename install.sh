#! /bin/bash

echo BimbOS installer v1.0
echo
echo Are you installing this in a Virtual Machine? [Y/n]
read vm

if [[ "$vm" != "n" ]]; then
	echo Hooray! Lets begin.
else
	echo Oh no! This is only for advanced user who know EXACTLY what they are doing. 
	echo If you are proficient enough to install this on an actual computer then you should be proficient enough to remove the line of code in this script that prevents you from doing so
	# this line here --
	#                 |
	# ----------------|
	# |
	# v
	exit
fi

timedatectl set-ntp true

DISK=/dev/sda
EFI=/dev/sda1
SWAP=/dev/sda2
ROOT=/dev/sda3

#TODO: partition disks

mkfs.ext4 $ROOT
mkswap $SWAP
mkfs.fat -F32 $EFI

swapon $SWAP
mount $ROOT /mnt
mkdir -p /mnt/boot/efi
mount $EFI /mnt/boot/efi

pacstrap /mnt base linux linux-firmware sof-firmware xorg-server sddm plasma-desktop networkmanager dhcpcd sudo kde-applications chromium vim nano git

genfstab -U /mnt >> /mnt/etc/fstab

cat << EOF > /mnt/strap.sh
#! /bin/bash

ln -sf /usr/share/zoneinfo/Australia/Canberra /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
locale-gen

echo bimbos > /etc/hostname

systemctl enable NetworkManager
systemctl enable dhcpcd
systemctl enable sddm

useradd -mbambi
echo -n "bambi:goodgirl" | chpasswd
echo -n "root:bambisleep" | chpasswd

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

pacman --noconfirm -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot/efi/
grub-mkconfig -o /boot/grub/grub.cfg

EOF

chmod +x /mnt/strap.sh
arch-chroot /mnt "/strap.sh"

umount -R /mnt

echo ======================================================
echo Setup completed!
echo ======================================================
echo 
echo Type 'reboot' and press enter to finish the installation!
