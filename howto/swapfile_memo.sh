#!/bin/bash

## How to create a swap file
## 1 Gb SwapFile (1024*1024)

dd if=/dev/zero of=/swapfile bs=1024 count=1048576

#dd if=/dev/zero of=/mnt/data/swapfile bs=1024 count=4194304
#4194304+0 records in
#4194304+0 records out
#4294967296 bytes (4.3 GB) copied, 56.839 s, 75.6 MB/s


mkswap /swapfile
chown root:root /swapfile
chmod 0600 /swapfile
swapon /swapfile
vi /etc/fstab
/swapfile swap swap defaults 0 0

free -m
#             total       used       free     shared    buffers     cached
#Mem:          1752       1702         49          0         16        964
#-/+ buffers/cache:        721       1030
#Swap:         4095          0       4095
