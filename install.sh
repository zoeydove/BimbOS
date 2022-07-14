#! /bin/bash

echo BimbOS installer v1.0
echo
echo "Are you installing this in a Virtual Machine? (and using virtualbox) [Y/n]"
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
SWAP=/dev/sda1
ROOT=/dev/sda2

#TODO: partition disks
echo -e "o\nn\n\n\n\n+4G\nt\n\n82\nn\n\n\n\n\nw" | fdisk -w always $DISK
read
mkfs.ext4 $ROOT
mkswap $SWAP

swapon $SWAP
mount $ROOT /mnt

pacstrap /mnt base linux linux-firmware sof-firmware xorg-server sddm plasma-desktop networkmanager dhcpcd sudo kde-applications chromium vim nano git wget

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

useradd -m bambi
echo -n "bambi:goodgirl" | chpasswd
echo -n "root:bambisleep" | chpasswd

echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

cat << END > /etc/X11/xorg.conf
Section "Monitor"
	Identifier "Virtual-1"
	Option "PreferredMode" "1920x1080"
EndSection
END

wget -O /home/bambi/.config/plasma-org.kde.plasma.desktop-appletsrc https://raw.githubusercontent.com/katiegirlsarah/BimbOS/raw/main/plasma
wget -O /home/bambi/.config/kdeglobals https://raw.githubusercontent.com/katiegirlsarah/BimbOS/raw/main/kdeglobals

pacman --noconfirm -S grub
grub-install --target=i386-pc $DISK
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
