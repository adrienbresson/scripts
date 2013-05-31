#!/bin/bash

#export XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/dark/
#echo $XDG_CONFIG_HOME

case $1 in
  dark) 
    TERMINAL="$HOME/xfce4-terminal-colors-solarized/dark/"
    AGRS="xfce4-terminal --disable-server --hide-menubar --title=PROD"
    ;;
  light) 
    TERMINAL="$HOME/xfce4-terminal-colors-solarized/light/" 
    ARGS="xfce4-terminal --disable-server --hide-menubar --title=local"
    ;;
  *) 
    TERMINAL="$HOME/.config/Terminal/" 
    ARGS="xfce4-terminal --disable-server --hide-menubar"
esac

if [[ -n $2 ]];then
   title=$(echo $2 | tr '[:lower:]' '[:upper:]')
   XDG_CONFIG_HOME=$TERMINAL --disable-server --hide-menubar --title=$title -e "ssh ab@$1"
else
   XDG_CONFIG_HOME=$TERMINAL $ARGS
fi

