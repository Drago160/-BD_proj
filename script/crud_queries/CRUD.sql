-- может быть какой-то тренер которого добавили однако среди них нет того
-- чьи подопечные в таблице и их решено удалить

-- вот те самые кривые запросы
insert into coach
     (id, country, firstname, surname, birthdate)
values (20, 'Russia', 'Evgeniy', 'Petrov', '2000-06-18');

insert into coach
     (id, country, firstname, surname, birthdate)
values (21, 'Russia', 'Vladislav', 'Meshkov', '2003-09-15');


-- удалим их:
delete from coach
where id=20
;

delete from coach
where firstname='Vladislav'
	and surname='Meshkov'
;

-- при заполнении произошла описка в дате
-- нужно сменить дату либо по ID либо по ФИ

UPDATE coach
    SET birthdate = '1985-01-25'
WHERE 1=1
	and id = 19
;
	
update coach
	set birthdate = '1990-05-29'
where firstname='Cassy'
	and surname='Erler'
;

-- посмотрим на все записи
select * from coach;

-- так можно посмотреть тренеров с конкретным годом рождения
select *
from coach
where extract(year from birthdate) = 1990
;


-- то же самое можно проделать для другой таблицы (например player)

-- вот те самые кривые запросы добавления ошибочного
insert into player
     (id, country, firstname, surname, birthdate)
values (120, 'Russia', 'Evgeniy', 'Petrov', '1980-01-09');

insert into player
     (id, country, firstname, surname, birthdate)
values (121, 'Russia', 'Vladislav', 'Meshkov', '2003-09-15');

-- удалим их:
delete from player
where id=120
;

delete from player
where firstname='Vladislav'
	and surname='Meshkov'
;

-- при заполнении произошла описка в дате
-- нужно сменить дату либо по ID либо по ФИ

select * from player;

UPDATE player
    SET birthdate = '2015-04-18'
WHERE 1=1
	and id = 119
;	

update player
	set birthdate = '2018-01-13'
where firstname='Jim'
	and surname='Baverly'
;

-- выведем всю таблицу
select * from player;

-- так можно посмотреть тренеров с конкретным годом рождения
select *
from player
where extract(year from birthdate) = 1990
;

