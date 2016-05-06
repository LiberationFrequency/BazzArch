#!/bin/bash

sudo ip link set wlan0 up && sudo wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpatest.conf && sudo dhcpcd wlan0
