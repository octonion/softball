begin;

drop table if exists ncaa_pbp.box_scores_hitting;

create table ncaa_pbp.box_scores_hitting (
       game_id					integer,
       section_id				integer,
       player_id				integer,
       player_name				text,
       player_url				text,
       starter					boolean,
       position					text,
       g					integer,
       ab					integer,
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
       fo					integer
       
-- This will fail if the two teams are in different divisions
-- Best fix?
--       primary key (game_id, section_id, player_name, position)
);

copy ncaa_pbp.box_scores_hitting from '/tmp/box_scores.csv' with delimiter as E'\t' csv;

commit;
