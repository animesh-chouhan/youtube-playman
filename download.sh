#!/bin/bash

YTDL="$HOME/.local/bin/youtube-dl"
FILE="$HOME/Music/playlists.txt"


yt_downloader () {
	NAME="$1"
	URL="$2"

	#Target folder
	TARGET="$HOME/Music/$NAME"

	#Creating required folders
	if [ ! -d $TARGET ]; then
		mkdir $TARGET
		mkdir "$TARGET/Music" "$TARGET/Description"\
		      "$TARGET/Json" "$TARGET/Thumbnails"
	fi

	echo "Downloading..."
	$YTDL\
	 --newline\
	 -i -x\
	 -o "$TARGET/Music/%(title)s.%(ext)s"\
	 --audio-format mp3\
	 --audio-quality 0\
	 --ignore-config\
	 --hls-prefer-ffmpeg\
	 --add-metadata\
	 --embed-thumbnail\
	 --write-all-thumbnails\
	 --write-info-json\
	 --write-description\
	 --download-archive "$TARGET/$NAME.txt"\
	 $URL > "$TARGET/log.txt"

	mv $TARGET/Music/*.jpg         $TARGET/Thumbnails/
	mv $TARGET/Music/*.description $TARGET/Description/
	mv $TARGET/Music/*.json        $TARGET/Json/
}

#Installing ffmpeg
if [ ! hash ffmpeg 2>/dev/null ]; then
        echo "ffmpeg or avconv not found"
	echo "Installing..."
	sudo apt-get install ffmpeg
else
	echo "ffmpeg found"
fi

#Installing youtube-dl
if [ ! -f $YTDL ]; then
	wget "https://yt-dl.org/latest/youtube-dl" -O $YTDL
	chmod a+x $YTDL
#else
	#Updating youtube-dl
	#echo "Checking for updates..."
	#$YTDL -U	
fi



#Storage array
declare -a playlist_name
declare -a playlist_url

#Checking for playlist file
if [ ! -f $FILE ]; then
	echo "Playlist record does not exist"
	echo "Creating..."
	touch $FILE
else
	printf "\nPlaylist record found\n"
	while IFS=';' read -r n u
	do
		playlist_name+=( $n )
		playlist_url+=( $u )
	done < $FILE
fi

printf "Please enter your choice: \n"
#Listing the playlists
for i in "${!playlist_name[@]}"
do
	printf "%d.%s\n" "$(($i+1))" "${playlist_name[$i]}"
done

#Other options
printf "%d.Add a playlist\n" "$(($i+2))"
printf "%d.Exit\n" "$(($i+3))"

#Set the variables
read OPTION
if [ "$OPTION" == "$(($i+3))" ]
then
	exit 1
elif [ "$OPTION" == "$(($i+2))" ]
then
	echo "#Note: Don't use spaces or special charaters"
	echo "Enter playlist name:"
	read enter_name
	echo "Enter playlist url:"
	read enter_url
	printf "%s;%s\n" "$enter_name" "$enter_url" >> $FILE
	yt_downloader "$enter_name" "$enter_url"
	exit 1
fi

NAME="${playlist_name[$((OPTION-1))]}"
URL="${playlist_url[$((OPTION-1))]}"

yt_downloader "$NAME" "$URL"
