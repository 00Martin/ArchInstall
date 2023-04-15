#!/bin/sh
#ArchInstallNvidia by MD^ (Martin)
#file: install2.sh
#v1.0 - 04.15.2023 - latest change: first release

#Some manual work is required during this script, these steps are a little more complicated then just automatically adding a line at the end of a conf file
#For the pacman conf file, it is possible to do it by specifying the specific lines to make the changes, but it's bad practice because we risk making the script obsolete too quickly
echo -e "\nWe want to allow the download of more divers packages of the arch repository, to do so->\nOpen the pacman configuration file by doing: nano /etc/pacman.conf\nMake sure all 4 of the core, extra, community, multilib sources are uncommented"

echo -e "\n\nThis step is a requirement otherwise we are gonna be missing on important libraries to make our graphical drivers work\n\n"

#We ask the user if they allowed the additional arch sources
echo "Have you done this ? [n/Y]"
read answer


#If it was done, we continue
if [ $answer == "Y" ]; then

#We enable DHCP in case it wasn't enabled already
systemctl enable --now dhcpcd

#We ask the user to enter a username
echo -e "\nPlease enter your username.\nThis script does not verify if the username is valid, so make sure to enter a correct one.\nA good practice is a simple name in lowercase, without any number or special caracter.\n\nusername:"
read username
#We create a user with the provided username
useradd -m $username
passwd $username

#We update all packages and download sudo
pacman -Syu
pacman -S --noconfirm sudo

#We install the nvidia drivers for a standard kernel release and some basic libraries (the rest will be downloaded with the --needed parameter)
pacman -S --needed --noconfirm nvidia lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader

#We install everything needed for KDE Plasma, with a limited set of applications
pacman -S --noconfirm xorg plasma sddm bluedevil konsole dolphin kcron ksystemlog partitionmanager ark okular kate kompare gwenview ktorrent kalendar kcalc elisa

#We enable some services on boot for the user to have a fully working system out of the box
systemctl enable sddm.service
systemctl enable NetworkManager
systemctl enable bluetooth.service


#Some manual intervention required from the user
echo -e "\n\nWe need to add our new user to the sudoer file, to do this ->\nUse the following command: EDITOR=nano visudo\nAdd this line with the correct username under the user privilege specification: NAMEOFUSER ALL=(ALL) ALL"

echo -e "\nOnce this step is done, you can reboot and delete the script from the home folder."


#If the user did not uncomment the additional sources from the pacman config file, we stop
else
echo -e "\nPlease uncomment the sources and start the script again\n"
fi
