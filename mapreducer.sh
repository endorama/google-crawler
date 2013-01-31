#!/bin/bash

path=$(dirname $1)
file=$(basename "$1")
extension="${file##*.}"
filename="${file%.*}"

file="${path}/${filename}.${extension}"
file_mapreduced="${path}/${filename}.mapreduced.${extension}"

echo "url, count" > $file_mapreduced
cat "${file}" | cut -f 1 -d ',' | sort | ruby mapper.rb | sort -k1,1 | ruby reducer.rb | sort -k2,2 --reverse >> "${file_mapreduced}"
