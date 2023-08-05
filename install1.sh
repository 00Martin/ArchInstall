#!/bin/sh
#ArchInstall by MD^ (Martin)
#file: install1.sh

#To simply the script, we will ask the user to create the partitions first
#We assume the user knows how partitions work, and will create them properly as described
echo -e "\nCreate your partitions first with -> cfdisk /dev/sda\n\nYour partitions must look like this:"
echo -e "sda1 - boot efi, 2GB recommended to allow multiple kernels TYPE: EFI System\nsda2 - system, can fill up the rest of the disk TYPE: Linux root (x86-64)\n"
echo -e "It is very important to properly precise the type of the partition or it might create errors when formatting with a filesystem\n\n"

#We ask the user if the partitions are created
echo "Have you done this ? [n/Y]"
read answer


#If the partitions are ready, we continue
if [ $answer == "Y" ]; then

#Set the keyboard as the user will have to change the root password
loadkeys fr_CH-latin1

#For time synchronization
timedatectl set-ntp true


#Set disk filesystem for boot and system
mkfs.fat    -F32                /dev/sda1
mkfs.btrfs  -L ArchSystem       /dev/sda2

#we mount these partitions
mount /dev/sda2 /mnt
mkdir           /mnt/boot
mount /dev/sda1 /mnt/boot

#Getting Linux installed
pacstrap /mnt base linux linux-firmware nano

#System mount points
genfstab -U /mnt >> /mnt/etc/fstab
cat                 /mnt/etc/fstab


#Download and prepare the next scripts
curl -LO raw.githubusercontent.com/00Martin/ArchInstall/testing/install-archchroot.sh
curl -LO raw.githubusercontent.com/00Martin/ArchInstall/testing/install2.sh
curl -LO raw.githubusercontent.com/00Martin/ArchInstall/testing/install3.sh
#We move the scripts to the home folder so it is saved and ready to use on the next reboot
mv install2.sh /mnt/home
mv install3.sh /mnt/home
#We move the archchroot script inside root so we can run it with the arch chroot command
mv install-archchroot.sh /mnt


#We run certain commands that would typically be ran inside of arch-chroot here.
#We do this as certain commands can cause issues when ran directly through arch-chroot
#Set the locale
echo "en_US.UTF-8 UTF-8"    >>  /mnt/etc/locale.gen
echo "LANG=en_US.UTF-8"     >   /mnt/etc/locale.conf
#Set keyboard for the system and Plasma on X11
echo "KEYMAP=fr_CH"     >   /mnt/etc/vconsole.conf
echo "XKBLAYOUT=ch"     >>  /mnt/etc/vconsole.conf
echo "XKBVARIANT=fr"    >>  /mnt/etc/vconsole.conf

echo -e "\n\nEnter the desired hostname for this computer, input is not verified."
read cpthostname
#set hostname and hosts
echo "$cpthostname"                                             >   /mnt/etc/hostname
echo "127.0.0.1       localhost"                                >>  /mnt/etc/hosts
echo "::1             localhost"                                >>  /mnt/etc/hosts
echo "127.0.0.1       $cpthostname.localdomain    $cpthostname" >>  /mnt/etc/hosts


#Run the archchroot script inside arch-chroot
arch-chroot /mnt sh install-archchroot.sh

#We delete the archchroot file after it was ran to keep the install clean
rm /mnt/install-archchroot.sh


#BOOTLOADER: config
#We created the systemd bootloader files in the archchroot script, we now need to configure the bootloader
echo "default arch"                 >>  /mnt/boot/loader/loader.conf
touch /mnt/boot/loader/entries/arch.conf
echo "title Arch Linux"             >   /mnt/boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux"         >>  /mnt/boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img"  >>  /mnt/boot/loader/entries/arch.conf
echo "options root=/dev/sda2 rw"    >>  /mnt/boot/loader/entries/arch.conf


#Rebooting into our newly installed arch system, the user will have to run the next script which was put into the home folder
reboot


#If partitions were not ready, we stop
else
echo -e "\nPlease create your partitions and start the script again\n"
fi
