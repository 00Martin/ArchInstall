#!/bin/sh
#ArchInstall by MD^ (Martin)
#file: install3.sh

#We install some useful packages
sudo pacman -Sy --noconfirm ttf-liberation git base-devel flatpak

#We ask the user if they would like to install some gaming packages
echo -e "\n\n\nWould you like to install the following gaming packages? (Steam, Lutris) [n/Y]"
read answerGaming
#If we do want to install them
if [[ $answerGaming == "Y" ]]; then
#We install the gaming packages
sudo pacman -Sy --noconfirm steam wine-staging lutris
fi


#Installation of Yay (AUR Helper)
cd ~/Documents/
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si --noconfirm
cd ..
rm -rf yay


#Because the default keyboard is English USA, we change it to Swiss French
sudo localectl set-x11-keymap ch "" fr


#We ask the user if they would like to install additionnal programs
echo -e "\n\n\nWould you like to install additional programs? (You will be asked for each individually) [n/Y]"
read answerPrograms
#If we do want to install them
if [[ $answerPrograms == "Y" ]]; then
#I will make this section cleaner once the rest of the features are implemented.
#Multidimensional arrays aren't too much of a thing in bash so I'll do the following:
# - 1 list each for pacman and AUR packages
# - 1 loop for each type of package, It'll go through the list and asks the user for installation.
    echo -e "\nWould you like to install Brave Browser? [n/Y]"
    read answerBrave
    if [[ $answerBrave == "Y" ]]; then
    yay -Sy --noconfirm brave-bin
    fi

    echo -e "\nWould you like to install Firefox? [n/Y]"
    read answerFirefox
    if [[ $answerFirefox == "Y" ]]; then
    sudo pacman -Sy --noconfirm firefox
    fi

    echo -e "\nWould you like to install Discord? [n/Y]"
    read answerDiscord
    if [[ $answerDiscord == "Y" ]]; then
    sudo pacman -Sy --noconfirm discord
    fi

    echo -e "\nWould you like to install Spotify? [n/Y]"
    read answerSpotify
    if [[ $answerSpotify == "Y" ]]; then
    yay -Sy --noconfirm spotify
    fi

    echo -e "\nWould you like to install Minecraft? [n/Y]"
    read answerMinecraft
    if [[ $answerMinecraft == "Y" ]]; then
    yay -Sy --noconfirm minecraft-launcher
    fi

    echo -e "\nWould you like to install Fastfetch? [n/Y]"
    read answerFastfetch
    if [[ $answerFastfetch == "Y" ]]; then
    yay -Sy --noconfirm fastfetch
    fi

    echo -e "\nWould you like to install Vlc? [n/Y]"
    read answerVlc
    if [[ $answerVlc == "Y" ]]; then
    sudo pacman -Sy --noconfirm vlc
    fi
fi


#We ask the user if they would like to set a custom DNS server
echo -e "\n\n\nWould you like to set a custom IPv4 DNS server? [n/Y] (The system will reboot after this step)"
read answer

#If we do want to set a custom DNS
if [[ $answer == "Y" ]]; then
echo -e "\n\nEnter the IP of the DNS server (format x.x.x.x)\nThis script does not verify if the IP format is valid, so make sure to enter it properly."
read customdns

#We add with sudo privileges the static DNS server to the dhcpcd config file
sudo sh -c "echo 'static domain_name_servers=$customdns' >> /etc/dhcpcd.conf"

fi


#Auto clean, we remove the scripts
sudo rm /home/install2.sh
sudo rm /home/install3.sh


#While not necessary, we reboot to apply the new keyboard and dns config
reboot
