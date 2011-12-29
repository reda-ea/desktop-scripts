#! /bin/bash

IN=`mktemp`
OUT=`mktemp`
PIPE=`mktemp -u`

mknod $PIPE p

while true; do
	nc -l $2 0<$PIPE | tee $IN | nc "$3" $4 | tee $OUT 1>$PIPE
	$1 $IN  | sed "s/^/>>> /g"
	$1 $OUT | sed "s/^/<<< /g"
done

