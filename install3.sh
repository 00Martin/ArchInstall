#!/bin/sh
#ArchInstall by 00Martin - https://github.com/00Martin
#file: install3.sh

#We install some packages useful in any type of Arch install
sudo pacman -Sy --noconfirm ttf-liberation git base-devel flatpak

#We ask the user if they would like to install some gaming packages
echo -e "\n\n\nWould you like to install the following gaming packages? (Steam, Lutris) [n/Y]"
read answerGaming

#If we do want to install them
if [[ $answerGaming == "Y" ]]; then

#We install the gaming packages
#We replace wine with wine-staging because the stable release is slow to implement major updates
sudo pacman -Sy --noconfirm steam wine-staging lutris

fi


#Installation of Yay (AUR Helper)
cd ~/Documents/
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si --noconfirm
cd ..
rm -rf yay


#Because the default keyboard is reset to English USA, we change it to Swiss French
sudo localectl set-x11-keymap ch "" fr


#We ask the user if they would like to install additionnal programs
echo -e "\n\n\nWould you like to install additional programs? (You will be asked for each individually) [n/Y]"
read answerPrograms
#If we do want to install them
if [[ $answerPrograms == "Y" ]]; then

    #Lists containing the name of packages to potentially install
    pacmanPackages=("firefox" "discord" "vlc")
    aurPackages=("brave-bin" "spotify" "minecraft-launcher" "fastfetch")

    #Loops with the packages to install
    for i in "${pacmanPackages[@]}"
    do
        echo -e "\nWould you like to install the Arch package: $i? [n/Y]"
        read answerPkg
        if [[ $answerPkg == "Y" ]]; then
            sudo pacman -Sy --noconfirm $i
        fi
    done

    for i in "${aurPackages[@]}"
    do
        echo -e "\nWould you like to install the AUR package: $i? [n/Y]"
        read answerPkg
        if [[ $answerPkg == "Y" ]]; then
            yay -Sy --noconfirm $i
        fi
    done

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
sudo rm /home/encrypt.doNotDelete
sudo rm /home/sysType.doNotDelete
sudo rm /home/deskEnv.doNotDelete


#While not necessary, we reboot to apply the new keyboard and dns config
reboot
