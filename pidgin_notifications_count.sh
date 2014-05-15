#!/bin/bash

## Description: Message Notification plugin for Pidgin allow to return the count of unread messages into the window X property
##              This script is written to display this value (_PIDGIN_UNSEEN_COUNT)

PROCESS_NAME='pidgin'
XPROPERTY='_PIDGIN_UNSEEN_COUNT'

pid=$(ps aux |grep -E "${PROCESS_NAME}\$" |awk '{print $2}')
winids=$(wmctrl -l -p |grep " ${pid} " |awk '{print $1}')

for winid in $winids; do
   unread_messages=$(xprop -id ${winid} |grep "${XPROPERTY}")
   if [[ -n ${unread_messages} ]]; then
      echo ${unread_messages} |awk -F'=' '{print $2}' |tr -d ' '
   fi
done
