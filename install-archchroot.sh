#!/bin/sh
#ArchInstall by MD^ (Martin)
#file: install-archchroot.sh

#Set time zone to Switzerland
ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

#Sychronize clocks
hwclock --systohc


#locale-gen
locale-gen


#BOOTLOADER: Systemd
bootctl --path=/boot install


#Installation of some packages that will be useful on the next boot
pacman -Sy --noconfirm dhcpcd ifplugd ntfs-3g intel-ucode networkmanager bluez pipewire-pulse


#We ask the user to change root password
echo -e "\n\nSET A NEW PASSWORD FOR ROOT:\n"
passwd
