#!/bin/bash

set -e -u

## Keymap for terminal
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

# System language
## German and fallback to en_US for applications with missing translation 
echo "LANG=de_DE.UTF-8" > /etc/locale.conf
echo "LANGUAGE=de_DE.UTF-8:en_US.UTF-8" >> /etc/locale.conf
echo "LC_TIME=de_DE.UTF-8" >> /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf
echo "LC_ALL=de_DE.UTF-8" >> /etc/locale.conf
echo "LC_ADDRESS=de_DE.UTF-8" >> /etc/locale.conf
echo "LC_CTYPE=de_DE.UTF-8" >> /etc/locale.conf
echo "LC_NUMERIC=de_DE.UTF-8" >> /etc/locale.conf
echo "LC_MONETARY=de_DE.UTF-8" >> /etc/locale.conf
##LC_MESSAGES="de_DE.UTF-8"
##LC_PAPER="de_DE.UTF-8"
##LC_NAME="de_DE.UTF-8"
##LC_TELEPHONE="de_DE.UTF-8"
##LC_MEASUREMENT="de_DE.UTF-8"
##LC_IDENTIFICATION="de_DE.UTF-8"
locale-gen 


## Timezone
# ln -sf /usr/share/zoneinfo/UTC /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

## Hostname 
echo "BazzArch" > /etc/hostname

## Create root user
#usermod -s /usr/bin/zsh root
#cp -aT /etc/skel/ /root/
#chmod 700 /root

## Create live session user and add him to groups
### group adbusers, vmusers, wireshark
if [ ! -d /home/live-user ]; then
    useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,video,power,wheel,users,sys,network,lp" -s /usr/bin/zsh live-user 
fi

# Assign a password 
## passwd live-user


## If the ADB is installed
gpasswd -a live-user adbusers

#### If VM is installed
###gpasswd -a live-user vmusers

## If Wireshark is installed
#gpasswd -a live-user wireshark
#########################################################
#DO NOT USE THIS IN A SCRIPT, you will run into trouble.#
#Use root privilege for dumping provisional!	       	#
#-------------------------------------------------------#
###################getcap /usr/bin/dumpcap		#
#########################################################


## Adding live-user to sudoers without password request
echo "live-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

### WLAN (enter the essid and pwd you want connect to)
####echo "rfkill unblock all"
wpa_passphrase essid password > /etc/wpa_supplicant/wpatest.conf

# Copy files over to home
su -c "cp -r /etc/skel/.* /home/live-user/" live-user


sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

## Enable services at startup
systemctl enable pacman-init.service choose-mirror.service
systemctl enable rtirq.service 
systemctl enable optimize-rt-system.service
#systemctl enable cups
systemctl enable avahi-daemon.service
systemctl set-default multi-user.target


#echo "blacklist b43" >> /etc/modprobe.d/blacklist.conf
echo "blacklist b43legacy" >> /etc/modprobe.d/blacklist.conf
echo "blacklist pcspkr" >> /etc/modprobe.d/blacklist.conf


### Brother MFC-7360N ### 
## Zur Erklärung: Wenn man Module mittels der Blacklist am Starten hindert, aber ein anderes 
## Modul dieses Modul als Abhängigkeit aufruft, wird das geblacklistete Modul trotzdem geladen. 
## Es ist hier aber wichtig, dass es nicht geladen wird, sonst wird der Drucker über eine falsche 
## Hardware-Adresse angesprochen. Deshalb verwendet man install usblp /bin/false.
#echo "install usblp /bin/false" >> /etc/modprobe.d/blacklist.conf


