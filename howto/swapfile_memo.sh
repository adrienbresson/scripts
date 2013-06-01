#!/bin/bash

## How to create a swap file
## 1 Gb SwapFile (1024*1024)

dd if=/dev/zero of=/swapfile bs=1024 count=1048576
mkswap /swapfile
chown root:root /swapfile
chmod 0600 /swapfile
swapon /swapfile
vi /etc/fstab
/swapfile swap swap defaults 0 0