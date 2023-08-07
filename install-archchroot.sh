#!/bin/sh
#ArchInstall by 00Martin - https://github.com/00Martin
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
pacman -Sy --noconfirm dhcpcd ifplugd ntfs-3g networkmanager bluez pipewire-pulse

clear
#Installation of the microcode based on the user's system
sysType=`cat /home/sysType.doNotDelete`
#if has an intel processor
if [[ "$sysType" == "0" || "$sysType" == "2" ]]; then
    pacman -Sy --noconfirm intel-ucode
fi
#if has an amd processor
if [[ "$sysType" == "1" ]]; then
    pacman -Sy --noconfirm amd-ucode
fi


#We ask the user to change root password
echo -e "\n\nSET A NEW PASSWORD FOR ROOT:\n"
passwd
