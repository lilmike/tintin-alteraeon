#!/bin/bash

path="${XDG_CONFIG_HOME:-$HOME/.config}/tintin-alteraeon"
f="$(mktemp --suffix .tar.gz)"
echo "Getting soundpack..."
curl -s "https://stormdragon.tk/downloads/aa-sounds.tar.gz" > "$f"
echo "extracting soundpack..."
tar xvf "$f" -C "$path/"
rm -f "$f"
read -n1 -p "Do you want the background music too? " answer
if [ "${answer^}" = "Y" ]; then
f="$(mktemp --suffix .tar.gz)"
echo "Getting Music..."
curl -s "https://stormdragon.tk/downloads/aa-bgm.tar.gz" > "$f"
echo "extracting soundpack..."
tar xvf "$f" -C "$path/sounds/"
rm -f "$f"
fi
exit 0
