#!/bin/bash

#directory setup
NOTEPATH="/home/$USER/noted"

! [ -d "$NOTEPATH" ] && { echo "Directory noted does not exist in user's home folder."; exit 1; }

#prompt user with zenity
if command -v zenity &> /dev/null; then
	zenity	--forms \
			--add-entry="Tags" \
			--add-entry="Note" \
			--add-calendar="Due" \
			--forms-date-format="%Y-%m-%d_%H-%M-%S" \
			| awk -F "|" '{print "#"$1"\n\n\n"$2"\n\n\n"$3"\n"}' \
			> $NOTEPATH/"$(date "+%Y-%m-%d_%H-%M-%S" )"
else
	echo "Zenity is not installed on this system."
	exit 1
fi

