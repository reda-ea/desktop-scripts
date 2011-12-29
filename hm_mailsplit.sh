#! /bin/bash

# arg 1 is mail file
# arg 2 is destination folder

# FIXME bug si le message contient une ligne To:..., elle est ecrasee aussi.

DEST=`cat "$1" |
	perl -e '$/="";$_=<>;print$&while/^To:.*\n( .*\n)*/mg' |
	sed "s/^To: //g" | tr '\n' ' ' | sed "s/  */ /g"` # | tr ',' '\n'`
#	tr '\n' '\r' | sed "s/\r / /g" | tr '\r' '\n' |
#	grep -i "^To:" | head -n 1 | sed "s/^To://g" | sed "s/ //g"| tr ',' '\n'`
NUMB=`ls -1 "$2" | sort -g | tail -n 1`

echo $DEST | tr ',' '\n' | while read s; do
	NUMB=`expr $NUMB + 1`
	echo ">> $s => $NUMB <<"
	cat "$1" |
#		perl -e '$/="";$_=<>;print$&while/^To:.*\n( .*\n)*/mg' | sed "s/^To: //g" | tr '\n' ' ' | sed "s/  */ /g"
#		sed "s/^To:.*/To: $s/" "$1" > "$2/$NUMB"
		perl -pe "$/=\"\";s/^To:.*\\n( .*\\n)*/To: $s\\n/mg" > "$2/$NUMB"
done;

