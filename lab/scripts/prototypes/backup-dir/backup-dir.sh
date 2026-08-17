#!/bin/bash

#set parent directory

BACKUP_DIR=$(zenity --file-selection --directory)

[ -z $BACKUP_DIR ] || ! [ -d $BACKUP_DIR ] && { echo "Directory must be selected to proceed"; exit 1; }

echo "${#BACKUP_DIR[@]} arguments, first is ${BACKUP_DIR[0]}"

CONTINUE=""

while ! [ "$CONTINUE" == "1" ]
do
	# prompts to select directories to exclude and appends to array
	EXCLUDE_DIRS+=("$(zenity --file-selection --directory --multiple --separator=" ")")

	# unsquash array to have one directory per element
	read -r -a EXCLUDE_DIRS <<< "${EXCLUDE_DIRS[@]}"

	# return all selected so far
	echo "${#EXCLUDE_DIRS[@]} directories selected. Currently excluded: ${EXCLUDE_DIRS[@]}"
	
	# prompt to cancel, add more dirs to exclude or proceed
	read -r -n 1 -s -p "Press Enter to choose more directories, 1 to proceed or 2 to cancel:"$'\n' CONTINUE
	if [ "$CONTINUE" == "2" ]
	then
		echo "Cancelling operation and exiting"$'\n'
		exit 1
	fi
done

TAR_FLAG=""

# construct flags from array
for DIR in "${EXCLUDE_DIRS[@]}"
do
	TAR_FLAG+=" --exclude $DIR"
done

# tarball files and stamp with date
tar $TAR_FLAG -acf /home/$USER/$USER-archive$(date "+%Y-%m-%d_%H-%M-%S" ).tar.gz $BACKUP_DIR

echo "Success!"$'\n'"Backup was saved to /home/$USER/"

