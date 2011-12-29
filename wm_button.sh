#! /bin/bash

#does an action on the current window

#get current window
#WIN=`xprop -root | grep _NET_ACTIVE_WINDOW\(WINDOW\) | sed "s/.*# //"`

#get topmost maximized window
xprop -root _NET_CLIENT_LIST_STACKING |
  sed "s/.*# //" | sed s"/, /\n/g" | tac | 
  while read w; do 
	xprop -id $w | grep _NET_WM_STATE_MAXIMIZED_VERT &&
# TODO test if window is in current viewport 
	  case "$1" in
		"close" ) wmctrl -ic $w ;;
		"min"   ) wmctrl -ir $w -b add,hidden ;; #FIXME
		"max"   ) wmctrl -ir $w -b toggle,maximized_vert,maximized_horz ;;
		"unmax" ) wmctrl -ir $w -b remove,maximized_vert,maximized_horz ;;
	  esac && exit
  done

