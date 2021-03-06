#!/bin/bash

# Dependancy check 
for i in clyrics ; do
if ! command -v $i &> /dev/null ; then
    echo "#echo {Please install $i before using this script.}"
  exit 1
  fi
done

# Get the song and artist info
artist="$(echo "$2" | cut -d '-' -f1 | tr -s '[:space:]')"
artist="${artist%[[:space:]]}"
song="$(echo "$2" | cut -d '-' -f2 | cut -d '(' -f1 | tr -s '[:space:]')"
song="${song%[[:space:]]}"

mapfile -t lyrics < <(clyrics "$song : $artist" | sed '/^$/d')

# Display the lyrics or an error if nothing is found
if [[ -n "$lyrics" ]]; then
  l=$(($RANDOM % ${#lyrics[@]} - 3))
while [[ $l -le ${#lyrics[@]} || $(echo "$lyric" | wc -c) -le 50 ]]; do
  lyric+="${lyrics[$l]} "
  ((l++))
  done
  lyric="$(echo "${lyric[@]//;/:}" | rev)"
  message="${lyric} -- it's $2"
  while [[ ${#message} -gt 500 ]]; do
    lyric="${lyric#* }"
    message="${lyric} -- it's $2"
  done
  lyric="$(echo "${lyric//[[:space:]]/ }" | rev)"
  echo "$1 ${lyric} -- it's $2"
else
  echo "#echo {No lyrics found for $song by $artist.}"
fi

exit 0
