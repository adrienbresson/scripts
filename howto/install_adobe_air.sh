
## Date: 20120923
## Author: Adrien 
## Description: Install script : Adobe Air on Ubuntu 12.04 x64
##               I think Adobe Air is no more maintained for linux, So it's a little bit tricky to install
## References:  http://jeffhendricks.net/?p=68

sudo apt-get install libhal-storage1 libgnome-keyring0 lib32nss-mdns
wget http://airdownload.adobe.com/air/lin/download/2.6/AdobeAIRInstaller.bin
wget http://jeffhendricks.net/getlibs-all.deb


sudo getlibs -l libhal-storage.so.1
sudo getlibs -l libgnome-keyring.so.0.1.1

sudo ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0 /usr/lib/libgnome-keyring.so.0

chmod +x ./AdobeAIRInstaller.bin
sudo ./AdobeAIRInstaller.bin


# Menu > accessories > Adobe air installer
