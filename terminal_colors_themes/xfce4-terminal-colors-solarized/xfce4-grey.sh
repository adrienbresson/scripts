#!/bin/bash

MYUSER=${USER}
SERVER=${1}
SOLARIZED="${HOME}/GitHub/adrien.bresson/scripts/terminal_colors_themes/xfce4-terminal-colors-solarized"
COLOR='grey'
ALTERNATIVE_TITLE='intranet'

if [[ -n ${SERVER} ]];then
   title=$(echo ${SERVER} | tr '[:lower:]' '[:upper:]')
   XDG_CONFIG_HOME=$SOLARIZED/${COLOR}/ xfce4-terminal --disable-server --hide-menubar --title=$title -e "ssh ${MYUSER}@${SERVER}"
else
   XDG_CONFIG_HOME=$SOLARIZED/${COLOR}/ xfce4-terminal --disable-server --hide-menubar --title=${ALTERNATIVE_TITLE}
fi


