# youtube-playman

![.](https://img.shields.io/badge/platforms-linux--64-lightgrey.svg)
![license](https://img.shields.io/github/license/animesh-chouhan/youtube-playman)

>Downloads and updates local copies of YouTube Playlists 

>A simple yet powerful script to download and manage local copies of youtube music playlists

## Setup

### Linux:

Cloning the repository:
```sh
#clone the repo
$git clone https://github.com/animesh-chouhan/yt-comment-scraper.git
$cd youtube-playman
```
Running the script:

```sh
#run the script directly
$chmod +x ./download.sh
$./download.sh

OR

#create a hard link to the local binary folder
#this will add the downloader to the path variable 
$ln ./download.sh ~/.local/bin/download

#directly running the script
$download

```
Add Jobs To cron:

```sh
#creating a cron job that will update the playlists automatically
$crontab -e

#this will open a editor and add this entry to the file
#don't forget the newline after the last entry

PATH="/usr/local/bin:/usr/bin:/bin:/home/<YOUR-USERNAME>/.local/bin"
@daily printf "update-all" | download

```
For more details refer to [ubuntu cron wiki](https://help.ubuntu.com/community/CronHowto).

## Usage example
Click on the play button to see an example download.
<a href="https://asciinema.org/a/bQgrwQfcFLtcuJpKMGEuq0Til?speed=2&preload=1&autoplay=1">
  <img src="https://asciinema.org/a/bQgrwQfcFLtcuJpKMGEuq0Til.png" max-width="1000px"/>
</a>

_For more examples and usage, please refer to the [Wiki][wiki]._


## Built With

* [youtube-dl](https://github.com/ytdl-org/youtube-dl) - Command-line program to download videos from YouTube



## Contributing

1. Fork the repo (<https://github.com/animesh-chouhan/youtube-playman/>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

<!-- Markdown link & img dfn's -->
[license]: https://img.shields.io/github/license/animesh-chouhan/youtube-playman
[wiki]: https://github.com/animesh-chouhan/youtube-playman/wiki

## License
MIT License
copyright (c) 2020 [Animesh Singh Chouhan](https://github.com/animesh-chouhan). Please have a look at the [license](LICENSE) for more details.

