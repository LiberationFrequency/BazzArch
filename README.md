
*************************************************************************
					                BAZZARCH			
*************************************************************************
			
Work in progress.
						
Version: no need for version controlling, its just a backup.  	
									
Date:		2017-01-26    						
Demo Deadline:	2017-xx-xx  

License:	Good question. GPL, LGPL, BSD, MIT so far.
		I will take look into license issues as soon as possible.

Output size (ISO) for this current config: 1375731712 Bytes (1,4 GB, 1,3 GiB) BazzArchDemoMin-2017.01.10-x86_64.iso      
Output size (ISO) for this current config: 1679605760 Bytes (1,7 GB, 1,6 GiB) BazzArch-2017.01.26-x86_64.iso      
Needed pacman cache size for this current config (/var/cache/pacman/pkg): approx 2 GB    
Needed customrepo size for this current config:: ??? (overall 3 GB)  
Nedded work directory size for this current config: approx 8 GB  

Source:  
GitHub: https://github.com/LiberationFrequency/BazzArch.git  
Zip: 	https://github.com/LiberationFrequency/BazzArch/archive/master.zip

Mirror:		
 

----------------------------------------------------------------------  

Changelog:  
* set customrepo in pacman.conf on the first position for installing own, newer packages than the officinal one, but with the same name.     
* use aubio-0.4.4  

Comment:  
Standard DemoMin&Mid test. 
(for nvidia-340xx-rt legacy test see(*4 appendix))  

uname -r  
4.8.15-rt10-1-rt  
 

I deleted the cups config. To configure cups you need a root password. But this live session 
has no root user, so you have to change the security config temporary.  
Edit /etc/cups/cupsd.conf: (done, but does not have an effect)  
DefaultAuthType None  
And comment all lines with @System. After that you have to restart cups with:   
 
    % sudo systemctl restart org.cups.cupsd.service   

Brother driver does not appear, works previously.  
  
  



*************************************************************************

What is it?
-------------------------------------------------------------------------
This script creates an 64 bit Arch Linux live system ISO file for audio production purpose, 
that you can burn on cd/dvd, copy to an usb storage or host in a virtual machine. 
Only tested on machines with BIOS, but UEFI should also work. 
You can create any system configuration you want, but this ISO should be optimized to act 
as an effect unit for bass guitars in future. This configuration contains a linux realtime kernel, 
Guitarix (with webui & specmatch), Calf, Carla, Cadence, jalv-select, LV2/LADSPA/etc. plugins, 
rakarrack, Hydrogen, (gt)klick, LilyPond and a few impulse responses from two bass amplifiers, but they are not 
very well, they are too hushed. You will find better/louder IRs on the net, or you can 
create your own IRs with Expochirptool, a tool for pure data. 



