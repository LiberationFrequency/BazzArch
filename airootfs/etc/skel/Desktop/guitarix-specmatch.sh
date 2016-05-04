#!/bin/bash

# This script starts guitarix with specmatch automatically. 

# start avahi service, if it is not configured
#sudo systemctl start avahi-daemon.service &&
specmatch
