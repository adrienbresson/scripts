#!/bin/bash

## Internet connection on free optical fiber without freebox
## Create a vlan on dd-wrt router restart, this provede vlan for internet, I should add a TV vlan
## This script is to be put in /jffs/
## It must be used with switch-robot.ko (also in /jffs/)

vlan=$(ls /proc/switch/eth0/vlan/ | grep -c 836)
#echo "vlan: $vlan"
if [ ! $vlan -eq 1 ]; then
	#echo "switch-robo mod"
	rmmod switch-robo
	sleep 1
	insmod /jffs/switch-robo.ko
	sleep 1
fi


echo "" > /proc/switch/eth0/vlan/2/ports
echo "0t 8" > /proc/switch/eth0/vlan/836/ports       

line=$(ifconfig -a | grep -c 836)
if [ ! $line -eq 1 ]; then  
	#echo "add vlan 836"
	vconfig add eth0 836 
fi


eth=$(ifconfig -a | grep 836 | awk '{ print $1 }')

ifconfig $eth up
nvram set wan_ifname=$eth

startservice wan

exit 0
