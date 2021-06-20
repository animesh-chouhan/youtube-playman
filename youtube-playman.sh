#!/bin/bash

#Location of youtube-dl binary
YTDL="$HOME/.local/bin/youtube-dl"

#Location of download target
DOWN="$HOME/Music/"
FILE="${DOWN}playlists.txt"


yt_downloader () {
	NAME="$1"
	URL="$2"

	#Target folder
	TARGET="${DOWN}/${NAME}"

	#Creating required folders
	if [ ! -d "$TARGET" ]; then
		mkdir $TARGET
		mkdir "$TARGET/Music" "$TARGET/Description"\
		      "$TARGET/Json" "$TARGET/Thumbnails"
	fi

	printf "Downloading %s...\n" "$NAME"
	$YTDL\
	 --newline\
	 -i -x\
	 -o "$TARGET/Music/%(title)s-%(uploader)s.%(ext)s"\
	 --audio-format mp3\
	 --audio-quality 0\
	 --ignore-config\
	 --hls-prefer-ffmpeg\
	 --add-metadata\
	 --embed-thumbnail\
	 --write-all-thumbnails\
	 --write-info-json\
	 --write-description\
	 --download-archive "${TARGET}/${NAME}-archive.txt"\
	 $URL > "$TARGET/log.txt"

	#Moving thumbnails and description
	cd "$TARGET/Music"
	count=`/usr/bin/ls -1 *.json 2>/dev/null | /usr/bin/wc -l`
	if [ "$count" != 0 ]
	then
		/usr/bin/mv $TARGET/Music/*.jpg         $TARGET/Thumbnails/
		/usr/bin/mv $TARGET/Music/*.description $TARGET/Description/
		/usr/bin/mv $TARGET/Music/*.json        $TARGET/Json/
	fi

	printf "Done downloading %s.\n" "$NAME"
}

download_and_update() {
	#Installing ffmpeg
	if [ ! hash ffmpeg 2>/dev/null ]; then
	        echo "ffmpeg or avconv not found"
		echo "Installing..."
		sudo apt-get install ffmpeg
	else
		:
		#echo "ffmpeg found"
	fi

	#Installing youtube-dl
	if [ ! -f "$YTDL" ]; then
		wget "https://yt-dl.org/latest/youtube-dl" -O $YTDL
		chmod a+x $YTDL
	else
		#Updating youtube-dl
		echo "Checking for updates..."
		$YTDL -U
	fi
}

#########################################################################
#Main function
#########################################################################

#Download and update required binaries
download_and_update

#Storage array
declare -a playlist_name
declare -a playlist_url

#Checking for playlist file
if [ ! -f $FILE ]; then
	echo "Playlist record does not exist"
	echo "Creating..."
	touch $FILE
else
	printf "Playlist record found\n"
	while IFS=';' read -r n u
	do
		playlist_name+=( $n )
		playlist_url+=( $u )
	done < $FILE
fi

printf "\nPlease enter your choice: \n"

#Listing the playlists
for i in "${!playlist_name[@]}"
do
	printf "%d.%s\n" "$(($i+1))" "${playlist_name[$i]}"
done

#Get the counter
counter=$i

#Other options
printf "%d.Update all playlists\n" "$(($counter+2))"
printf "%d.Add a playlist\n" "$(($counter+3))"
printf "%d.Exit\n" "$(($counter+4))"

#Set the variables
read OPTION
if [ "$OPTION" == "$(($counter+4))" ]
then
	exit 1

elif [ "$OPTION" == "$(($counter+3))" ]
then
	echo "Enter playlist name:"
	read enter_name
	echo "Enter playlist url:"
	read enter_url
	name_formatted=${enter_name// /-}
	printf "%s;%s\n" "$name_formatted" "$enter_url" >> $FILE
	yt_downloader "$name_formatted" "$enter_url"
	exit 1

elif [ "$OPTION" == "update-all" ] || [ "$OPTION" == "$(($counter+2))" ]
then
	for i in "${!playlist_name[@]}"
	do
		NAME="${playlist_name[$i]}"
		URL="${playlist_url[$i]}"
		yt_downloader "$NAME" "$URL"
	done
	exit 1
fi

#Update single playlist
NAME="${playlist_name[$((OPTION-1))]}"
URL="${playlist_url[$((OPTION-1))]}"

yt_downloader "$NAME" "$URL"
