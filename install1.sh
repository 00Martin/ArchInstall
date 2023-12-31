#!/bin/sh
#ArchInstall by 00Martin - https://github.com/00Martin
#file: install1.sh

#To simply the script, we will ask the user to create the partitions first
#We assume the user knows how partitions work, and will create them properly as described
echo -e "\nCreate your partitions first with -> cfdisk /dev/sda\n\nYour partitions must look like this:"
echo -e "sda1 - boot efi, 2GB recommended to allow multiple kernels TYPE: EFI System\nsda2 - system, can fill up the rest of the disk TYPE: Linux root (x86-64)\n"
echo -e "It is very important to properly precise the type of the partition or it might create errors when formatting the drive with a new filesystem.\n"
echo -e "If you have a NVMe drive, your drive will likely be called nvme0n1 instead of sda, change the cfdisk command accordingly.\n"
echo -e "If your main drive is a NVMe, a sda drive will still exist, it'll likely be your Arch Linux USB. Having a sda drive does NOT necessarily mean it is the right drive to install Arch on!!\n"
echo -e "If you are unsure about which device is your drive, you can use the lsblk command, you can then guess which drive is your main one based on it's size.\n\n"
echo -e "!!!MAKE SURE TO DISCONNECT ANY OTHER DRIVE THAT COULD POSSIBLY HAVE DATA ON IT AND THAT SHOULD ---> NOT <--- BE ERASED!!!\n\n"

#We ask the user if the partitions are created and the other devices disconnected
echo "Have you created the partitions AND disconnected every other drive that should NOT be erased? [n/Y]"
read answer

#If the partitions are ready and the drives are safe, we continue
if [[ $answer == "Y" ]]; then


#For time synchronization
timedatectl set-ntp true

#Set the keyboard as the user will have to change the root password
loadkeys fr_CH-latin1

echo -e "\nYour keyboard switched to Swiss French."


#We ask the user if they have a NVMe, because drive names are different
echo "Do you use a NVMe? [n/Y]"
read answerNVMe

if [[ $answerNVMe == "Y" ]]; then
	driveName="nvme0n1"
	partitionNameBoot="nvme0n1p1"
	partitionNameRoot="nvme0n1p2"
else
	driveName="sda"
	partitionNameBoot="sda1"
	partitionNameRoot="sda2"
fi


#We ask the user if they would like encryption
echo -e "\n\nWould you like to encrypt your drive? This may protect your data in case of physical theft of your device but will make your data unrecoverable in case of hardware failure (and potentially in case of software failure as well).\nMAKE SURE TO KEEP YOUR BACKUPS -> UP TO DATE <- IF YOU ENABLE ENCRYPTION!!! [n/Y]"
read answerEncrypt

#If the user wants encryption, some things will be done differently
if [[ $answerEncrypt == "Y" ]]; then

    #Encryption
    doWeEncrypt="1"

    #Set up of LUKS partition
    cryptsetup luksFormat /dev/$partitionNameRoot
    cryptsetup open /dev/$partitionNameRoot root
    mkfs.btrfs -L archSystem /dev/mapper/root

    #We mount root in the case of the encrypted volume
    mount /dev/mapper/root /mnt

else

    #No encryption
    doWeEncrypt="0"

    #Set disk filesystem for system
    mkfs.btrfs -L archSystem /dev/$partitionNameRoot

    #We mount root in the case of the non encrypted volume
    mount /dev/$partitionNameRoot /mnt

fi

#We setup boot which we do the same way regarless of encryption
mkfs.fat -F32 /dev/$partitionNameBoot
mkdir /mnt/boot
mount /dev/$partitionNameBoot /mnt/boot

#Getting Linux installed
pacstrap /mnt base linux linux-firmware nano

#System mount points
genfstab -U /mnt >> /mnt/etc/fstab
cat                 /mnt/etc/fstab


#Download and prepare the next scripts
curl -LO raw.githubusercontent.com/00Martin/ArchInstall/main/install-archchroot.sh
curl -LO raw.githubusercontent.com/00Martin/ArchInstall/main/install2.sh
curl -LO raw.githubusercontent.com/00Martin/ArchInstall/main/install3.sh
#We move the scripts to the home folder so it is saved and ready to use on the next reboot
mv install2.sh /mnt/home
mv install3.sh /mnt/home
#We move the archchroot script inside root so we can run it with the arch chroot command
mv install-archchroot.sh /mnt

#We save the user's encryption choice in a file
echo "$doWeEncrypt" > /mnt/home/encrypt.doNotDelete


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


