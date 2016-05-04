#!/bin/bash

set -e -u


## Spracheinstellungen
echo "LANG=de_DE.UTF-8" > /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf

## Tastaturbelegung festlegen ##
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

## Systemsprache generieren ##
#sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
sed -i 's/#\(de_DE\.UTF-8\)/\1/' /etc/locale.gen
#echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
#echo "de_DE ISO-8859-1" >> /etc/locale.gen
#echo "de_DE@euro ISO-8859-15 >> /etc/locale.gen
#echo "locale-gen"

# Timezone
# ln -sf /usr/share/zoneinfo/UTC /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

## Hostname ###
echo "BazzArch" > /etc/hostname

#usermod -s /usr/bin/zsh root
#cp -aT /etc/skel/ /root/
#chmod 700 /root

# Create live session user and add him to groups
## group adbusers does not exist???
if [ ! -d /home/live-user ]; then
    useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,video,power,wheel,users,sys,network,lp" -s /usr/bin/zsh live-user 
fi

## assign a password 
# passwd live-user

## Adding live-user to sudoer without password
echo "live-user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

### WLAN (
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


