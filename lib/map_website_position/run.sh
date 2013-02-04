#!/bin/bash

path=$(dirname $1)
file=$(basename "$1")
extension="${file##*.}"
filename="${file%.*}"

file="${path}/${filename}.${extension}"
file_mapreduced="${path}/${filename}.website_position.${extension}"

echo "url, google_position" > $file_mapreduced
ruby $(pwd)/lib/map_website_position/splitter.rb $1 >> $file_mapreduced
