use sakila;
show tables;
select * from stud1;
select distinct batch_id from stud1;
select batch_id+1 from stud1;
insert into stud1 (batch_id)
select film_id from film;
select * from stud1;
select * from stud1
where batch_id = 2 and students_id < 5;
select * from stud1
where (batch_id = 2) or (students_id < 5);
select * from stud1
where students_id in (1,3,5,4);
