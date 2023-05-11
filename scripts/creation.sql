CREATE TABLE if not exists player (
    id integer PRIMARY KEY,
    country varchar,
	
	firstname varchar not null,
	surname varchar not null,
	
    birthdate date,
   	begindate date
);


create table if not exists coach (
	id int PRIMARY KEY,
	
	firstname varchar not null,
	surname varchar not null,
	
	birthdate date
);


create table if not exists tournament (
	id int PRIMARY KEY,
	
	name varchar not null,
	sponsor varchar,
	
	ELO_rate int,
	date date,
	country varchar
);

------------------------------

create table if not exists coaching (
	coach_id int,
	player_id int,
	
	valid_from date,
	valid_to date not null,
	
	FOREIGN KEY (coach_id) REFERENCES Coach(id),
        FOREIGN KEY (player_id) REFERENCES Player(id),
	
	CONSTRAINT coaching_PK PRIMARY KEY(coach_id, player_id, valid_from)
);



create table if not exists match (
	id int not null PRIMARY KEY unique,
	black_player_id int not null,
	white_player_id int not null,
	duration int,
    winner float,
    tournament_id int not null
);

