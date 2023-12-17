#!/bin/sh
#ArchInstall by 00Martin - https://github.com/00Martin
#file: install2.sh

#Some manual work is required during this script, these steps are a little more complicated then just automatically adding a line at the end of a conf file
#For the pacman conf file, it is possible to do it by specifying the specific lines to make the changes, but it's bad practice because we risk making the script obsolete too quickly
echo -e "\nWe want to allow the download of more diverse packages from the arch repository, to do so->\nOpen the pacman configuration file by doing: nano /etc/pacman.conf\nMake sure all 3 of the core, extra, multilib sources are uncommented"

echo -e "\n\nThis step is a requirement otherwise we are gonna be missing on important libraries to make our graphical drivers work\n\n"

#We ask the user if they allowed the additional arch sources
echo "Have you done this ? [n/Y]"
read answer


#If it was done, we continue
if [[ $answer == "Y" ]]; then

#We enable DHCP in case it wasn't enabled already
systemctl enable --now dhcpcd


#We ask the user to enter a username
echo -e "\nPlease enter your username.\nThis script does not verify if the username is valid, so make sure to enter a correct one.\nA good practice is a simple name in lowercase, without any number or special caracter.\n\nusername:"
read username
#We create a user with the provided username
useradd -m  $username
passwd      $username


#We update all packages and download sudo
pacman -Syu
pacman -S --noconfirm           sudo


#Installation of graphics driver and libraries
sysType=`cat /home/sysType.doNotDelete`

#For Intel (integrated) graphics cards
if [[ "$sysType" == "0" ]]; then
    pacman -S --noconfirm --needed lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
fi

#For AMD graphics cards
if [[ "$sysType" == "1" ]]; then
    pacman -S --noconfirm --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
fi

#For Nvidia graphics cards
if [[ "$sysType" == "2" ]]; then
    #We install the nvidia drivers for a standard kernel release and some basic libraries (the rest will be downloaded with the --needed parameter)
    pacman -S --noconfirm --needed  nvidia lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
fi


#Installation of the desktop environment
deskEnv=`cat /home/deskEnv.doNotDelete`

#If we install Gnome
if [[ "$deskEnv" == "g" ]]; then
    #For Nvidia graphic cards (for Xorg instead of wayland)
    if [[ "$sysType" == "2" ]]; then

    #By default, Gnome uses wayland, but we want to give the possibility of an easy switch in case wayland has issues
    pacman -S --noconfirm gnome xorg

    #For other hardware, we just install the wayland version
    else

    pacman -S --noconfirm gnome

    fi
    #We enable the Gnome service so it starts on boot
    systemctl enable gdm.service

#Otherwise we install KDE Plasma
else
    #For Nvidia graphic cards (for Xorg instead of wayland)
    if [[ "$sysType" == "2" ]]; then

        #We install everything needed for KDE Plasma Xorg, with a limited set of applications
        pacman -S --noconfirm xorg plasma sddm bluedevil konsole dolphin kcron ksystemlog partitionmanager ark okular kate kompare gwenview ktorrent merkuro kcalc elisa

    #For the rest we install the wayland version
    else

        #We install everything needed for KDE Plasma Wayland, with a limited set of applications
        pacman -S --noconfirm xorg plasma wayland plasma-wayland-session sddm bluedevil konsole dolphin kcron ksystemlog partitionmanager ark okular kate kompare gwenview ktorrent merkuro kcalc elisa

    fi
    #We enable the Sddm service so KDE Plasma starts on boot
    systemctl enable sddm.service
fi


#We enable some services on boot for the user to have a fully working system on the next boot
systemctl enable NetworkManager
systemctl enable bluetooth.service


#Some manual intervention required from the user
echo -e "\n\nATTENTION REQUIRED\nWe need to add our new user to the sudoer file, to do this ->\nUse the following command: EDITOR=nano visudo\nAdd this line with the correct username under the user privilege specification: NAMEOFUSER ALL=(ALL) ALL"

echo -e "\nOnce this step is done, you can reboot and start the next script. All files will be cleaned at the end of the process"


#If the user did not uncomment the additional sources from the pacman config file, we stop
else
echo -e "\nPlease uncomment the sources and start the script again\n"
fi
