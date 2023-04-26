# Martin's automatic Arch Linux install

PLEASE READ ENTIRELY

This script is still a work in progress.

This script is my personal automatic Arch Linux install script.

A little resume of what my script does:

- For UEFI
- Single boot (it must NOT be used for dualbooting, it will erase your disk, you are warned)
- No swap
- System in American English with Swiss french keyboard

Choices :
To make this script my universal install script, I implemented a choice for 3 different types of system :
- Full AMD (Amd CPU microcode + Amd GPU drivers, WARNING: NOT TESTED, I CURRENTLY DO NOT OWN AMD HARDWARE)
- Full Intel (Intel CPU microcode)
- Intel + Nvidia (Intel CPU microcode + Nvidia GPU drivers)

And 2 desktop environments (wayland not used with Nvidia):
- KDE Plasma
- Gnome


This install needs post work for a fully installed setup.
It is not documented here because it is where the install becomes personalized to you.
Thanks to this script you should have a good base to install your favorite software.
Keep in mind that with this kind of install you could encounter issues specific to your hardware, this is something you will have to troubleshoot yourself and can at times require advanced knowledge.


HOW TO USE :
--> You only need to download install1.sh, the other files will be downloaded automatically to the home folder.
--> When the system reboots, go to the home folder and run the next install(number).sh script.
--> If any manual work is required, it'll be documented during the installation.


Feel free to use, copy or modify the script as you will.
I would recommend against executing the file as is since it is designed for my configuration.

DISCLAIMER:
When you use, copy or modify any part of this script, you accept in good faith to be fully responsible to what happens to your computer (or whichever device you were using it with), and this even if the source file was not working as intended.
