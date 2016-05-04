#!/bin/bash

echo "hello, world"

#autostart jack with cadence 
#cadence-session-start --system-start

# guitarix webui
#python2 guitarix-webui-0.28.3/websockify/websocketproxy.py -D --web=../webui '*':8000 localhost:7000
#(you can use the -D options to start the program in the background)
#- start guitarix with --rpcport=7000
#- open "http://localhost:8000/" in your browser
#The included server is not audited for security; don't use it in an
#untrusted environment.


# guitarix specmatch
#sudo python2 scikits.audiolab-0.11.0/setup.py install
#sudo specmatch/./setup.py install --prefix=/usr --record files.txt
# call specmatch in a terminal to launch it