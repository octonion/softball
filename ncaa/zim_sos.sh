#!/bin/bash

#psql softball -c "drop table if exists ncaa.results;"
#psql softball -f sos/standardized_results.sql

psql softball -c "vacuum full verbose analyze ncaa.results;"

psql softball -c "drop table if exists ncaa._zim_parameter_levels;"
psql softball -c "drop table if exists ncaa._zim_basic_factors;"

R --vanilla -f sos/ncaa_zim.R

psql softball -c "vacuum full verbose analyze ncaa._zim_parameter_levels;"
psql softball -c "vacuum full verbose analyze ncaa._zim_basic_factors;"

psql softball -f sos/zim_normalize_factors.sql
psql softball -c "vacuum full verbose analyze ncaa._zim_factors;"

psql softball -f sos/zim_schedule_factors.sql
psql softball -c "vacuum full verbose analyze ncaa._zim_schedule_factors;"

psql softball -f sos/zim_current_ranking.sql > sos/zim_current_ranking.txt

#psql softball -f sos/division_ranking.sql > sos/division_ranking.txt
#psql softball -f sos/connectivity.sql > sos/connectivity.txt
