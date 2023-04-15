#!/bin/sh
#ArchInstallNvidia by MD^ (Martin)
#file: install3.sh
#v1.0 - 04.15.2023 - latest change: first release

#Auto clean, we remove the previous script
sudo rm /home/install2.sh
clear

#We install some useful (and gaming) packages
sudo pacman -Sy --noconfirm steam ttf-liberation git base-devel flatpak wine-staging lutris

#Installation of Yay (AUR Helper)
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
cd..
rm -rf yay

#because the default keyboard is English USA, we change it to Swiss French
sudo localectl set-x11-keymap ch "" fr


#We ask the user if they would like to set a custom DNS server
echo -e "\n\n\nWould you like to set a custom IPv4 DNS server ? [n/Y] (The system will reboot after this step)"
read answer

#If we do want to set a custom DNS
if [ $answer == "Y" ]; then
echo -e "\n\nEnter the IP of the DNS server (format x.x.x.x)\nThis script does not verify if the IP format is valid, so make sure to enter it properly."
read customdns
sudo sh -c "echo "static domain_name_servers=$customdns" >> /etc/dhcpcd.conf"
fi

#While not necessary, we reboot to apply the new keyboard and dns config
reboot
