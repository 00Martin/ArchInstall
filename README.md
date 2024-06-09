# Martin's "automatic" Arch Linux install
PLEASE READ ENTIRELY


This script is my personal automatic Arch Linux install script.

A little resume of what my script does:

- For UEFI
- Single boot (it must NOT be used for dualbooting, it will erase your disk, you are warned)
- No swap
- System in American English with Swiss French keyboard
- No browser installed by default, but you can optionally install Brave Browser or Mozilla Firefox during the installation

Choices:
To make this script my universal install, I implemented a choice for 3 different types of systems:
- Full Intel (Intel CPU microcode)
- Full AMD (Amd CPU microcode + Amd GPU drivers, NOT TESTED because I don't own AMD hardware)
- Intel + Nvidia (Intel CPU microcode + Nvidia GPU drivers)

And 2 desktop environments:
- KDE Plasma
- Gnome (not tested)

I also implemented the possibility to encrypt your root partition.


Thanks to this script you should have a good base to install your favorite software but I would recommend against executing the file without changes since the script is designed for my configuration.
Keep in mind that with this kind of install you could encounter issues specific to your hardware, this is something you will have to troubleshoot yourself and could require advanced knowledge.
Please also keep in mind that an upgrade to a package can break this script at any time, this is something I can only see during my next Arch installation.


HOW TO USE :
--> You only need to download install1.sh, the other files will be downloaded automatically to the home folder (with the command 'curl -LO raw.githubusercontent.com/00Martin/ArchInstall/main/install1.sh').
--> When the system reboots, go to the home folder and run the next install(number).sh script.
--> If any manual work is required, it'll be documented during the installation.
--> You don't need to execute anything more than install(number).sh, files with a different naming will be executed during the process.
--> All files will be cleaned at the end of the process, you don't need to delete any leftover files.

Feel free to use, copy or modify the script as you will.
Although I don't require it, It would be nice of you to leave my author note and github link at the top of the scripts, that way anyone can find my work again.

DISCLAIMER:
When you use, copy or modify any part of this script, you accept in good faith to be fully responsible to what happens to your computer (or whichever device you were using it with), and this even if my source file was not working as intended (since I make it public without any guarantees). If you don't understand what is in this script or don't feel comfortable enough with modifying it then it's probably out of your reach.
