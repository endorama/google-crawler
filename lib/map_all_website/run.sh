#!/bin/bash

for i in $(ls -v results/*.mapreduced.csv); do
  ruby lib/map_all_website/mapper.rb $i
done

echo '"url","count","google_position","tag"' > tmp/first_aggregation.csv
for i in $(ls -v tmp/*.tagged.csv); do
  echo $i
  tail $i -n +2 >> tmp/first_aggregation.csv
done

ruby lib/map_all_website/reducer.rb tmp/first_aggregation.csv

rm -f tmp/*.csv
