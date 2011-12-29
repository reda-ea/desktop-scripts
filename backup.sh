#!/bin/bash

# usage: backup.sh destination limit
#        destination is an absolute path
#        list of files/dirs in destination/paths.list
#        (absolute paths, folders should end with "/" )
#        for encrypted destinations, password should be
#        piped to standard input


DATE=`date "+%Y%m%d%H%M%S"`

# if the folder is encrypted, mount it
echo ">>> looking for $1/.*encfs*.xml"
if [[ $(ls $1/.*encfs*.xml) ]]; then
	echo ">>>> i'm here"
        BACKUP=$(mktemp -d)
	echo "encfs -S $1 $BACKUP"
        encfs -i 1 -S "$1" "$BACKUP"
else
	BACKUP="$1"
fi

# backup limit: once a year/month/day/hour
DATEFILTER="+%Y"
case "$2" in
	m) DATEFILTER="+%Y%m" ;;
	d) DATEFILTER="+%Y%m%d" ;;
	h) DATEFILTER="+%Y%m%d%H" ;;
	s) DATEFILTER="+%s" ;;
esac
if [[ $(date -d @$(stat -c %Y "$BACKUP/current") $DATEFILTER) -eq $(date $DATEFILTER) ]]; then
	exit 1
fi

# moving to backup folder
# (because of crazy encfs problems)
cd $BACKUP
FILES="$BACKUP/paths.list"

# backing up
mkdir -p "$BACKUP/$DATE"

grep -v "^#" "$FILES" | while read f; do
	if [[ -d "$f" ]]; then
		mkdir -p "$BACKUP/$DATE/$f"
		LINKDEST="$BACKUP/$(readlink current)/$f"
	else
		LINKDEST=$(dirname "$BACKUP/$(readlink current)/$f")
	fi

	if [[ -e "$BACKUP/current/$f" ]]; then
		echo ">>> rsync -aP --link-dest=$LINKDEST $f $DATE/$f"
		rsync -aP --link-dest="$LINKDEST" "$f" "$BACKUP/$DATE/$f"
	else
		echo ">>> rsync -aP $f $BACKUP/$DATE/$f"
		rsync -aP "$f" "$BACKUP/$DATE/$f"
	fi
done

ln -sfT $DATE current

if [[ $(ls $1/.*encfs*.xml) ]]; then
	sleep 5
	fusermount -zu "$BACKUP"
	rmdir "$BACKUP"
# if unmounting didn't work,
# it will happen after one minute anyway
# but the directory will stay there
fi

