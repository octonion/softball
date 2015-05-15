begin;

drop table if exists ncaa_pbp.team_summaries_hitting;

create table ncaa_pbp.team_summaries_hitting (
       year					integer,
       year_id					integer,
--       division_id				integer,
       team_id					integer,
       team_name				text,
       jersey_number				text,
       player_name				text,
       class_year				text,
       position					text,
       gp					integer,
       gs					integer,
       g					integer,
       gs2					integer,
       ba					float,
       obp					float,
       slg					float,
       ab					text,
       r					integer,
       h					integer,
       d					integer,
       t					integer,
       hr					integer,
       ibb					integer,
       bb					integer,
       hbp					integer,
       rbi					integer,
       sf					integer,
       sh					integer,
       k					integer,
       kl					integer,
       dp					integer,
       gdp					integer,
       tp					integer,
       sb					integer,
       cs					integer,
       picked					integer,
       go					integer,
       fo					integer,
       primary key (year_id,team_id,player_name),
       unique (year,team_id,player_name)
);

copy ncaa_pbp.team_summaries_hitting from '/tmp/team_summaries.csv' with delimiter as E'\t' csv;

commit;
