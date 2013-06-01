#!/bin/bash

# Date : 20130209
# Author : Adrien
# Version : 0.1 buggy
# Description : This scipt is used to open gmail in a popup window and bring it on click on the diffrent workspaces (used with xfce4 mail watcher)

# if start new process save window ID into text file (or export as environement variable)
# and use it to retrive the window. So if the window title change it will not bother me

#LOCK
if [[ $(ps aux |grep -F $0 |grep -v grep |wc -l) -gt 2 ]];then
    echo "- $(ps aux |grep -F $0 |grep -v grep) -"
    exit
fi 

IDFILE='/tmp/gmail_window_id'
if [[ -e $IDFILE && -n $(cat $IDFILE) && $(wmctrl -l |grep "$(cat $IDFILE)" |wc -l) -eq 1 ]];then
   id=$(cat $IDFILE | head -n1)
   TITLE="$(wmctrl -l |grep $id |cut -d' ' -f5-)"
   #echo "a ${TITLE}" 
   process_count=$(wmctrl -l |grep -F "$(cat $IDFILE)" |wc -l)
   REALTILE=$(wmctrl -l |grep -Fo "$TITLE")
else 
   TITLE='Inbo[x][ ()0-9]*- bresson.adrien@gmail.com - Gmail$'
   #echo "b $TITLE" 
   process_count=$(wmctrl -l |grep -E "$TITLE" |wc -l)
   REALTILE=$(wmctrl -l |grep -Eio "$TITLE")
fi
#RUN='google-chrome -app=http://www.gmail.com/ --user-data-dir=~/.config/google-chrome/Default/ &'
RUN='chromium-browser -app=http://www.gmail.com/ --user-data-dir=/home/ab/.config/google-chrome/Default/ &'

#echo $process_count
if [[ $process_count -lt 1 ]];then
   #Start a new process
   #google-chrome -app=http://www.gmail.com/ --user-data-dir=~/.config/google-chrome/Default/ &
   $RUN
   sleep 10
   WINDOWID=$(wmctrl -l | grep "$TITLE" |awk '{print $1}')
   echo $WINDOWID > $IDFILE
elif [[ $process_count -eq 1 ]]; then
   #Bring existing window to current workpace
   ACTIVEWORKSPACEID=$(wmctrl -d |grep -E '^[0-9]( )+\*' |awk '{print $1}')
   if [[ -e $IDFILE && -n $(cat $IDFILE) ]]; then
       WINDOWID=$(cat $IDFILE)
       #echo "c $WINDOWID"
   else
       WINDOWID=$(wmctrl -l | grep "$TITLE" |awk '{print $1}')
       #echo $WINDOWID > $IDFILE
       echo "WARNING"
   fi
   wmctrl -i -R $WINDOWID -t $ACTIVEWORKSPACEID
   #Raise the window
   wmctrl -a "$REALTILE"   
else
    #TODO Something wrong, kill exceded windows
    echo 'somethine wrong'
fi

