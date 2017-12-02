#!/bin/bash

# Path where lyrics are stored
# Most likely ~/.local/share/fortunes
lyricsPath="${XDG_DATA_HOME:-$HOME/.local/share}/fortune"
mkdir -p "$lyricsPath"

# Get the song and artist info
artist="$(echo "$2" | cut -d '-' -f1)"
song="$(echo "$2" | cut -d '-' -f2 | cut -d '(' -f1)"
song="$(echo "$2" | sed 's/.* - \(.*\)/\1/')"
lyricsFile="${song// /-}.${artist// /-}"

if ! [[ -f "$lyricsPath/$lyricsFile" ]]; then
clyrics "$song : $artist" > "$lyricsPath/$lyricsFile"
sed -i 's/^$/%/g' "$lyricsPath/$lyricsFile"
 strfile "$lyricsPath/$lyricsFile" &> /dev/null
# Remove the files if they don't contain anything
[[ -s "$lyricsPath/$lyricsFile" ]] || rm "$lyricsPath/$lyricsFile" "$lyricsPath/$lyricsFile.dat"
fi

# Sometimes the file is created, but it's one long string
# Try to protect against that since the one string will most likely be too long for the 400 character limit
if ! grep '%' "$lyricsPath/$lyricsFile" &> /dev/null ; then 
rm "$lyricsPath/$lyricsFile.dat"
tmp="$(fold -s "$lyricsPath/$lyricsFile" | sed '0~4 s/$/\n%/g')"
echo "$tmp" > "$lyricsPath/$lyricsFile"
 strfile "$lyricsPath/$lyricsFile" &> /dev/null
fi

# Display the lyrics or an error if nothing is found
if [[ -e "$lyricsPath/$lyricsFile" ]]; then
echo "$1 $(fortune -n400 -s -- "$lyricsPath/$lyricsFile" | tr '[:space:]' ' ') -- it's $song by $artist"
else
echo "#echo {No lyrics found for $song by $artist.}"
fi
exit 0
