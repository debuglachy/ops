#!/bin/bash

# setting up dir containing notes
if [ -z "$1" ]; then
	if [ -z "$MONOPATH" ]; then
		echo 'Set path to ingest notes from [~/noted-flask-app/notes-data]:'
		read MONOPATH
		MONOPATH=${MONOPATH:-/home/$USER/noted-flask-app/notes-data}
	fi
	else
		echo 'Found environment variable to use.'
		MONOPATH="$1"
fi

! [ -d "$MONOPATH" ] && \
	{ echo 'Not a valid directory';
	echo 'Usage $0: <directory>';
	exit 1; };

[[ "$MONOPATH" == "/" ]] && echo 'Root directory is not permitted' && exit 1

# edit out slashes for consistency
MONOPATH=$(echo "$MONOPATH" | sed 's/\/*$//')

# setting up dir to sort into
[ -z "$SORT_DIR" ] && \
	{ echo 'Set the target directory [~/noted-flask-app/sorted-notes]:';
	read SORT_DIR;
	SORT_DIR=${SORT_DIR:-/home/$USER/noted-flask-app/sorted-notes}; };

[[ "$SORT_DIR" == "/" ]] && echo 'Root directory is not permitted' && exit 1

mkdir -p "$SORT_DIR"

# gather all sub-dirs
CONTINUE=" "

while ! [ "$CONTINUE" == "" ]
do
	read -p 'Enter new/existing subfolder to sort into [01-knowledge-base]: ' SORT_SUBFOLDER
	SORT_SUBFOLDER=${SORT_SUBFOLDER:-"01-knowledge-base"}
	SORT_FOLDERS+=("$SORT_SUBFOLDER")
	echo
	echo "Current selection: ${SORT_FOLDERS[@]}"
	echo
	read -n 1 -p "Press Enter key to continue. Press another key to select more subfolders." CONTINUE
done

# prompt tags for each subfolder and sort all the matching filenames
for subfolder in "${SORT_FOLDERS[@]}"
do
	mkdir -p "$SORT_DIR/$subfolder"
	echo
	read -r -p "Set tags for this folder (separate with ,) [general,note]: " subtags
	subtags=${subtags:-"general,note"}
	echo
	echo "Sorting files with names containing any of tags: $subtags"
	subtags=$(echo "$subtags" | sed 's/,/\|/g')

	for file in $MONOPATH/*; do

#		skip loop for non-files and when nothing found
		[ -e "$file" ] || continue
		[ -f "$file" ] || continue
		[[ "$file" == *.txt ]] || continue

#		tags cleanup and array formation
		clean_header="$(basename -s .txt $file)"
		clean_header="${clean_header// /}"
		clean_header="${clean_header//-/ }"

		read -r -a clean_header <<< "$clean_header"

		topic_dir=""

		for topic in "${clean_header[@]}"; do
#			set directory upon match within tags 
			eval "case \"$topic\" in
				$subtags)
					topic_dir="$subfolder"
					break
					;;
			esac"

#			strip whitespace in path
			topic_dir="$(echo "$topic_dir" | xargs)"
		done

		if ! [ -z "$topic_dir" ]; then

#			filename setup
			filename_tags=("${clean_header[@]:0:5}")
			filename_spaced="${filename_tags[*]}"
			filename_dashed="${filename_spaced[*]// /-}"

#			strip whitespace in filename
			filename="$(echo "$filename_dashed" | xargs)"

#			ensure not empty filename
			if [ -z "$filename" ]; then
				filename="unnamed-note"
			fi

#			get absolute path and trim double slashes
			file_path="$(echo "$SORT_DIR/$topic_dir/$filename" | sed -E 's|/{2,}|/|g')"

#			handle duplicates
			counter=1
			file_path_unique="$file_path"
			while [ -e "$file_path_unique" ]; do
				file_path_unique="$file_path-$counter"
				((counter++))
			done

#			to use copy mode, uncomment the following block and comment mv command at the end
#			echo cp "$file" "$file_path_unique"
#			echo "Moving $filename to $topic_dir"
#			cp -n "$file" "$file_path_unique"
			mv -n "$file" "$file_path_unique"

		fi
	done
done

REMAINING_COUNT=$(ls $MONOPATH/*.txt 2> /dev/null | wc -l)

if [ $REMAINING_COUNT -gt 0 ]; then
	echo
	echo "------------------------"
	echo "$REMAINING_COUNT notes did not match to the selected folders. Apply more tags on the next run to sort these."
	echo "------------------------"
	echo
	exit 2
else
	echo
	echo "------------------------"
	echo "All notes sorted."
	echo "------------------------"
	echo
fi
