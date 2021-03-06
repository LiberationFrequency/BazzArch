#!/bin/bash

set -e -u

# System language

## English
##echo "LANG=en_US.UTF-8" > /etc/locale.conf
####echo "LANGUAGE=en_US.UTF-8:en_US.UTF-8" >> /etc/locale.conf
##echo "LC_COLLATE=C" >> /etc/locale.conf
##echo "LC_ALL=C" >> /etc/locale.conf
##sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
## en_US.UTF-8 UTF-8
## en_US ISO-8859-1


## German with fallback to en_US for applications with missing translation 
echo "LANG=de_DE.UTF-8" > /etc/locale.conf
echo "LANGUAGE=de_DE.UTF-8:en_US.UTF-8" >> /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf
echo "LC_ALL=C" >> /etc/locale.conf
sed -i 's/#\(de_DE\.UTF-8\)/\1/' /etc/locale.gen
##de_DE ISO-8859-1
##de_DE@euro ISO-8859-15

locale-gen 


# Keymap for terminal
## German
###echo "KEYMAP=de-latin1" > /etc/vconsole.conf
echo "KEYMAP=de-latin1-nodeadkeys" > /etc/vconsole.conf

# Timezone
## ln -sf /usr/share/zoneinfo/UTC /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

# Hostname 
echo "BazzArch" > /etc/hostname

# Create root user
##usermod -s /usr/bin/zsh root
##cp -aT /etc/skel/ /root/
##chmod 700 /root

# Create live session user and add him to groups
if [ ! -d /home/live-user ]; then
    useradd -m -p "" -g users -G "adm,audio,floppy,log,lp,network,optical,power,rfkill,scanner,storage,sys,users,video,wheel" -s /usr/bin/zsh live-user 
fi

# Assign a password 
## passwd live-user

# If the mtpfs/gvfs-mtp is installed
gpasswd -a live-user uucp


# If the ADB is installed
gpasswd -a live-user adbusers


# If Wireshark is installed
##gpasswd -a live-user wireshark
#########################################################
#DO NOT USE THIS IN A SCRIPT, you will run into trouble.#
#Use root privilege for dumping provisional!	       	#
#-------------------------------------------------------#
###################getcap /usr/bin/dumpcap		#
#########################################################

# Make live-user a sudoer
##echo "live-user ALL=(ALL) ALL" >> /etc/sudoers

# Adding live-user to sudoers without password request
echo "live-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# WLAN (enter the essid and pwd you want connect to)
##echo "rfkill unblock all"
wpa_passphrase essid password > /etc/wpa_supplicant/wpatest.conf


# Proof of concept of the dialog "Open Terminal here" in LXQT, see also airootfs/etc/skel/.config/lxqt/session.conf
ln -sf /usr/bin/qterminal /usr/bin/xterm

# Fix "A stop job is running for ..." 
##ln -sf /dev/null /etc/sysctl.d/50-coredump.conf


# Copy files over to home
su -c "cp -r /etc/skel/.* /home/live-user/" live-user


sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf


# Disable modules
#echo "blacklist b43" >> /etc/modprobe.d/blacklist.conf
echo "blacklist b43legacy" >> /etc/modprobe.d/blacklist.conf
echo "blacklist pcspkr" >> /etc/modprobe.d/blacklist.conf



## Disable nouveau driver to install NVIDIA drivers #####################
#echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf		#	
#echo "options nouveau nomodeset" >> /etc/modprobe.d/modprobe.conf	#
#########################################################################
#    replace_line() { #{{{
#    local _search=${1}
#    local _replace=${2}
#    local _filepath=${3}
#  #}}}
#}
##replace_line '*options nouveau modeset=1' '#options nouveau modeset=1' /etc/modprobe.d/modprobe.conf
#replace_line '*MODULES="nouveau"' '#MODULES="nouveau"' /etc/mkinitcpio.conf
#mkinitcpio -p linux-rt
#nvidia-xconfig --add-argb-glx-visuals --allow-glx-with-composite --composite -no-logo --render-accel -o /etc/X11/xorg.conf.d/20-nvidia.conf;










# Enable services at startup
systemctl enable pacman-init.service choose-mirror.service
systemctl enable rtirq.service 

## Disabled for the benefit of qjackctl config
#systemctl enable optimize-rt-performance.service
## 
systemctl enable optimize-rt-blankscreen.service
## Disabled by default, activate it, if you have trouble with older graphic cards
#systemctl enable optimize-rt-resetgraphic.service

systemctl enable avahi-daemon.service
systemctl enable org.cups.cupsd.service
systemctl enable cups-browsed.service

systemctl enable connman.service
systemctl enable timidity.service
systemctl enable optimize-rt-interrupfreq.service

systemctl set-default multi-user.target




##Deprecated####
### Brother MFC-7360N ### 
## Zur Erklärung: Wenn man Module mittels der Blacklist am Starten hindert, aber ein anderes 
## Modul dieses Modul als Abhängigkeit aufruft, wird das geblacklistete Modul trotzdem geladen. 
## Es ist hier aber wichtig, dass es nicht geladen wird, sonst wird der Drucker über eine falsche 
## Hardware-Adresse angesprochen. Deshalb verwendet man install usblp /bin/false.
#echo "install usblp /bin/false" >> /etc/modprobe.d/blacklist.conf


