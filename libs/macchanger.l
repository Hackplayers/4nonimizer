#!/bin/bash

function changeMAC () {
	echo -e "\n\n${GREEN}[+]${NC} Changing MAC Address ...\n"
	ifconfig $(ls /sys/class/net/ | grep -E '^eth|^en|^wl' | head -1) down && sleep 5
	macchanger -r $(ls /sys/class/net/ | grep -E '^eth|^en|^wl' | head -1)
	ifconfig $(ls /sys/class/net/ | grep -E '^eth|^en|^wl' | head -1) up && sleep 5
	echo -e "\n"
}
