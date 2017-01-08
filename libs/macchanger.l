#!/bin/bash

###########################################################################################
# Last update version 1.05								  #
# Authors: Carlos Antonini & Vicente Motos						  #
# Description: this lib contains functions of change mac				  #
# 											  #
###########################################################################################

function changeMAC () {
	echo -e "\n\n${GREEN}[+]${NC} Changing MAC Address ...\n"
	ifconfig $(ls /sys/class/net/ | grep -E '^eth|^en|^wl' | head -1) down && sleep 5
	macchanger -r $(ls /sys/class/net/ | grep -E '^eth|^en|^wl' | head -1)
	ifconfig $(ls /sys/class/net/ | grep -E '^eth|^en|^wl' | head -1) up && sleep 5
	echo -e "\n"
}
