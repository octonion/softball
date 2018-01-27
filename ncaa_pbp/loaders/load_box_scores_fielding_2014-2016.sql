begin;

create temporary table bsf (
       game_id					integer,
       section_id				integer,
       player_id				integer,
       player_name				text,
       player_url				text,
       starter					boolean,
       position					text,
       po					integer,
       a					integer,
       e					integer,
       ci					integer,
       pb					integer,
       sba					integer,
       csb					integer,
       idp					integer,
       itp					integer
       
-- This will fail if the two teams are in different divisions
-- Best fix?
--       primary key (game_id, section_id, player_name, position)
);

copy bsf from '/tmp/box_scores.csv' with delimiter as E'\t' csv;

insert into ncaa_pbp.box_scores_fielding
(game_id,section_id,player_id,player_name,player_url,
 starter,position,po,a,e,ci,pb,sba,csb,tc,idp,itp)
 (
 select
game_id,section_id,player_id,player_name,player_url,
starter,position,po,a,e,ci,pb,sba,csb,
NULL as tc,
idp,itp
from bsf
);
       

commit;
