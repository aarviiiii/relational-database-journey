USE sakila;
SHOW TABLES;
SELECT * FROM stud1;
SELECT * 
FROM stud1
WHERE students_id BETWEEN 2 AND 4;
SELECT * FROM stud1
WHERE fn LIKE'_a%' OR'%a%';
SELECT * FROM stud1
WHERE batch_id = 2 
ORDER BY fn;

UPDATE stud1
SET fn = 'bkcc',
    ln = 'ckbb'
WHERE students_id = 3;
SELECT * FROM stud1;
