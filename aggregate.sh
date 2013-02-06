#!/bin/bash

file="${1// /_}"

# file50="*-50.mapreduced.csv"
# file20="${file}-20.mapreduced.csv"
file15="*-15.mapreduced.csv"
# file10="${file}-10.csv"


# bash lib/map_all_website/run.sh $file50
# bash lib/map_all_website/run.sh $file20
bash lib/map_all_website/run.sh $file15
# bash lib/map_all_website/run.sh $file10
