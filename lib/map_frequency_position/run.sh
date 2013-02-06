#!/bin/bash

path=$(dirname $1)
file=$(basename "$1")
extension="${file##*.}"
filename="${file%.*}"

file="${path}/${filename}.${extension}"
file_mapreduced="results/${filename}.mapreduced.${extension}"
file_frequency="tmp/${filename}.website_frequency.${extension}"
file_position="tmp/${filename}.website_position.${extension}"

echo "url, frequency, google_position" > $file_mapreduced
ruby $(pwd)/lib/map_frequency_position/mapper.rb $file_frequency $file_position $file_mapreduced >> $file_mapreduced
# ruby $(pwd)/lib/map_frequency_position/mapper.rb $file_frequency $file_position >> $file_mapreduced
