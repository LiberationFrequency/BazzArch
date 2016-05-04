
*************************************************************************
*					BAZZARCH			*
*************************************************************************

Version:	no need for version controlling, it is just a backup.
		Change and destroy!

Date:		2016-05-03

License:	Good question. GPL, LGPL, BSD, MIT so far.
		I will take look into license issues as soon as possible.
		
Link to source: https://drive.google.com/open?id=0B2BaBYQTShFzVWNOVkdwUUJyUWc
Link to ZIP:	https://drive.google.com/open?id=0B2BaBYQTShFzU3Z2V1NQTGVTYjA

*************************************************************************

What is it?
-------------------------------------------------------------------------
This script creates a 64 bit Arch Linux live system ISO file, that you 
can burn on cd/dvd, copy to an usb storage or host in a virtual machine.
Only tested on machines with BIOS, but UEFI and vm should work. You can
create any system configuration you want, but this ISO should be optimized 
to act as an effect unit for bass guitars in future. This configuration 
contains a linux realtime kernel, Guitarix (with webui & specmatch), Calf,
Carla, Cadence, LV2/LADSPA/etc. plugins, rakarrack, Hydrogen, gtklick and 
a few impulse responses from two bass amplifiers, but they are not very well, 
they are too hushed. You will find better/louder IRs on the net, or you can 
create your own IRs with Expochirptool, a tool for pure data. 