Requirements:
------------------
* an Arch Linux system with archiso installed  
 (maybe there is a solution for other operating systems, similar to 
 debootstrap, but I don't know in detail momentarily.) (*1 appendix)  
  
* an Internet connection   
  Unfortunately it downloads some things on every build, even if you have all packages available.  
  see this for a possible solution: http://software.techforums.space/software/easy-way-to-use-archiso-for-100-offline-installs-all-packages-on-iso-4928fb3f.html  

* for this configuration you need a minimum of 2 (1.9) Gigabyte RAM. 4 (3.8) Gigabyte for suspend to RAM.   


HowTo: 
------------------

Copy mkarchiso-rt to ignore package installation of core packages (linux):  
% sudo cp mkarchiso-rt /usr/bin/   
This is the nearly the same file as mkarchiso, installed by archiso to /usr/bin/, but it calls pacstrap 
with the option -i to avoid auto-confirmation of package selections. The build-rt.sh will call this, so 
we can ignore linux and install just the linux-rt kernel.

The packages in packages.both can be installed from the official repositories and will be downloaded at creation process, if they are not present in your local pacman cache /var/cache/pacman/pkg. To install the packages in packages.x86_64 you have to build them from the Arch User Repository and create a custom repository 
on your local system (*2 appendix).  

You can copy the SquashFS to RAM during the boot process to free an USB port. Or you can make the USB storage persistent, so you can edit and save data to the storage. And/or you can create a script that will be automatically executed when the user logged onto system (* not working yet). 
Take a look into the config /BassISO/syslinux/archiso_sys64.cfg   
???For UEFI edit BassISO/efiboot/loader/entries/archiso-x86_64-usb.conf???




Build the ISO with linux-rt:  
-------------------------------------     
Configure the script and make sure your local copy of sudoers is owned by root  

    % la [..]/airootfs/etc/sudoers   
    % sudo chown root:root [..]/airootfs/etc/sudoers  

Of course you can and also should use your system sudoers, this file is a backup.  
    % sudo cp /etc/sudoers /path/to/BazzArch/airootfs/etc/  

     % sudo ./build-rt.sh -v
(ignore linux and you can press enter to all other questions)

call this to build the ISO with the official linux kernel -- not tested   
 % sudo ./build.sh -v


Copy the ISO to USB:    
--------------------------------------------   
     % cd out  
     % lsblk  
     % sudo dd bs=4M if=BazzArch....iso of=/dev/sdX && sync   
(where sdX is your USB storage - pay attention to hit the rigth one!!!)  
make sure that the device is not mounted   
umount /dev/sdX   
and dd it to the top (/dev/sdX and not /dev/sdX1)   
 ??? bs=4M vs. bs=512 ???






Known issues:  
------------------------------------------  
* Guitarix: Gtk-Message: Failed to load module "canberra-gtk-module"   

* enter /usr/share/application with PCManFM-QT let it crash sometimes.     

* Suspend to RAM does not work on some machines. Maybe a BIOS/ACPI issue, maybe unrecoverable.  
  * Mouse freeze sometimes after resume from suspend.  

* WebUI-script can only be use one time    

* ?irqbalance? installed  / Is it recommended with rt and tuna?    
  
* specmatch PKGBUILD does not work. There is no scikits.audiolab in pip. ?pip it with sudo?  
  * The PKGBUILD build with an error: ERROR: ld.so: object 'libfakeroot.so' from LD_PRELOAD cannot be preloaded (cannot open shared object file): ignored.  
  * specmatch should be essential for BazzArch. Install it manualy and copy paste it to the system.  
   
* no trashcan / can not delete a file via pcmanfm-qt ?!  

* LXQT requests xscreensaver after resume. Why? I don't want use it?  

* linux-api-headers 4.5.5-1 ??? can't ignore it from core. Replacement for RT???  

* startbuilt -> plymouth -> Error: file not found '/etc/os-release'  

* guitarix 0.35.0.r10.g5640286-1-x86_64 does not start: error while loading shared libraries: libbluetooth.so.3: 
cannot open shared object file: No such file or directory    
fixed -- pacman -S bluez-libs   

* (fix?) A stop job is running ... -> https://bbs.archlinux.org/viewtopic.php?pid=1618677#p1618677

* optimize-rt-blankscreen.service: Unit entered failed state.  
optimize-rt-blankscreen.service: Failed with result 'exit-code'.  


* You have to downgrade Xorg for older Nvidia cards.  
Unsupported drivers  
"If you have a GeForce 5 FX series card or older, Nvidia no longer supports drivers for your card. 
This means that these drivers do not support the current Xorg version. It thus might be easier if you use 
the nouveau driver, which supports the old cards with the current Xorg."     
https://wiki.archlinux.org/index.php/NVIDIA#Unsupported_drivers  

  
* .git file is too large. Fix it!  (It will move to a own Demo-Repository later.)

* VLC can not play mp.3/4 from Android / mtp://[usb...]  
* Drag'n'drop does not work from Android device.  
* Hardware Support - https://sourceforge.net/p/libmtp/code/ci/HEAD/tree/src/music-players.h  

* faust2 does not work with gcc 6.1.1. Too much work. Downgrade it manually or wait till anybody feel responsible.   
* when faustqt-programms will be closed, the app is sometimes still shown in the system tray. 
* faust2lv2 -gui -qt5 show no gui / -qt4 works / qt4/5 are installed  
   
* wpa_passphrase write the pwd also in cleartext to file /etc/wpa_supplicant/wpatest.conf  

* Preset in guitarix is too loud. Pay attention for your equipment and your ears!      
  * guitarix behaves buggy, when you scoll through the impulse responses and it will crash.  
  * choosing IRs in Klangfalter makes a lot of digital Sound.     
* (fixed) Hydrogen is too loud. Pay attention for your equipment and your ears!  







ToDo:  
--------------------------------------------------------  
* add customrepo to list of installed packages  
  * mkarchiso-rt line 265  

* add Launchpad support (maybe not with rt)
 * try e.g. https://github.com/FMMT666/launchpad.py   
  
* Configure cups  

* Debug realtime!  rtcheck  
  * --> rtc0 and hpet max user frequency  
    * Suggested value is 2048 or more  
    * 64  
    * 64    
    * sudo echo 2048 > /sys/class/rtc/rtc0/max_user_freq                                                          :(
      * zsh: keine Berechtigung: /sys/class/rtc/rtc0/max_user_freq  

  * STANDARD TEST
    * as root: /dev/cpu_dma_latency set to 0us  
      * policy: fifo: loadavg: 37.06 12.64 4.60 1/221 5151          
      * T: 0 ( 5150) P:98 I:100 C:  10000 Min:      4 Act:   10 Avg:    9 Max:      37
      * T: 1 ( 5151) P:98 I:100 C:  10000 Min:      4 Act:    9 Avg:    8 Max:      40
    * as live-user: open /dev/cpu_dma_latency: Permission denied  
      * policy: fifo: loadavg: 0.15 7.03 6.28 1/221 5632          
      * T: 0 ( 5630) P:98 I:100 C:  10000 Min:      4 Act:   21 Avg:   21 Max:      76  
      * T: 1 ( 5631) P:98 I:100 C:   9965 Min:      5 Act:    8 Avg:   22 Max:     102    

  * --> Realtime is really working?  
    * /etc/pam.d/system-auth:session   required  pam_limits.so  
    * /etc/pam.d/system-services:session   required    pam_limits.so  
    * That should be okay, but take a look, I mean there is more to configure.  
  * ... 


* MIDI tools   

* b43 firmware for rt-kernel ???  

* (done)update airootfs/etc/udev/rules.d/51-android.rules   
  * cp from here: https://github.com/snowdream/51-android/blob/master/51-android.rules  
  ** see also: https://github.com/M0Rf30/android-udev-rules  

* Split packages for demo.  
  * DemoMin - Minimal demo that fits on usual DVD.    
  * DemoMid - Standard demo with a changing sizefile. Usual Live-Demo without making it persitent.  
  * DemoMax - Custom demo with an option for a persitent storage loop.  

* Multilingual support  
  * hyphen-en/de/etc. would blow up the scope for a Demo. You have to build an ISO for each language.    

* (done) install librosa (PKGBUILD available at AUR) -  % pip2 install [-e] librosa  
https://github.com/librosa/librosa/blob/master/librosa/beat.py 

* File extension associations - /.local/share/applications
* maybe add a extra Player with jack-support. Or see jack-plugin.           
* add Time Sync - ntpd  
* try scanner over network -> brsaneconfig4 -a name="Brother" model="MFC-7360n" ip=YOUR.SCANNER.IP.HERE       
* fit graphic drivers/config for realtime  
* fit MIDI for realtime / create PKGBUILD for jamrouter    
* Create a splash screen  
* Create some presets   
* "open Terminal here"-dialog  -> proof of concept temporary / Only works with xterm / 
link xterm to qterminal / Only works on the top of directories, not in the folders or on the dektop.  
* pacman and multilib  
* sign the packages in the customrepo when updating, so I can
  upload them to an online repository.  
* Battery Watcher widget??, Windows/Super key????.    
* File extension associations - /.local/share/applications     
* extern screen -> works (only VGA with nouveau tested)  
* write a PKGBUILD for ZooFX   
* write a PKGBUILD for specmatch  
* write a PKGBUILD for chaoschimp
http://teragonaudio.com/ChaosChimp.html
* create a PKGBUILD for midikbd  
* put persistent installation into a script    
* add gEDA,   
* Adjust the application menu - menu://applications  
It is possible to edit menu entries by editing their .desktop files stored in /usr/share/applications/lxqt-*.desktop files.  
* write a GUI for klick in QT -> Tutorials: http://zetcode.com/  

* try Studio-Link LV2 Plugin with carla,jalv,guitarix -> see also https://github.com/Studio-Link/PKGBUILDs  






----------------------------------
# Features:  


## WLAN   
(You should renounce WLAN on a realtime system, if it is possible. The system should
be optimized for realtime audio, try to reduce all sources of error.)  
Edit the config file ../airootfs/root/customize_airootfs.sh with your essid and password, then you can run the wlan script from the live session to connect to your Access-Point automatically , 
if the driver is installed correctly.  
https://wiki.archlinux.org/index.php/Wireless_network_configuration#Drivers_and_firmware  

    % ./wlan.sh   
from the home directory. For LAN just connect your computer before startup. Otherwise you get the IP with  

    % ip addr  
    % sudo dhcpcd enp...    
 

## Network Manager  
ConnMan mit cmt GUI.  



## Soundcards  
There are some presets for qjackctl and it is preconfigured with a2jmidi and dbus support. 
The config file is in /airootfs/etc/skel/.config/rncbc.org

The config in Cadence is pointed to my Zoom B3, I believe, that is fine for me.
You can change the behaviour in the jack config.  
..airootfs/etc/skel/.config/jack/conf.xml 

In [..]airootfs/var/lib/alsa/asound.state is a test config file of the last state of a 
Focusrite Scarlet 18i8 soundcard located. (deleted)   


You could also save the mixer settings into a custom file with alsactl,   
e.g. (not tested)  

    % alsactl --file ~/.config/alsa/device/stage/asound.state store  
loading  

     % alsactl --file ~/.config/alsa/device/studio/asound.state restore  

   


## Guitarix   
The guitarix presets are stored in /airootfs/etc/skel/.config/guitarix/banks

Guitarix can start with the webui by executing the script from the desktop, a tool for 
controlling a headless (embedded) guitarix with a browser on a smartphone or tablet 
(just some basic functionality at the moment).
It launches guitarix with 'guitarix --rpcport=7000', for headless use also -N (?).
Open http://localhost:8000/ in your browser or with IP address from your mobile device. See  

    % ip addr  
to show information for all ip addresses.



Guitarix can launch with specmatch, a tool you can use to adapt the timbre from a recorded sound. 
Prepare your soundsnippet, play your part to this with a clean bass/guitar, the software will 
calculate the difference and create an impulse response for it.
Specmatch is not installed by default yet. You can install it by call from /home/live-user    

    % ./install-specmatch.sh   
from the console. After that it can be lauched by typing specmatch, the startmenu or clicking the 
guitarix-specmatch script on the desktop.  
See these posts for further information.  
http://guitarix.sourceforge.net/forum/viewtopic.php?f=15&t=4508
https://linuxmusicians.com/viewtopic.php?t=12692


Install (or guitarix on its own, if you don't want use specmatch):  
packages.both:

    pygtk  
    python2-matplotlib  
    python2-numpy  
    python2-scipy  
    bluez-libs (???)  
  
packages.x86_64: 

    guitarix-git / guitarix2 from packages.both should also work.  
    jack-stdout-git  
    libsndfile  
    scikits-base  



## Carla  
Carla effect rack presets are stored in the Carla desktop directory temporary.
There are some tries in this folder, nothing fancy, just playing around. I don't know why, but you can n
ot open them from the folder, then the rack will be empty. You have to open them via the dialog in carla, 
then it works.  

Install:  
packages.x86_64: 

    carla-git  
 


## (Gt)Klick  

Metronom application for JACK. GTK GUI for the klick command-line tool.  
http://das.nasophon.de/klick/  
e.g.  

     % klick -i -P 4/4 100  


Dependencies  

    klick-git (≥ 0.11.0, built with OSC support)  
    pyliblo (≥ 0.7.0)  
    Python (≥ 2.5)  
    PyGTK  

klick: 

    JACK Audio Connection Kit  
    Boost (headers only)  
    libsamplerate  
    libsndfile  
Optional:  

    liblo  
    Rubber Band  


Links:  
* http://das.nasophon.de/klick/manual.html  
* http://manual.ardour.org/synchronization/timecode-generators-and-slaves/  
* http://das.nasophon.de/download/klick2ardour.py  



## FAUST (not available in Demo)     
FAUST (Functional Audio Stream) is a functional programming language specifically designed for real-time 
signal processing and synthesis. The FAUST compiler translates FAUST code into a C++ object, which may 
then interface with other C++ code to produce a full program. There is some FAUST code in the home directory, 
I tested them with faust2jaqt and faust2lv2 -gui (-qt4). Copy it to /home/live-user/.lv2 and it is available in 
Carla, Guitarix (?), jalv-select (?). I tested only Carla and it works.   

Install:  

    packages.both: base-devel  
    packages.x86_64: faust2-git 
  


## Pyo  
Pyo is a Python module written in C to help DSP script creation.  

Install: 

    Python 2.x (https://www.python.org/downloads/)  
    python2-pyo (http://ajaxsoundstudio.com/software/pyo/)  
    PyAudio (https://people.csail.mit.edu/hubert/pyaudio/) [or Jack (http://jackaudio.org/)]  
    wxPython (http://www.wxpython.org/)  


## Pure Data  
Pure Data (aka Pd) is an open source visual programming language that can run on anything from personal computers and Raspberry Pis to smartphones (via libpd, pddroidparty, and Rjdj). Pd enables musicians, visual artists, performers, researchers, and developers to create software graphically without writing lines of code.  

## ExpoChirpToolBox  
ExpoChirpToolbox is an impulse response (IR) measurement tool chain in Pure Data, available for Windows, OSX and Linux. It implements the Exponential Sine Sweep method which has been so succesfully advocated by Angelo Farina. The toolbox is in developement, and has functionality for the generation of test signals, recording test responses, IR editing and basic IR analysis. The edited IR can be applied as a convolution filter in the toolbox.  




## LilyPond with Denemo
Project Website: http://www.denemo.org/  

LilyPond is a music engraving application with high quality, which is based upon text.   
Denemo lets you rapidly enter notation which it typesets using the LilyPond music engraver. Music can be typed in at the PC-Keyboard (watch demo), or played in via MIDI controller (watch demo), or input acoustically into a microphone plugged into your computer’s soundcard.   


There are a few examples. Execute this to generate a PDF file:  

    % lilypond name.ly  


Install:  
packages.both: lilypond   
packages.both: denemo   



## Camera Support  
The kernel uvcvideo and a few gspca modules are loaded by default. VLC can record, play, stream and convert.  
That works fine for me, and should support a lot of hardware. For further information, take a look at  
http://www.ideasonboard.org/uvc/  
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/video4linux/gspca.txt?id=HEAD  
https://wiki.archlinux.org/index.php/Webcam_setup  

For seeing, which modules are available, take a look at /lib/modules/4.4.9-rt17-1-rt/kernel/drivers/media/usb  


You can also use the application cheese from packages.both, for example.  
 



 

## Exiftool (not available in minimal demo)  
Perl-image-exiftool is a reader and rewriter of EXIF informations that supports raw files. 
It answers to the name of image, but it can also be used to read/write audio/video format's metadata.  

Example:  
Show metadata:  

    % exiftool filename  
delete metadata:  

     % exiftool -all=filename  
 


## Samba/Windows Sharing  
The smbclient provides an easy access to download or upload a file from Samba or Windows easily, or use printer over the network.  

It is integrated into PCManFM:  
Press Ctrl+l and enter smb://servername/share in the location bar to access your share.  

The mounted share is likely to be present at /run/user/your_UID/gvfs or ~/.gvfs in the filesystem.  
 


## Screen Recorder (not available in minimal demo)    

SimpleScreenRecorder can handle Jack for audio.  

## ZooFX  
Test... A collection of shell scripts that use SysEx messages to interact with a Zoom (B3) effect unit and handle some useful tasks.      

## AUDIO2MIDI 
At the moment only the dependencies are prepared. You have to download the main apps manually.
  * https://github.com/justinsalamon/audio_to_midi_melodia  
  * http://mtg.upf.edu/technologies/melodia  
and copy the MTG-MELODIA-files to /usr/local/lib/vamp  

then e.g. 
python2 audio_to_midi_melodia.py ../test.wav ../song.mid 115 --smooth 0.25 --minduration 0.1 [--jams]  


## Sonic Visualiser   
Sonic Visualiser is an application for viewing and analysing the contents of music audio files.  

## CPU-Performance  
Because this master tree of the live session is more than just an effect unit, I integrate a switch to qjackctl, 
so the machine runs only with full power, if Jack is running, otherwise it scales the cpu power. It only works with qjackctl 
at the moment, it executes "sudo cpupower ..." on start and end. That's ugly, but it does the job well.   

 
     % watch grep \"cpu MHz\" /proc/cpuinfo  

     % cpupower frequency-info  

     % cpupower frequency-set -g performance  
ondemand  

not integrated:  
conservative  		  
powersave   		
  
  


## RT-Test  

Tuna is a tool that can be used to adjust scheduler tunables such as scheduler policy, RT priority and CPU affinity.  

     % sudo tuna  

Cyclitest (package: rt-test) and feed it to oscilloscope (package: tuna):  

     % sudo cyclictest --smp -n 99 -m -v | oscilloscope > /dev/null  


chrt - manipulate the real-time attributes of a proces  
     % chrt -f -p 2255 80  
This will set the scheduler to SCHED_FIFO for pid 2255 and sets rtprio 80 for it.  

see also:  
* https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_MRG/1.3/html-single/Tuna_User_Guide/index.html  
* https://www.osadl.org/Single-View.111+M52212cb1379.0.html  


----------------------------------------------------------------  

# Tips & and tricks 

    Convert a png to the properties that supported by syslinux (optional)   
      * % convert -resize 640x480 -depth 16 -colors 65536 mynew.png splash.png

 
    Take a screenshot with  
      * % import name.png  
    * or from the root window:  
      * % import -windows root name.png  
    * or time-delayed (10 seconds):  
      * % sleep10; import

  
    Activate USB-Tethering, very helpful if the wireless driver is installed:  
      * enable it on your phone/tablet   
    * in Arch:  
      * ls /sys/class/net  
      * dhcpcd ... / e.g. usb0  


    Convert a .mp4 to a .mp3 or .wav  
     * mp3: ffmpeg -i input.mp4 -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 output.mp3  
     * wav: ffmpeg -i input.mp4 output.wav  
    

    MIDI2wav - at the moment with freepats
      timidity input.mid -Ow -o out.wav


## Make the storage persistent (before copy ISO to USB) (optional)   
         % cd out  
First calculate how much space the persistent partiton should have   
(usb_drive_size_in_GB - iso_image_size_in_GB)*1024*1024*2
e.g. (8GB - 1GB) *1024*1024*2 = 14680064

    ??? % sudo chmod 777 BazzArch.iso  ???  - no authorization  
     % sudo dd status=progress if=/dev/zero bs=512 count=14680064 >> BazzArch.iso

Create a partition in the ISO file:  

    % fdisk BazzArch.iso  
-> n = new  
-> p = primary  
-> default = partition number  
-> default = first sector  
-> default = last sector  
-> p = print config  
-> w = write it to the ISO  


Create filesystem - you need start and end point of the partition

     % fdisk -l Bazzarch.iso  
e.g.  (fix formatting)  
Gerät         Boot   Start      End Sektoren Größe Kn Typ  
Bazzarch.iso1 *          0  1607679  1607680  785M  0 Leer  
Bazzarch.iso2          164    63651    63488   31M ef EFI (FAT-12/16/32)  
Bazzarch.iso3      1607680 16287743 14680064    7G 83 Linux  

By multiplying both these numbers with 512, you get resp the $OFFSET and $SIZELIMIT for the loopback device. 

 1607680 × 512 =  823132160  
16287743 × 512 = 8339324416
  
    % sudo losetup -o 823132160 --sizelimit 8339324416 /dev/loop1 Bazzarch.iso  
     % sudo mkfs -t ext3 -L cow /dev/loop1  
    # or another filesystem - (it should support symbolic links)  
     % sudo losetup -d /dev/loop1


copy the ISO to USB

------------------------------------------------------------------------------------



# Installation   
If you wish to install the ISO as it is without an Internet connection, or, if you do not want   
to download the packages you want again, take a look at   
https://wiki.archlinux.org/index.php/archiso#Installation_without_Internet_access  









# Appendix

(* 1) Work with the official live ISO  
 (not working yet)

 For me it is important to create a clean, new, official system, and maybe it could be possible
 to perform this script with the official Live ISO, you can download at 
 https://www.archlinux.org/download/
 
 (not working yet ...)  
 You may have not enough memory on the live session. 
 Do something like copy the script to another USB storage with a filesystem
 that supports symbolic links, unfortunately fat32 does not. Ext2,3,4, reiser, zfs, you name it should work.
 Burn the official ISO on a cd/dvd, boot a live session to RAM 
 (from startdialog press "Tab" and enter copytoram=y) and execute the 
 build-rt.sh from the USB storage. The script will create a work and a out directory 
 to the path it was started. Something like that for example

Download official ISO and burn it on a cd/dvd.  
https://www.archlinux.org/download/  
From startdialog press "Tab" and enter copytoram=y

Load german keyboard configuration  

    % loadkeys de-latin1  
Partition a USB storage with ext3  

     % lsblk  
    % fdisk /dev/sdX  
 
-> d = delete partition  
-> n = add new partition  
-> p = primary  
-> default = partition number   
-> default = first sector  
-> +4G = last sector - approx 4 GB, or default to use all empty space.   
-> p = print config  
-> w = write it to the storage  

Create filesystem  

    % mkfs.ext3 -L ISOmaker /dev/sdX1

The problem is, that running makepkg as root is not allowed, as it can cause 
permanent catastrophic damage to you system, but there is no other user.

Add a new live-user  

     % useradd -m -p "" -g users -s /usr/bin/zsh live-user

Add live-user to sudoers without password request  

     % echo "live-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers  
Usually you must edit sudoers with visudo, but this works.  

Login as live-user on a new console  
STRG + ALT + F2

create directory and mount the device

     % mkdir usbstick
     % sudo mount -t ext3 /dev/sdX1 usbstick  
     % cd usbstick  
Download the ZIP  

     % wget https://github.com/LiberationFrequency/BazzArch/archive/master.zip  
     % bsdtar -xvf master.zip  

     % sudo pacman -Syyu

 create the customrepo and build the packages 
 (you have to adjust the path to the storage, instead to your home directory, no ~/)
 
Error: One or more PGP signatures could not be verified!  
Possible Solution: updated the (pacman-keyring) and also ran (pacman-key --init; pacman-key --populate archlinux)  
The signature must be trusted by your user, not by root using the pacman-key command. For this use the gpg command.   
 % gpg --recv-keys $missing hash$
--------------------------------------
 % sudo pacman-key --init    
 % sudo pacman-key --populate archlinux  


Install archiso  
 % sudo pacman -S archiso  

run the script


--------------------------------------------------------


(* 2) Build packages from AUR  

Create customrepo directories to your local system

    % mkdir ~/customrepo
    % mkdir ~/customrepo/x86_64
    % mkdir ~/customrepo/i686


Build packages, e.g. linux-rt  
I created a repository, where I started to collect the necessary PKGBUILDs.  
https://github.com/LiberationFrequency/PKGBUILDs/tree/master/BazzArch  
Also you will found them in the Arch User Repository:   
https://aur.archlinux.org/packages/linux-rt/  
You get the wget link by copy the link 'Download snapshot'.  
If the package is no longer available in AUR, take a look into the archive.  
https://github.com/aur-archive  
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

repo-add Options  
-d, --delta  
    Automatically generate and add a delta file between the old entry and the new one, if the old package file is found next to the new one.  
-n, --new  
    Only add packages that are not already in the database. Warnings will be printed upon detection of existing packages, but they will not be re-added.  
-R, --remove  
    Remove old package files from the disk when updating their entry in the database.  
 

-----------------------------------------------------------------------------------  
(* 3) Script messages:  

warning: kpathsea: configuration file texmf.cnf not found in these directories: /usr/bin:/usr/bin/share/texmf-local/web2c:/usr/bin/share/texmf-dist/web2c:/usr/bin/share/texmf/web2c:/usr/bin/texmf-local/web2c:/usr/bin/texmf-dist/web2c:/usr/bin/texmf/web2c:/usr:/usr/share/texmf-local/web2c:/usr/share/texmf-dist/web2c:/usr/share/texmf/web2c:/usr/texmf-local/web2c:/usr/texmf-dist/web2c:/usr/texmf/web2c://texmf-local/web2c:/://share/texmf-local/web2c://share/texmf-dist/web2c://share/texmf/web2c://texmf-local/web2c://texmf-dist/web2c://texmf/web2c.
Optional dependencies for texlive-bin  
    ed: for texconfig  


java7-headless provide no HOME, java-common does  

--------------------------------------------------------------------------------------

(* 4) 

nvidia-340xx-rt legacy test. For use it with other graphic cards it is recommend to delete the section from 
../airootfs/root/customize_airootfs.sh (line 109 - 123)  

To use the proprietary nvidia-340xx-rt and prevent nouveau to start, use TAB to add nomodeset (or try modeset=0) to the kernel boot line, 
otherwise the system will use the nouveau driver.  
  
nvidia: module license 'NVIDIA' taints kernel.  
Disabling lock debugging due to kernel taint  
vgaarb: device changed decodes: PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem  
[drm] Initialized nvidia-drm 0.0.0 20150116 for 0000:01:00.0 on minor 0  
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  340.96  Sun Nov  8 22:33:28 PST 2015  



    % lspci -nnk | grep -i vga -A3     
    01:00.0 VGA compatible controller [0300]: NVIDIA Corporation GT218M [GeForce G210M] [10de:0a74] (rev a2)  
        Subsystem: Lenovo Device [17aa:389f]  
        Kernel driver in use: nvidia  
        Kernel modules: nouveau, nvidia  


    % sudo nvidia-xconfig  

    WARNING: Unable to locate/open X configuration file.  

    New X configuration file written to  
    '/etc/X11/xorg.conf'  


####It is an inferior qualtity to the nouveau driver configuration. A lot of XRUNs.  
This configuration is better, less XRUNs. Need to compare with nouveau. See RT-Test section for further information.  




Possible Soultion:  
* downgrade xorg-server to ??? (current: 1.18.3-1)   

"The Linux 340.* legacy driver series is the last to support the G8x, G9x, and GT2xx GPUs, and motherboard chipsets based on them. 
Support for new Linux kernels and X servers, as well as fixes for critical bugs, will be included in 340.* legacy 
releases through the end of 2019."  
http://nvidia.custhelp.com/app/answers/detail/a_id/3142/  



-----------------------------------end appendix---------------------------------------




## Useful information and applications around archiso ##

* Tools to remaster ArchLinux live ISO snapshots. Can generate a 32-bit EFI loader image.   
https://github.com/HOMEINFO/archiso-tools


## Useful information and applications around (Arch) Linux audio ##

* Linux Hardware Support  
http://wiki.linuxaudio.org/wiki/hardware_support

* Arch Linux list of applications/Multimedia  
https://wiki.archlinux.org/index.php/List_of_applications/Multimedia


## Accessories ##  

* Drum machine presets (hydrogen drum machine/w addon apt pkg drumsets):    
https://github.com/ToxicLeech/HydrogenTracks


* FAUST code:    
https://github.com/magnetophon




