copy (
select
player_name as name,
tr.year as year,
tr.class_year as class,
team_name as team,
framing::numeric(4,3)
from ncaa_pbp._framing f
join ncaa_pbp.team_rosters tr
on (tr.ncaa_id)=(f.catcher_id)
where division_id=1
and tr.year between 2014 and 2017
order by player_name,team,tr.year
) to '/tmp/framing_alpha.csv' csv header;
