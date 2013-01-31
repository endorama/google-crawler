#!/bin/bash

file="scraped/${1// /_}-${2}"
ruby crawler.rb $1 $2
