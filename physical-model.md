# Физическая модель

---

Таблица `plyer`:

|     Название    |     Описание       |   Тип данных   |      Ограничения        |
|-----------------|--------------------|----------------|-------------------------|
| `id`            | Идентификатор      | `INT`          | `PRIMARY KEY`           |
| `country`       | страна игрока      | `VARCHAR`      |                         |
| `firstname`     | Имя игрока         | `VARCHAR`      | `NOT NULL`              |
| `surname`       | Фамилия игрока     | `VARCHAR`      | `NOT NULL`              |
| `birthdate`     | Дата рождения      | `DATE`         |                         |
| `begindate`     | Дата начала карьеры| `DATE`         |                         |

Таблица `coach`:

|      Название        |         Описание        |  Тип данных   |       Ограничение      |
|----------------------|-------------------------|---------------|------------------------|
| `id`                 | Идентификатор  тренера  | `INT`         | `PRIMARY KEY`          |
| `firstname`          | Имя тренера             | `VARCHAR`     | `NOT NULL`             |
| `surname`            | Фамилия тренера         | `VARCHAR`     | `NOT NULL`             |
| `birthdate`          | Дата рождения           | `DATE`        |                        |


Таблица `tournament`:

|  Название  |          Описание               | Тип данных  |         Ограниченя        |
|------------|---------------------------------|-------------|---------------------------|
| `id`       | Идентификатор турнира           | `INT`       | `PRIMARY KEY`             |
| `name`     | Название турнира                | `VARCHAR`   | `NOT NULL`                |
| `sponsor`  | Идентификатор члена             | `VARCHAR`   |                           |
| `ELO_rate` | Рейтинг Эло турнира             | `INT`       |                           |
| `date`     | Дата проведения турнира         | `DATE`      |                           |
| `country`  | Страна где турнир проводится    | `VARCHAR`   |                           |


Таблица `match`:

|  Название          |          Описание             | Тип данных  |         Ограниченя        |
|--------------------|-------------------------------|-------------|---------------------------|
| `id`               | Идентификатор матча           | `INT`       | `PRIMARY KEY`             |
| `black_player_id`  | Идентификатор игрока черными  | `INT`       | `NOT NULL`, `FOREIGN KEY` |
| `white_player_id`  | Идентификатор игрока черными  | `INT`       | `NOT NULL`, `FOREIGN KEY` |
| `duration`         | Длительность матча            | `INT`       |                           |
| `winner`           | Победитель                    | `FLOAT`     |                           |
|                    |   (0 - белые, 1 - черные,     |             |                           |
|                    |    0.5 - ничья                |             |                           |
| `tournament_id`    |  Идентификатор турнира        | `INT`       | `NOT NULL`, `FOREIGN KEY` |

Таблица `coaching` (версионность):

|  Название     |          Описание               | Тип данных  |                Ограниченя                |
|---------------|---------------------------------|-------------|------------------------------------------|
| `coach_id`    | Идентификатор тренера           | `INT`       | `PRIMARY KEY`, `FOREIGN KEY`             |
| `player_id`   | Идентификатор игрока            | `INT`       | `PRIMARY KEY`, `FOREIGN KEY`             |
| `valid_from`  | с какой даты валидна            | `DATE`      | `NOT NULL`                               |
| `valid_to`    | До какой даты валидна           | `DATE`      | `NOT NULL`                               |

Таблица player:

CREATE TABLE if not exists player (
    id integer PRIMARY KEY,
    country varchar,
	
	firstname varchar not null,
	surname varchar not null,
	
    birthdate date,
   	begindate date
);

Таблица coach:

create table if not exists coach (
	id int PRIMARY KEY,
	
	firstname varchar not null,
	surname varchar not null,
	
	birthdate date
);

Таблица tournament:

create table if not exists tournament (
	id int PRIMARY KEY,
	
	name varchar not null,
	sponsor varchar,
	
	ELO_rate int,
	date date,
	country varchar
);

------------------------------
Таблица coaching:

create table if not exists coaching (
	coach_id int,
	player_id int,
	
	valid_from date,
	valid_to date not null,
	
	FOREIGN KEY (coach_id) REFERENCES Coach(id),
    FOREIGN KEY (player_id) REFERENCES Player(id),
	
	CONSTRAINT coaching_PK PRIMARY KEY(coach_id, player_id, valid_from)
);

Таблица match:

create table if not exists match (
	id int not null PRIMARY KEY unique,
	black_player_id int not null,
	white_player_id int not null,
	duration int,
    winner float,
    tournament_id int not null
);

