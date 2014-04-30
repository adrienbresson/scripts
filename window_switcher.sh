#!/bin/bash


current_worspace=$(wmctrl -d |awk '{print $1" "$2}'  |grep -F '*' |awk '{print $1}')

wmctrl -l |grep -E "^[[:xdigit:]]+x[[:xdigit:]]+( )+${current_worspace}" |cut -d' ' -f 1,5- |dmenu -l 10 |cut -d' ' -f 1 |xargs wmctrl -i -a
