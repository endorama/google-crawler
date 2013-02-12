#!/bin/bash

for i in $(ls -v results/${1}); do
  ruby lib/map_all_website/mapper.rb $i
done

echo '"url","count","google_position","tag"' > tmp/first_aggregation.csv
for i in $(ls -v tmp/*.tagged.csv); do
  tail $i -n +2 >> tmp/first_aggregation.csv
done

ruby lib/map_all_website/reducer.rb tmp/first_aggregation.csv ${1:2:2}
