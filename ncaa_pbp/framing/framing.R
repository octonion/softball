sink("framing.txt")

library("lme4")
library("RPostgreSQL")

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv,host="localhost",port="5432",dbname="softball")

query <- dbSendQuery(con, "
select

pitcher_id,
catcher_id,
count,
sum(balls) as balls,
sum(called_strikes) as called_strikes
from
(
select
p.player_id as pitcher_id,
c.player_id as catcher_id,
ps.pitch_string,
ps.balls::text||'-'||ps.strikes::text as count,
length(ps.pitch_string)-length(replace(ps.pitch_string,'B','')) as balls,
length(ps.pitch_string)-length(replace(ps.pitch_string,'K','')) as called_strikes
from ncaa_pbp.play_by_play pbp
join ncaa_pbp.periods per
  on (per.game_id,per.section_id)=(pbp.game_id,0)
join ncaa_pbp.pitch_strings ps
  on (ps.game_id,ps.period_id,ps.event_id)=
     (pbp.game_id,pbp.period_id,pbp.event_id)
join ncaa_pbp.box_scores_fielding p
  on (p.game_id,p.section_id)=(per.game_id,per.section_id)
join ncaa_pbp.box_scores_fielding c
  on (c.game_id,c.section_id)=(per.game_id,per.section_id)
where
    pbp.team_text is null
and pbp.opponent_text is not null
and p.starter and p.position='P'
and c.starter and c.position='C'

union all

select
p.player_id as pitcher_id,
c.player_id as catcher_id,
ps.pitch_string,
ps.balls::text||'-'||ps.strikes::text as count,
length(ps.pitch_string)-length(replace(ps.pitch_string,'B','')) as balls,
length(ps.pitch_string)-length(replace(ps.pitch_string,'K','')) as called_strikes
from ncaa_pbp.play_by_play pbp
join ncaa_pbp.periods per
  on (per.game_id,per.section_id)=(pbp.game_id,1)
join ncaa_pbp.pitch_strings ps
  on (ps.game_id,ps.period_id,ps.event_id)=
     (pbp.game_id,pbp.period_id,pbp.event_id)
join ncaa_pbp.box_scores_fielding p
  on (p.game_id,p.section_id)=(per.game_id,per.section_id)
join ncaa_pbp.box_scores_fielding c
  on (c.game_id,c.section_id)=(per.game_id,per.section_id)
where
    pbp.team_text is not null
and pbp.opponent_text is null
and p.starter and p.position='P'
and c.starter and c.position='C'
) outcomes
where
    pitcher_id is not null
and catcher_id is not null
and balls is not null
and called_strikes is not null
group by pitcher_id,catcher_id,count
having sum(balls)+sum(called_strikes)>0
;")

pitches <- fetch(query,n=-1)

dim(pitches)

#pitches$year <- as.factor(pitches$year)
#pitches$field <- as.factor(pitches$field)
pitches$count <- as.factor(pitches$count)
#pitches$uhp_id <- as.factor(pitches$uhp_id )
pitches$catcher_id <- as.factor(pitches$catcher_id)
#pitches$b_id <- as.factor(pitches$b_id)
pitches$pitcher_id <- as.factor(pitches$pitcher_id)

head(pitches)

model <- cbind(called_strikes,balls) ~ (1|catcher_id) + (1|pitcher_id)
outcome <- glmer(model, data=pitches, family=binomial(link="logit"), verbose=T)

outcome
summary(outcome)
AIC(outcome)

fixef(outcome)
ranef(outcome)
(ranef(outcome)$catcher_id)[,1]
rownames(ranef(outcome)$catcher_id)

framing <- data.frame(catcher_id=rownames(ranef(outcome)$catcher_id),framing=ranef(outcome)$catcher_id[,1])

write.csv(framing, file="framing.csv")
dbWriteTable(con,c("ncaa_pbp","_framing"),framing,row.names=FALSE)

q("no")
