#!/bin/sh
#ArchInstall by 00Martin - https://github.com/00Martin
#file: install3.sh

#We install some packages useful in any type of Arch install
sudo pacman -Sy --noconfirm ttf-liberation git base-devel flatpak noto-fonts


#Installation of Yay (AUR Helper)
cd ~/Documents/
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si --noconfirm
cd ..
rm -rf yay


#We ask the user if they would like to install some gaming packages
echo -e "\n\n\nWould you like to install the following gaming packages? (Steam, Lutris, Heroic Launcher) [n/Y]"
read answerGaming

#If we do want to install them
if [[ $answerGaming == "Y" ]]; then

#We install the gaming packages
#We replace wine with wine-staging because the stable release is slow to implement major updates
sudo pacman -Sy --noconfirm steam wine-staging lutris
yay -Sy --noconfirm heroic-games-launcher-bin

fi


#Because the default keyboard is reset to English USA, we change it to Swiss French
sudo localectl set-x11-keymap ch "" fr


#We ask the user if they would like to install additionnal programs
echo -e "\n\n\nWould you like to install additional programs? (You will be asked for each individually) [n/Y]"
read answerPrograms
#If we do want to install them
if [[ $answerPrograms == "Y" ]]; then

    #Lists containing the name of packages to potentially install
    pacmanPackages=("firefox" "discord" "vlc" "chromium" "signal-desktop" "wireguard-tools")
    aurPackages=("brave-bin" "spotify" "minecraft-launcher" "fastfetch" "protonvpn-cli" "tlpui")
    flatpakPackages=("skype")

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

    for i in "${flatpakPackages[@]}"
    do
        echo -e "\nWould you like to install the Flatpak package: $i? [n/Y]"
        read answerPkg
        if [[ $answerPkg == "Y" ]]; then
            flatpak install $i
        fi
    done

fi


#Auto clean, we remove the scripts
sudo rm /home/install2.sh
sudo rm /home/install3.sh
sudo rm /home/encrypt.doNotDelete
sudo rm /home/sysType.doNotDelete
sudo rm /home/deskEnv.doNotDelete


#While not necessary, we reboot to start a clean session for the user
reboot
