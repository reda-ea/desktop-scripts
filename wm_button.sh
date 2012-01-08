#! /bin/bash

#does an action on the current window

#get current window
#WIN=`xprop -root | grep _NET_ACTIVE_WINDOW\(WINDOW\) | sed "s/.*# //"`

#viewport data
VPWID=`xwininfo -root | grep geometry | sed "s/[^0-9]*\([0-9]*\)x\([0-9]*\)+0+0/\1/"`
VPHGT=`xwininfo -root | grep geometry | sed "s/[^0-9]*\([0-9]*\)x\([0-9]*\)+0+0/\2/"`

#get topmost maximized window
xprop -root _NET_CLIENT_LIST_STACKING |
  sed "s/.*# //" | sed s"/, /\n/g" | tac | 
  while read w; do
	#window is maximized
	xprop -id $w | grep _NET_WM_STATE_MAXIMIZED_VERT > /dev/null || continue
	#window positions relative to current viewport
	WINX=`xwininfo -id $w | grep "Absolute upper-left X" | sed "s/.*:[^0-9]*//"`
	WINY=`xwininfo -id $w | grep "Absolute upper-left Y" | sed "s/.*:[^0-9]*//"`
	WINW=`xwininfo -id $w | grep "Width" | sed "s/.*:[^0-9]*//"`
        WINH=`xwininfo -id $w | grep "Height" | sed "s/.*:[^0-9]*//"`
	[[ $(($WINX+($WINW/2))) -gt 0 ]] || continue
	[[ $(($WINX+($WINW/2))) -lt $VPWID ]] || continue
	[[ $(($WINY+($WINH/2))) -gt 0 ]] || continue
	[[ $(($WINY+($WINH/2))) -lt $VPHGT ]] || continue
	#topmost maximized window found
	echo $w
	case "$1" in
		"close" ) wmctrl -ic $w ;;
		"min"   ) wmctrl -ir $w -b add,hidden ;; #FIXME
		"max"   ) wmctrl -ir $w -b toggle,maximized_vert,maximized_horz ;;
		"unmax" ) wmctrl -ir $w -b remove,maximized_vert,maximized_horz ;;
	esac
	#window found, we quit
	exit
  done

