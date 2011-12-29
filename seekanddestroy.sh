#! /bin/bash

TOKILL=""
TMPFILE=`mktemp`

ps -A -o pid= -o comm= | grep "$*" > "$TMPFILE"

cat "$TMPFILE"
echo "kill 'em all ?"
read a
if [[ "$a" == "y" ]]; then
	while read s; do
		PID=`echo $s | sed "s/\s*\([0-9]*\)\s*\(\S*\)/\1/g"`
		CMD=`echo $s | sed "s/\s*\([0-9]*\)\s*\(\S*\)/\2/g"`
		kill $PID
	done < "$TMPFILE"
	sleep 1
	while read s; do
                PID=`echo $s | sed "s/\s*\([0-9]*\)\s*\(\S*\)/\1/g"`
                CMD=`echo $s | sed "s/\s*\([0-9]*\)\s*\(\S*\)/\2/g"`
                kill -9 $PID
        done < "$TMPFILE"
fi

rm "$TMPFILE"
