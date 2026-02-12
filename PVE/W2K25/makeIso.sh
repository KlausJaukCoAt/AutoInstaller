#!/bin/bash
#
# Script can be run directly on Proxmox PVE Enviroment
# Copy autounattend.xml to iso/ folder and create W2K25_Autoinstall.iso 
# with makeIso.sh script
genisoimage -allow-limited-size -udf -o W2K25_Autoinstall.iso iso/
# Copy the ISO File to the Proxmox ISO Storage 
# example: cp W2K25_Autoinstall.iso /var/lib/vz/iso/
