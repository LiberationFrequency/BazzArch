#!/bin/bash

# This script start guitarix with webui automatically. Browse to http://localhost:8000 .

# start avahi service, if it is not configured
#sudo systemctl start avahi-daemon.service &&
python2 ../guitarix/guitarix-webui-0.28.3/websockify/websocketproxy.py -D --web=../guitarix/guitarix-webui-0.28.3/webui '*':8000 localhost:7000 && guitarix --rpcport=7000
