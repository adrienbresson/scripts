#!/bin/bash

TMP=/tmp/active_window.txt

## Active window co-ords
# xwininfo -id $(xdotool getactivewindow)

[[ $1 =~ [0-9]+ ]] && active_window_id=${1} || active_window_id=$(xdotool getactivewindow)


active_window_up_left_x=$(xwininfo -id ${active_window_id} |grep 'Absolute upper-left X' |awk -F':' '{print $2}' |sed 's/ //g')
active_window_up_left_y=$(xwininfo -id ${active_window_id} |grep 'Absolute upper-left Y' |awk -F':' '{print $2}' |sed 's/ //g')
active_window_up_width=$(xwininfo -id ${active_window_id} |grep 'Width:' |awk -F':' '{print $2}' |sed 's/ //g')
active_window_up_height=$(xwininfo -id ${active_window_id} |grep 'Height:' |awk -F':' '{print $2}' |sed 's/ //g')
let active_window_middle_x=${active_window_up_left_x}+${active_window_up_width}/2
let active_window_middle_y=${active_window_up_left_y}+${active_window_up_height}/2

#echo "active_window_id: ${active_window_id}"
#echo "active_window_up_left_x: ${active_window_id}"
#echo "active_window_up_left_y: ${active_window_up_left_y}"
#echo "active_window_up_width: ${active_window_up_width}"
#echo "active_window_up_height: ${active_window_up_height}"
#echo "active_window_middle_x: ${active_window_middle_x}"
#echo "active_window_middle_y: ${active_window_middle_y}"

[[ $1 == 'export' || $1 =~ [0-9]+ ]] && echo -e "ACTIVE_WIN_MID_X:${active_window_middle_x}\nACTIVE_WIN_MID_Y:${active_window_middle_y}" > ${TMP}

## Move mouse
# xdotool mousemove 500 804

if [[ $1 == 'import' || $1 =~ [0-9]+ ]]; then
    active_window_middle_x=$(cat ${TMP} |grep 'ACTIVE_WIN_MID_X' |awk -F':' '{print $2}')
    active_window_middle_y=$(cat ${TMP} |grep 'ACTIVE_WIN_MID_Y' |awk -F':' '{print $2}')
    xdotool mousemove ${active_window_middle_x} ${active_window_middle_y}
    [ -n ${active_window_id} ] &&  xdotool windowraise ${active_window_id}
fi
