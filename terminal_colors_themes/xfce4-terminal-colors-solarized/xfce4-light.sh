#!/bin/bash

MYUSER=${USER}
SERVER=${1}

#export XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/dark/
#echo $XDG_CONFIG_HOME

#xfce4-terminal --disable-server
#XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/light/ xfce4-terminal --disable-server --hide-menubar --title=local

if [[ -n ${SERVER} ]];then
   title=$(echo ${SERVER} | tr '[:lower:]' '[:upper:]')
   XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/light/ xfce4-terminal --disable-server --hide-menubar --title=$title -e "ssh ${MYUSER}@${SERVER}"
else
   XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/light/ xfce4-terminal --disable-server --hide-menubar --title=local
fi

