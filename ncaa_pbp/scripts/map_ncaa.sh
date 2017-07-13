#!/bin/bash

psql softball -f mapping/rosters_remove_duplicates.sql

psql softball -f mapping/rosters_manually_load_missing.sql

psql softball -f mapping/rosters_create_name_mappings.sql

./mapping/rosters_create_name_hashes.rb

psql softball -f mapping/rosters_manually_update_remaps.sql

# Requires the PostgreSQL Levenshtein functionfound in the contributed
# fuzzystrmatch module

# To install:
# apt-get install postgresql-contrib
# CREATE EXTENSION fuzzystrmatch;

psql softball -f mapping/rosters_compute_levenshtein_distances.sql

