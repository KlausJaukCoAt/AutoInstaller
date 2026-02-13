#!/bin/bash
# With this Script you can create a new VM for Windows 2025 Server on Proxmox PVE.
# Tested on PVE 8.0.3 with Windows 2025 Server Evaluation 24H2 Build 26100.32230
# Get automatic the next available VM ID
vmid=`pvesh get /cluster/nextid`
prefix="PVE"
serial=${prefix}$(openssl rand -hex 6)
uuid=`cat /proc/sys/kernel/random/uuid`
# Memory
memory=8192
# VM Name
read -p "VM Name:" name
# OSType
ostype=win11
# CPU Cores
cores=4

# Create VM
qm create $vmid \
  --name $name \
  --memory $memory \
  --cores $cores \
  --cpu host \
  --machine q35 \
  --bios ovmf \
  --efidisk0 nvme:1 \
  --tpmstate0 nvme:1,version=v2.0 \
  --scsihw virtio-scsi-single \
  --scsi0 nvme:64 \
  --net0 virtio,bridge=vmbr0,firewall=1 \
  --ostype $ostype

# Set Tags
qm set $vmid --tags 'Windows, Windows2025Server'

# Mount Image and Driver
qm set $vmid --sata0 nvme-iso:iso/Windows_2025_SERVER_EVAL_x64FRE_de-de.iso,media=cdrom
qm set $vmid --sata1 nvme-iso:iso/W2K25_Autoinstall.iso,media=cdrom

# Mounted as F: in the VM, contains the VirtIO Drivers for Windows 2025 Server
qm set $vmid --sata2 nvme-iso:iso/virtio-win.iso,media=cdrom

#Set Bootorder
qm set $vmid --boot order='sata0;scsi0;sata1;sata2'

# Set Bios Serialnumber
qm set $vmid --smbios1 uuid="$uuid",serial="$serial",product="$name",family="Virtuell",manufacturer="ProxmoxVE"

# Enable the next line to start the VM after creation
qm start $vmid

# Change Bootorder for next start and unmount disks
qm set $vmid --boot order='scsi0'
