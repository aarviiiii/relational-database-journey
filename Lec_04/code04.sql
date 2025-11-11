use sakila;
SHOW TABLES;
CREATE TABLE class 
(class_id INT,
class_name VARCHAR(10),
Total_students INT,
PRIMARY KEY (class_id));

INSERT INTO class
(class_id,class_name,Total_students)
VALUES (1 ,'A', 50),
(2 ,'B', 40);
SELECT * FROM class;

INSERT INTO class
VALUES (5,'D', 69);
SELECT * FROM class;