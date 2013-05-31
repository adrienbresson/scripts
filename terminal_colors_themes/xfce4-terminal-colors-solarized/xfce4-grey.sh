#!/bin/bash

MYUSER=${USER}

if [[ -n $1 ]];then
   title=$(echo $1 | tr '[:lower:]' '[:upper:]')
   XDG_CONFIG_DIRS=$HOME/xfce4-terminal-colors-solarized/grey/ xfce4-terminal --disable-server --hide-menubar --title=$title -e "ssh ${MYUSER}@$1"
else
   XDG_CONFIG_DIRS=$HOME/xfce4-terminal-colors-solarized/grey/ xfce4-terminal --disable-server --hide-menubar
fi


