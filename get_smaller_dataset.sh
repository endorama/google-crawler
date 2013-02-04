#!/bin/bash

path=$(dirname $1)
file=$(basename "$1")
extension="${file##*.}"
filename="${file%.*}"
filename=$(echo $filename | cut -f 1 -d '-')

file="$path/${filename}-$2.$extension"
file_mapreduced="$path/$filename.mapreduced.$extension"

head $1 -n $(($2*10+1)) > $file
