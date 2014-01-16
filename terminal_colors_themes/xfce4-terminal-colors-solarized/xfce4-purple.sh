#!/bin/bash

if [[ ${1} =~ .+@.+ ]]; then
    MYUSER=$(echo "${1}" |awk -F'@' '{print $1}')
    SERVER=$(echo "${1}" |awk -F'@' '{print $2}')
else
    MYUSER=${USER}
    SERVER=${1}
fi
SOLARIZED="${HOME}/GitHub/adrien.bresson/scripts/terminal_colors_themes/xfce4-terminal-colors-solarized"
COLOR='purple'
ALTERNATIVE_TITLE='LAN'

if [[ -n ${SERVER} ]];then
   title=$(echo ${SERVER} | tr '[:lower:]' '[:upper:]')
   XDG_CONFIG_HOME=$SOLARIZED/${COLOR}/ xfce4-terminal --disable-server --hide-menubar --title=$title -e "ssh ${MYUSER}@${SERVER}"
else
   XDG_CONFIG_HOME=$SOLARIZED/${COLOR}/ xfce4-terminal --disable-server --hide-menubar --title=${ALTERNATIVE_TITLE}
fi


