#!/bin/bash


current_worspace=$(wmctrl -d |awk '{print $1" "$2}'  |grep -F '*' |awk '{print $1}')

if [[ $1 == 'all' ]]; then 
     wmctrl -l |sort -k4 |sort -k2 |awk '{printf "%s %s ", $2,$1;s = ""; for (i = 4; i <= NF; i++) s = s $i " ";print s }' |grep -E '^[1-9]' |dmenu -l 20 |cut -d' ' -f 2 |xargs wmctrl -i -a
     exit 0
fi


wmctrl -l |grep -E "^[[:xdigit:]]+x[[:xdigit:]]+( )+${current_worspace}" |cut -d' ' -f 1,5- |dmenu -l 10 |cut -d' ' -f 1 |xargs wmctrl -i -a
