#!/bin/bash

# Version : 0.1
# Description : I use this script to generate connection scripts to servers. 
#               The directory containing all the connections script will be used in a XFCE4 panel launcher
#               This will give me a drop down list to easily connect to my servers


# This is the directory where all the generated sh will be located
MENU="$HOME/menu_list"
mkdir -p $MENU

# The default terminal path 
RUN='/home/ab/xfce4-terminal-colors-solarized/xfce4-light.sh'

# A server list you should put your own list of servers
SERVERS='server1.domain.local
server2.example.local
server3.domain.local'

# The launcher path
LAUNCHER="${HOME}.config/xfce4/panel/launcher-11"

# The element id I use to begin
current='136188757119'

# Clean existing 
rm -f ${LAUNCHER}/*.desktop

#Icon=/home/ab/Images/gnome-terminal-blue.png

IFS=$'\n'
for s in $SERVER; do
    let current=current+1
    if [[ -n $(echo $s |grep -E '.example.local$') ]];then
        RUN='/home/ab/xfce4-terminal-colors-solarized/xfce4-dark.sh'
    elif [[ -n $(echo $s | grep -E '.domain.local$') ]];then
        RUN='/home/ab/xfce4-terminal-colors-solarized/xfce4-default.sh'
    fi
    echo -e "#!/bin/bash\n$RUN $s" > $MENU/$s
    chmod +x $MENU/$s
    echo "[Desktop Entry]
Version=1.0
Type=Application
Name=${s}
Comment=
Exec=/home/ab/menu/${s}
Icon=
Path=
Terminal=false
StartupNotify=false" > ${LAUNCHER}/${current}.desktop
done 
