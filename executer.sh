#!/bin/bash

file="scraped/${1// /_}"

file50="${file}-50.csv"
file20="${file}-20.csv"
file15="${file}-15.csv"
file10="${file}-10.csv"

ruby crawler.rb 50 $1
bash mapreducer.sh $file50

bash get_smaller_dataset.sh $file50 20
bash mapreducer.sh $file20

bash get_smaller_dataset.sh $file20 15
bash mapreducer.sh $file15

bash get_smaller_dataset.sh $file15 10
bash mapreducer.sh $file10
