#!/bin/bash

cd /home/live-user/guitarix/scikits.audiolab-0.11.0/
sudo python2 setup.py install
cd /home/live-user/guitarix/specmatch/
sudo ./setup.py install --prefix=/usr --record files.txt
# call specmatch from the console, from the startmenue or the guitarix-specmatch script on the desktop 
# to launch guitarix with it.