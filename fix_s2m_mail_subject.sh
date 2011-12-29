#!/bin/bash

TEMP=`mktemp`

sed "s/^\(Subject:.*\) \*\*\* Detected as phishing \*\*\*/\1/" "$*" > "$TEMP"
mv "$*" "$*.bak"
mv "$TEMP" "$*"

exit 0
