#!/bin/bash

if [[ -z "`ls $1/.*encfs*.xml`" ]]; then
	zenity --error --text="Not an encfs folder"
	exit 1
fi


TEMP=`mktemp -d`
encfs  --idle=1 --extpass="zenity --password --title=encfs" "$1" "$TEMP" && caja "$TEMP" || zenity --error --text="Password incorrect"

cd $TEMP; mate-terminal
