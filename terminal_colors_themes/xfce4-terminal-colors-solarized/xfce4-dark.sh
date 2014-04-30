#!/bin/bash

if [[ ${1} =~ .+@.+ ]]; then
    MYUSER=$(echo "${1}" |awk -F'@' '{print $1}')
    SERVER=$(echo "${1}" |awk -F'@' '{print $2}')
else
    MYUSER=${USER}
    SERVER=${1}
fi
#TITLE=${3}
SOLARIZED="${HOME}/GitHub/adrien.bresson/scripts/terminal_colors_themes/xfce4-terminal-colors-solarized"
COLOR='dark'
ALTERNATIVE_TILE='SERVER'

PUBLIC_KEY="${HOME}/.ssh/id_rsa.pub"
function install_public_key {
    ssh_connection_test="ssh -o PreferredAuthentications=publickey -o PasswordAuthentication=no -o PubkeyAuthentication=yes ${MYUSER}@${SERVER} echo ''"
    if ! eval $ssh_connection_test ;then
        echo "Failed to login using public key (ssh-copy-id will install your public key on the server)"
        ssh-copy-id -i ${PUBLIC_KEY} ${MYUSER}@${SERVER}
    fi
}

install_public_key


#export XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/dark/
#echo $XDG_CONFIG_HOME

#xfce4-terminal --disable-server
#XDG_CONFIG_HOME=$HOME/xfce4-terminal-colors-solarized/light/ xfce4-terminal --disable-server --hide-menubar --title=local

if [[ -n ${SERVER} ]];then
   title=$(echo ${SERVER} | tr '[:lower:]' '[:upper:]')
   XDG_CONFIG_HOME=$SOLARIZED/$COLOR/ xfce4-terminal --disable-server --hide-menubar --title=${title} -e "ssh -A ${MYUSER}@${SERVER}"
else
   XDG_CONFIG_HOME=$SOLARIZED/$COLOR/ xfce4-terminal --disable-server --hide-menubar --title=${ALTERNATIVE_TILE}
fi