Requirements:
------------------
* an Arch Linux system with archiso installed
 (maybe there is a solution for other operating systems, similar to 
 debootstrap, but I don't know in detail momentarily.) 
 It could be possible to perform this script with the official Live ISO, 
 you can download at 
 * https://www.archlinux.org/download/
 and install archiso with
 % sudo pacman -Syyu
 % sudo pacman -S archiso 
 You may have not enough memory on the live session. 
 Do something like copy the script to another USB storage with a filesystem
 that supports symbolic links,
 unfortunately fat32 does not. Ext2,3,4,reiser,zfs, you name it should work.
 Burn the official ISO on a cd/dvd, boot a live session to RAM 
 (from startdialog press "Tab" and enter copytoram=y) and execute the 
 build-rt.sh from the USB storage. The script will create a work and a out directory 
 to the path it was started. Something like that for example.
  
 * Download official ISO and burn it on a cd/dvd.
 * from startdialog press "Tab" and enter copytoram=y
 * partition a USB storage with ext3
 ** lsblk
 ** fdisk /dev/sdX
-> n = new
-> p = primary
-> ? = partition number
-> ? = first sector
-> ? = last sector
-> p = print config
-> w = write it to the storage

 ** mkfs.ext3 -L ISOmaker /dev/sdX1
 * mount the storage
 * mkdir /home/user/usbstick
 ** mount -t ext3 /dev/sdX1 /home/user/usbstick
 * Download the ZIP
 ** wget https://drive.google.com/open?id=0B2BaBYQTShFzU3Z2V1NQTGVTYjA
 * rename ID BazzArch.zip
 * unzip BazzArch.zip
 * or if unzip is not available
 ** bsdtar -xvf BazzArch.zip

 * create the customrepo and build the packages 
 (you have to adjust the path to the storage, instead to your home directory, no ~/)
 * run the script



HowTo: 
------------------

Copy mkarchiso-rt to ignore package installation of core packages (linux):
% sudo cp mkarchiso-rt /usr/bin/ 
This is the nearly the same file as mkarchiso, installed by archiso to /usr/bin/, but it calls pacstrap 
with the option -i to avoid auto-confirmation of package selections. The build-rt.sh will call this, so 
we can ignore linux and install just the linux-rt kernel.

The packages in packages.both can be installed from the official repositories and will be 
downloaded at creation process, if they are not present in your local pacman cache.
To install the packages in packages.x86_64 you have to build them from the Arch User Repository 
and create a custom repository on your local system (*1 appendix). Don't forget to adjust the path of the 
customrepo in the pacman.conf.
See the Arch wiki for further information. 
* https://wiki.archlinux.org/index.php/archiso 
If the package is no longer available in AUR, take a look into the archive.
* https://github.com/aur-archive

You can copy the SquashFS to RAM at booting process to free an USB port. Or you can make 
the USB storage persistent, so you can edit and save data to the storage. And/or you can create 
a script that will be automatically executed when the user logged onto system (* not working yet). 
Take a look into the config /BassISO/syslinux/archiso_sys64.cfg 
???For UEFI edit BassISO/efiboot/loader/entries/archiso-x86_64-usb.conf???

----------------------------------


## WLAN ## 
(You should renounce WLAN on a realtime system, if it is possible. The system should
be optimized for realtime audio, try to reduce all sources of error.)  
edit the config file ../airootfs/root/customize_airootfs.sh with your essid and password
then you can run the wlan script from the live session to connect to your Access-Point automatically , 
if the driver is installed correctly.
 % ~/./wlan.sh  




### Soundcards ###
There are some presets for qjackctl and it is preconfigured with a2jmidi and dbus support. 
The config file is in /airootfs/etc/skel/.config/rncbc.org

The config in Cadence is point to my Zoom B3, I believe. That is fine for me, but I think the midi
driver should set to raw (it's done). I think you can change the behaviour in the jack config.
airootfs/etc/skel/.config/jack/conf.xml  



### Guitarix ###
The guitarix presets are stored in /airootfs/etc/skel/.config/guitarix/banks

Guitarix can start with the webui by executing the script from the desktop , a tool for 
controlling a headless(embedded) guitarix with a browser on a smartphone or tablet 
(just some basic functionality at the moment).
It launches guitarix with 'guitarix --rpcport=7000', for headless use also -N (?).
Open "http://localhost:8000/" in your browser or with IP address from your mobile device. See 
% ip addr
to show information for all ip addresses.


Guitarix can launch with specmatch, a tool you can use to adapt the timbre from a recorded sound. 
Prepare your soundsnippet, play your part to this with a clean bass/guitar, the software will 
calculate the difference and create an impulse response for it.
Specmatch is not installed by default yet. You can install it by call
 % ~/./install-specmatch.sh   
from the console .After that it can be lauched by clicking the guitarix-specmatch script on the desktop.
See these posts for further information.
* http://guitarix.sourceforge.net/forum/viewtopic.php?f=15&t=4508
* https://linuxmusicians.com/viewtopic.php?t=12692





### Carla ### 
Carla effect rack presets are stored in the Carla desktop directory temporary.
There are some tries in this folder, nothing fancy, just playing around. I don't know why, but you can n
ot open them from the folder, then the rack will be empty. You have to open them via the dialog in carla, 
then it works.





### optional: Convert a png to the properties that supported by syslinux ###
 % convert -resize 640x480 -depth 16 -colors 65536 mynew.png splash.png





### Build the ISO with linux-rt ###
 % sudo ./build-rt.sh -v
(ignore linux and you can press enter to all other questions)

call this to build the ISO with the official linux kernel
- not tested 
 % sudo ./build.sh -v




### optional: Make the storage persistent (before copy ISO to USB) ###
 % cd out
First calculate how much space the persistent partiton should have 
(usb_drive_size_in_Gb - iso_image_size_in_Gb)*1024*1024*2
e.g. (8GB - 1GB) *1024*1024*2 = 14680064

 ??? % sudo chmod 777 Bazzarch.iso  ???  - no authorization
 % sudo dd status=progress if=/dev/zero bs=512 count=14680064 >> Bazzarch.iso

Create a partition in the ISO file:
 % fdisk Bazzarch.iso
-> n = new
-> p = primary
-> default = partition number
-> default = first sector
-> default = last sector
-> p = print config
-> w = write it to the ISO


create filesystem - you need start and end point of the partition
 % fdisk -l Bazzarch.iso
e.g.
Gerät         Boot   Start      End Sektoren Größe Kn Typ
Bazzarch.iso1 *          0  1607679  1607680  785M  0 Leer
Bazzarch.iso2          164    63651    63488   31M ef EFI (FAT-12/16/32)
Bazzarch.iso3      1607680 16287743 14680064    7G 83 Linux

By multiplying both these numbers with 512, you get resp the $OFFSET and $SIZELIMIT for the 
loopback device. 

 1607680 × 512 =  823132160
16287743 × 512 = 8339324416

 % sudo losetup -o $OFFSET --sizelimit $SIZELIMIT /dev/loop1 Bazzarch.iso
e.g.
 % sudo losetup -o 823132160 --sizelimit 8339324416 /dev/loop1 Bazzarch.iso
 % sudo mkfs -t ext3 -L cow /dev/loop1 # or another filesystem - (it should support symbolic links)
 % sudo losetup -d /dev/loop1


copy the ISO to USB

------------------------------------------------------------------------------------




### copy the ISO to USB ###
 % cd out
 % lsblk
 % sudo dd bs=4M if=Bazzarch....iso of=/dev/sdX && sync 
(where sdX is your USB storage - pay attention to hit the rigth one!!!)
make sure that the device is not mounted and dd it to the top 
(e.g. /dev/sdb and not /dev/sdb1) 
 ??? bs=4M vs. bs=512 ???






### known issues ###
* there was a error, something like client can not connect to jack2-dbus or similar 
(gconftool-2:9947): GConf-WARNING **: Client failed to connect to the D-BUS daemon:
/usr/bin/dbus-launch terminated abnormally with the following error: No protocol specified
Autolaunch error: X11 initialization failed.

* guitarix behave buggy, when you scoll through the impulse responses and it will crash.

* pd-extended does not launch from the startmenue, but with pd from the console.

* when faustqt-programms will be closed, the app is still shown in the system tray. 

* The Carla preset BassIRmin does not work with Klangfalter. There is no wet signal.
  My fault, I edited the preset manually.  

* mkinitcpio runs twice ????

* qterminal not in german? y vs. j




### ToDo ###
* sign the packages in the customrepo when updating, so you can
  upload them to an online repository. 
* Calculator with sparse dependencies 
* include Edit & Share 
* create a PKGBUILD for specmatch
* create a PKGBUILD for chaoschimp
* create a PKGBUILD for midikbd  
 * pacman-key --init ????
* put persistent installation into a script
* try nvidia-340xx-rt for GT218M [GeForce G210M] / failed linux-rt<4.2 -> try nvidia-340xx-dkms





### Installation ###
If you wish to install the ISO as it is without an Internet connection, or, if you do not want 
to download the packages you want again, take a look at 
* https://wiki.archlinux.org/index.php/archiso#Installation_without_Internet_access









-----------------------------------appendix-------------------------------------------

(* 1) 

Create customrepo directories to your local system
% mkdir ~/customrepo
% mkdir ~/customrepo/x86_64
% mkdir ~/customrepo/i686


Build packages, e.g. linux-rt
https://aur.archlinux.org/packages/linux-rt/
You get the wget link by copy the link 'Download snapshot'
---------------
 % mkdir AUR
 % cd AUR
 % mkdir linux-rt
 % cd linux-rt
 % wget https://aur.archlinux.org/cgit/aur.git/snapshot/linux-rt.tar.gz
 % tar -xvzf linux-rt.tar.gz
 % cd linux-rt
 % makepkg -s

 % cp *.pkg.tar.xz ~/customrepo/x86_64

optional: install package to your local system
 % sudo pacman -U linux-rt.pkg.tar.xz

Do this for all other packages you want!

 % cd ~/customrepo/x86_64
Calculate checksums for all included packages in the directory and create the database entries
 % repo-add ~/customrepo/x86_64/customrepo.db.tar.gz ~/customrepo/x86_64/*.pkg.tar.xz


Adapt the path in the pacman.conf to your local customrepo!


-----------------------------------end appendix---------------------------------------
