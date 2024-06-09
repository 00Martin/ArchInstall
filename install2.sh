#!/bin/sh
#ArchInstall by 00Martin - https://github.com/00Martin
#file: install2.sh

#We add multilib at the end of the pacman configuration file (instead of uncommenting), so we don't have to ask the user to do it.
echo "[multilib]"                             >>  /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist"     >>  /etc/pacman.conf


#We enable networking
systemctl enable --now NetworkManager


#We ask the user to enter a username
echo -e "\nPlease enter your username.\nThis script does not verify if the username is valid, so make sure to enter a correct one.\nA good practice is a simple name in lowercase, without any number or special caracter.\n\nusername:"
read username
#We create a user with the provided username
useradd -m  $username
passwd      $username


#We update all packages and download sudo
pacman -Syu
pacman -S --noconfirm sudo


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
    pacman -S --noconfirm --needed nvidia lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
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
        #Nowadays KDE Plasma 6 gets installed with wayland anyway, but I noticed that this command installs less packages (less storage used).
        #Since it's still difficult to make KDE Plasma wayland work well with Nvidia as of 2024, I leave this as a seperate command for now.
        pacman -S --noconfirm xorg plasma sddm bluedevil konsole dolphin kcron ksystemlog partitionmanager ark okular kate kompare gwenview ktorrent merkuro kcalc elisa

    #For the rest we install the wayland version
    else

        #We install everything needed for KDE Plasma Wayland, with a limited set of applications
        pacman -S --noconfirm xorg plasma wayland plasma-workspace sddm bluedevil konsole dolphin kcron ksystemlog partitionmanager ark okular kate kompare gwenview ktorrent merkuro kcalc elisa

    fi
    #We enable the Sddm service so KDE Plasma starts on boot
    systemctl enable sddm.service
fi


#We install ufw as a firewall
pacman -S --noconfirm ufw
#Based on the arch wiki, iptables has to be deactivated before enabling ufw (https://wiki.archlinux.org/title/Uncomplicated_Firewall)
systemctl disable --now iptables
systemctl enable --now ufw
ufw enable


#We create a file to restrict login on ssh using root
mkdir /etc/ssh
mkdir /etc/ssh/sshd_config.d
echo "PermitRootLogin no"    >>  /etc/ssh/sshd_config.d/20-deny_root.conf


#We enable some services on boot for the user to have a fully working system on the next boot
systemctl enable bluetooth.service


#Some manual intervention required from the user
echo -e "\n\nATTENTION REQUIRED\nWe need to add our new user to the sudoer file, to do this ->\nUse the following command: EDITOR=nano visudo\nAdd this line with the correct username under the user privilege specification: NAMEOFUSER ALL=(ALL) ALL"

echo -e "\nOnce this step is done, you can reboot and start the next script. You will be logged in as a normal user, but you should not run this next script with sudo, the script itself will elevate privileges where needed."
echo -e "\nAll files that are part of this set of scripts will be cleaned automatically at the end of the process. Basically, once the installation is done, you're good to go."
