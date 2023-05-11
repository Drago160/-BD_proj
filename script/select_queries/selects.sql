-- 1) отсортируем участников по числу его побед
with black as (
select 
	player.id as id
	, count(country) as black_wins
from
	player join match
	on player.id = match.black_player_id
group by player.id
),
white as (
select 
	player.id as id
	, count(country) as white_wins
from
	player join match
	on player.id = match.white_player_id
where winner = 0
group by player.id
)
select
	id
	, firstname
	, surname
	, case 
		when white_wins is null and black_wins is null then 0
		when white_wins is null then black_wins
		when black_wins is null then white_wins
		else white_wins + black_wins
		end as wins
from
	white 
	full join black
	using(id)
	full join (select id, firstname, surname from player) as all_
	using(id)
order by wins desc


-- 2) теперь сделаем то-же самое но сгруппируем по стране
-- отсортируем участников по числу его побед

with all_wins as (
with black as (
select 
	count(*) as black_wins
	, player.id
from
	player join match
	on player.id = match.black_player_id
group by player.id
),
white as (
select 
	count(*) as white_wins
	, player.id
from
	player join match
	on player.id = match.white_player_id
where winner = 0
group by player.id
)
select
	case 
		when white_wins is null and black_wins is null then 0
		when white_wins is null then black_wins
		when black_wins is null then white_wins
		else white_wins + black_wins
		end as wins
	, country
from
	white 
	full join black
	using(id)
	full join (select id, country from player) as all_
	using(id)
order by wins desc
)
select 
	country
	, sum(wins)  as wins
	, rank() over (order by sum(wins) desc) AS rank
from all_wins
group by country
;




-- 3) по каждому турниру выведем сколько в нем было побез
-- за белых и за черных

with id_wins as (
select 
	tournament.id as id
	, sum(winner) as black_wins
	, sum(1-winner) as white_wins
from 
	tournament join match
	on tournament.id = match.tournament_id
	
group by tournament.id
)
select 
	tournament.name
	, black_wins
	, white_wins
from
	id_wins join tournament
	on id_wins.id = tournament.id
;


-- 4) найдем для каждого тренера всех его подопечных на сегодняшний день

select 
	concat (coach.firstname, ' ', coach.surname) as coach
	, concat (player.firstname, ' ', player.surname) as player
from
	coach join coaching
		on coach.id = coaching.coach_id
	join player
		on player.id = coaching.player_id
where
	valid_from <= CURRENT_DATE
	and valid_to >= CURRENT_DATE
order by 
	coach.id



-- 5) для каждого тренера найдем сколько
-- побед суммарно на турнирах у его подопечных

with player_wins as (
with black as (
select 
	player.id as id
	, count(country) as black_wins
from
	player join match
	on player.id = match.black_player_id
group by player.id
),
white as (
select 
	player.id as id
	, count(country) as white_wins
from
	player join match
	on player.id = match.white_player_id
where winner = 0
group by player.id
)
select
	id
	, firstname
	, surname
	, case 
		when white_wins is null and black_wins is null then 0
		when white_wins is null then black_wins
		when black_wins is null then white_wins
		else white_wins + black_wins
		end as wins
from
	white 
	full join black
	using(id)
	full join (select id, firstname, surname from player) as all_
	using(id)
order by wins desc
)
, coach_and_player as (
	select 
	player.id as player_id
	, coach.id as coach_id
	, concat (coach.firstname, ' ', coach.surname) as coach
	, concat (player.firstname, ' ', player.surname) as player
from
	coach join coaching
		on coach.id = coaching.coach_id
	join player
		on coaching.player_id = player.id
where
	valid_from <= CURRENT_DATE
	and valid_to >= CURRENT_DATE
order by coach_id
)
select 
	coach,
	sum(wins) as sum_wins
from 
	coach_and_player join player_wins
		on coach_and_player.player_id = player_wins.id
group by coach
order by sum_wins desc

-- 6) для кажого участника определим число его побед в конкретном турнире
-- и какое место он занял в анном турнире

with grouped as (
with winners as (
select
	id as match_id
	, tournament_id
	, duration
	, case
		when winner = 1 then black_player_id
		else white_player_id
		end as winner_id
from 
	match
)
select 
	 concat (firstname, ' ', surname) as player
	, tournament.id as tournament_id
	, count(*) as wins
from 
	player join winners
		on player.id = winners.winner_id
	join tournament
		on tournament.id = winners.tournament_id
group by player.id, tournament.id
order by tournament_id, wins desc
)
select 
	player
	, tournament.name
	, wins
	, dense_rank() over (partition by tournament_id order by wins) as rank
from 
	tournament join grouped
	on tournament.id = grouped.tournament_id
;
