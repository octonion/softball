#!/bin/bash

psql softball -c "drop table if exists ncaa_pbp._framing;"

R --vanilla -f framing.R
