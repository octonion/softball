#!/bin/bash

#psql softball -c "drop table if exists ncaa.results;"

#psql softball -f standardized_results.sql

psql softball -c "vacuum full verbose analyze ncaa.results;"

psql softball -c "drop table if exists ncaa._basic_factors_logistic;"
psql softball -c "drop table if exists ncaa._parameter_levels_logistic;"

R --vanilla -f sos/ncaa_lmer_logistic.R

psql softball -c "vacuum full verbose analyze ncaa._parameter_levels_logistic;"
psql softball -c "vacuum full verbose analyze ncaa._basic_factors_logistic;"

psql softball -f sos/normalize_factors_logistic.sql
psql softball -c "vacuum full verbose analyze ncaa._factors_logistic;"

psql softball -f sos/schedule_factors_logistic.sql
psql softball -c "vacuum full verbose analyze ncaa._schedule_factors_logistic;"

psql softball -f sos/current_ranking_logistic.sql > sos/current_ranking_logistic.txt
psql softball -f sos/division_ranking_logistic.sql > sos/division_ranking_logistic.txt
