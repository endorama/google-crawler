#!/bin/bash

file="scraped/${1// /_}"

datasets=(${2//,/ })
first=$datasets

ruby crawler.rb $first $1

first="${file}-${first}.csv"

for i in ${datasets[@]:1}; do
  f="${file}-${i}.csv"
  bash get_smaller_dataset.sh $first $i
  
done

for i in ${datasets[@]}; do
  f="${file}-${i}.csv"
  bash mapreducer.sh $f
done
