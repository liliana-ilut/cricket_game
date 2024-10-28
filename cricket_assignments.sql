--1. Please write a SELECT statement to produce a result set with the match level summary as shown below in the expected result

--match_id, 
--match_date, 
--venue_name, 
--winning_team_name - Name of the winning team. You will find winning_team_id in result table and you need to get the team name for this team.

select * from team;
select * from result;

--answer to question1:
--------------------------------------------------------------------------
select 
	r.match_id,
	m.match_date,
	v.venue_name,
	r.winning_team_id,
	t.team_name as winning_team_name
from match m
join result r
	on m.match_id = r.match_id
join team t
	on r.winning_team_id = t.team_id
join venue v
	on m.venue_id = v.venue_id
;
--------------------------------------------------------------------------
--2. Please write a SELECT statement to produce a result set with the match level summary as shown below in the expected result

--match_id, innings_no
--team_name - Name of the team which is batting this innings
--total_runs  - Total runs scored in this innings
--total_wickets - Total wickets lost in this innings
--total_overs - Total overs bowled in this innings. An over in cricket is 6 balls. No balls and wides don't count towards the balls bowled. So, please exclude them. Also, please format the output as overs.balls (e.g., 18.4). If there are zero balls, just output the number of overs (e.g. 20).

--answer:
------------------------------------------------------------------------------------
select 
	i.match_id,
	i.innings_no,
	i.batting_team_id,
	t.team_name,
	sum(sbb.runs_off_bat) as total_runs,
	count(sbb.wicket_type) as total_wickets,
	cast(sum(ball_no)/6 as decimal(10,2)) as total_overs
from innings i
join team t
	on i.batting_team_id = t.team_id
join score_by_ball sbb
	on i.innings_no = sbb.innings_no
where 
	sbb.wicket_type != 'caught'
	and sbb.wides is null
	and sbb.noballs is null
group by 
	i.match_id,
	i.innings_no,
	i.batting_team_id,
	t.team_name;
-------------------------------------------------------------------------------------------------
select sum(runs_off_bat) as total_runs,
		match_id
from score_by_ball
group by match_id;
	
select cast(sum(ball_no)/6 as decimal(10,2)) from score_by_ball sbb
where 
	sbb.wicket_type != 'caught'
	and sbb.wides is null
	and sbb.noballs is null
;

--3. Please write a SELECT statement to produce a result set with the player level batting scorecard as shown below in the expected result

--match_id, innings_no
--batting_team_name - Name of the team which is batting this innings
--batsman_name - Name of the player to whom the scores belong to
--total_runs  - Total runs scored by this player in this match/ innings
--total_balls - Total balls faced by this player in this match/ innings
--no_of_fours - Number of 4s hit by this player in this match/ innings
--no_of_sixes - Number of 6s hit by this player in this match/ innings
--strike_rate - Strike rate at which the batsman scored the runs. It's calculated as runs per balls, represented as a percentage with 2 decimal places.

select
	i.match_id,
	i.innings_no,
	i.batting_team_id,
	t.team_name,
	p.player_name
from innings i
join team t
	on i.batting_team_id = t.team_id
join player p
	on t.team_id = p.team_id
;