#We prepare a warning message to make sure the user enters their choice the right way
warningMsg="Make sure to input your choice properly with no extra spaces or your choice will be ignored and the script will use the default option.\n"

clear
#We need to know what type of system the user has, this way we can install the hardware packages accordingly
echo -e "\n\nWhich type of system do you use?\n\n[0] Intel\n[1] Amd(not tested)\n[2] Intel + Nvidia\n[3] (default) My system does not match/I would like to install my own graphic driver and libraries\n\nYou are not meant to choose the default option here, you should only use it in specific cases.\n"
echo -e $warningMsg
read systemType
echo "$systemType" > /mnt/home/sysType.doNotDelete

clear
#We want to know which desktop environment the user would like to use
echo -e "\n\nWhich desktop environment would you like to use between KDE Plasma(default) or Gnome Desktop(not tested)? [k/g]\n"
echo -e $warningMsg
read deskEnv
echo "$deskEnv" > /mnt/home/deskEnv.doNotDelete


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

if [[ $doWeEncrypt == "1" ]]; then
    #If we are encrypted, we need to add LUKS specific kernel parameters to be able to boot on that encrypted drive
    #If the encrypted device is an SSD, we should enable regular trimming as well, this is done by using the luks.options=discard parameter to allow trimming, then enabling the systemd timer of fstrim which will do the trimming (done in the 2nd script).
    #In this encrypted setup our partitions are built by layers (First encrypted LUKS, then btrfs), here we're gonna enable discarding for LUKS, then btrfs is left to be configured but normally btrfs automatically adds the discard flag if the SSD is capable of TRIM.
    #Trimming an encrypted drive "leaks" information about which blocks are used and which are free, but here I'm looking for a middle ground between performance and absolute security.
    #If the device is not encrypted, nothing needs to be done because in that case we use btrfs which automatically enables asynchronous trimming if the drive is capable of TRIMs
    #We ask the user if they have a TRIM capable SSD
    echo -e "\n\nIs your primary storage device a TRIM capable SSD? (Answering wrong to this question can have consequences like data loss or reduced SSD longevity) [n/Y]"
    read answerTrim

    #We add an additional kernel parameter if the SSD is TRIM capable
    if [[ $answerTrim == "Y" ]]; then

        #Trim Capability
        shouldWeTrim="1"

        encryptedUUID=$(blkid -s UUID -o value /dev/$partitionNameRoot)
        echo "options rd.luks.name=$encryptedUUID=root root=/dev/mapper/root rd.luks.options=discard"    >>  /mnt/boot/loader/entries/arch.conf

    else

        #Trim Capability
        shouldWeTrim="0"

        encryptedUUID=$(blkid -s UUID -o value /dev/$partitionNameRoot)
        echo "options rd.luks.name=$encryptedUUID=root root=/dev/mapper/root"    >>  /mnt/boot/loader/entries/arch.conf

    fi

    #We save the user's SSD' trimming capability choice onto a file
    echo "$shouldWeTrim" > /mnt/home/ssdTrim.doNotDelete

    #Finally, there's some work the user needs to do, we give them the instructions
    echo -e "\n\n\nTo make your encrypted partition accessible, there's some extra work to do, don't worry, it's not gonna take long."
    echo -e "\nTake a picture of this before proceeding, the instructions will disappear."
    echo -e "\n\nFirst, we need to edit the HOOKS of the mkinitcpio.conf file."
    echo -e "\nTo do this, execute the following command:  nano /mnt/etc/mkinitcpio.conf"
    echo -e "\nFind the HOOKS=... line that does not have a # in front of it and edit it. It must look EXACTLY like the following example:"
    echo -e "\nHOOKS=(base systemd keyboard autodetect modconf kms sd-vconsole block sd-encrypt filesystems fsck)"
    echo -e "\nOnce done, save and exit."
    echo -e "\n\nWe now need to regenerate the initramfs, to do this you just need to execute the following command: arch-chroot /mnt mkinitcpio -p linux"
    echo -e "\n\nIf on reboot you are not asked for the password of your encrypted partition, then something went wrong, I recommended you to start the installation over again."

else
    #If not encrypted, we use normal systemd boot options
    echo "options root=/dev/$partitionNameRoot rw"    >>  /mnt/boot/loader/entries/arch.conf
fi

    echo -e "\n\nOptionally, you might want to restrict access to the boot partition when the OS is running."
    echo -e "To do so, use the following command: nano /mnt/etc/fstab   and replace the 22 values of fmask and dmask to 77, don't remove the 0s."
    echo -e "\nYou can now reboot your machine with the command: reboot"


#If partitions were not ready, we stop
else
echo -e "\nPlease create your partitions and start the script again\n"
fi
