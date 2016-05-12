#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# exec gnome-session
# exec startkde
#exec startxfce4
#exec dbus-launch startxfce4
#exec startlxde
exec startlxqt
# ...or the Window Manager of your choice

# Virtual Box (not with linux-rt)
#/usr/bin/VBoxClient-all