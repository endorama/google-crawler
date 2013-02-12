#!/bin/bash

date=$(date +%d-%m-%Y_%H-%M)

archived_dir="archived/$date"
archived_raw_dir="archived/$date/raw"
archived_mapreduced_dir="archived/$date/mapreduced"

raw_pattern="scraped/*.csv"
mapreduced_pattern="results/*.mapreduced.csv"
results_patter="results/*.aggregate.*"
results_txt_pattern="results/*.txt"

zip_filename="$date.zip"

################################################################################

mkdir $archived_dir
mkdir $archived_raw_dir
mkdir $archived_mapreduced_dir

cp $raw_pattern $archived_raw_dir

cp $mapreduced_pattern $archived_mapreduced_dir

cp $results_patter $archived_dir
cp $results_txt_pattern $archived_dir

cd $archived_dir
zip -9 -r $tar_filename *
mv $zip_filename ..
cd ../..

rm $archived_dir -r
rm $raw_pattern
rm $results_patter
rm $results_txt_pattern
rm tmp/*.csv
