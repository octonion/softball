#!/bin/bash

psql softball -c "drop table if exists ncaa.results;"

psql softball -f sos/standardized_results.sql

psql softball -c "vacuum full verbose analyze ncaa.results;"

psql softball -c "drop table if exists ncaa._basic_factors;"
psql softball -c "drop table if exists ncaa._parameter_levels;"

R --vanilla -f sos/ncaa_lmer.R

psql softball -c "vacuum full verbose analyze ncaa._parameter_levels;"
psql softball -c "vacuum full verbose analyze ncaa._basic_factors;"

psql softball -f sos/normalize_factors.sql
psql softball -c "vacuum full verbose analyze ncaa._factors;"

psql softball -f sos/schedule_factors.sql
psql softball -c "vacuum full verbose analyze ncaa._schedule_factors;"

psql softball -f sos/current_ranking.sql > sos/current_ranking.txt
cp /tmp/current_ranking.csv sos/current_ranking.csv

psql softball -f sos/division_ranking.sql > sos/division_ranking.txt

psql softball -f sos/connectivity.sql > sos/connectivity.txt
