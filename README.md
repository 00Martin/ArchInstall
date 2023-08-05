# Martin's automatic Arch Linux install

PLEASE READ ENTIRELY

This script is still a work in progress.

This script is my personal automatic Arch Linux install script.

A little resume of what my script does:

- For UEFI
- Single boot (it must NOT be used for dualbooting, it will erase your disk, you are warned)
- No swap
- System in American English with Swiss French keyboard
- No browser installed, you get to install your favorite browser yourself!

Choices :
To make this script my universal install, I implemented a choice for 3 different types of systems :
- Full AMD (Amd CPU microcode + Amd GPU drivers, NOT TESTED because I don't own AMD hardware)
- Full Intel (Intel CPU microcode)
- Intel + Nvidia (Intel CPU microcode + Nvidia GPU drivers)

And 2 desktop environments (wayland not used with Nvidia):
- KDE Plasma
- Gnome


Thanks to this script you should have a good base to install your favorite software but I would recommend against executing the file without changes since the script is designed for my configuration.
Keep in mind that with this kind of install you could encounter issues specific to your hardware, this is something you will have to troubleshoot yourself and could require advanced knowledge.


HOW TO USE :
--> You only need to download install1.sh, the other files will be downloaded automatically to the home folder.
--> When the system reboots, go to the home folder and run the next install(number).sh script.
--> If any manual work is required, it'll be documented during the installation.


Feel free to use, copy or modify the script as you will.

DISCLAIMER:
When you use, copy or modify any part of this script, you accept in good faith to be fully responsible to what happens to your computer (or whichever device you were using it with), and this even if my source file was not working as intended (since I make it public without any guarantees). If you don't understand what is in this script or don't feel comfortable enough with modifying it then it's probably out of your reach.
