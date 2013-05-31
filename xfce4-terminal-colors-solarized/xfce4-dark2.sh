#!/bin/bash

#export XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/dark/
#echo $XDG_CONFIG_HOME

#xfce4-terminal --disable-server
#XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/light/ xfce4-terminal --disable-server --hide-menubar --title=local

if [[ -n $1 ]];then
   title=$(echo $1 | tr '[:lower:]' '[:upper:]')
   XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/dark/ xfce4-terminal --disable-server --hide-menubar --title=$title -e "ssh ab@$1"
else
   XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/dark/ xfce4-terminal --disable-server --hide-menubar --title=PROD
fi

