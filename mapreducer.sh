#!/bin/bash

echo "Applying mapreduce..."

echo "Calculating website frequency... "
bash lib/map_website_frequency/run.sh $1
echo "[DONE]"

echo "Calculating website position..."
bash lib/map_website_position/run.sh $1
echo "[DONE]"

echo "Mapping website frequency to position"
bash lib/map_frequency_position/run.sh $1
echo "[DONE]"

echo "Mapping website frequency to position"
bash lib/map_all_website/run.sh
echo "[DONE]"

echo "Applying mapreduce... [DONE]"
