#!/bin/bash

./scrapers/ncaa_box_scores_pitching.rb 2015 2 &
./scrapers/ncaa_box_scores_fielding.rb 2015 2 &

./scrape_ncaa_year_division.sh 2014 1
./scrape_ncaa_year_division.sh 2014 2
./scrape_ncaa_year_division.sh 2014 3

./scrape_ncaa_year_division.sh 2013 1
./scrape_ncaa_year_division.sh 2013 2
./scrape_ncaa_year_division.sh 2013 3

./scrape_ncaa_year_division.sh 2012 1
