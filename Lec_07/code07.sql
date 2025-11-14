
    employees.employee_id,
    employees.name,
    departments.department_name
FROM employees
JOIN departments
    ON employees.department_id = departments.department_id;


SELECT
    e.employee_id,
    e.name AS employee_name,
    d.department_name
FROM employees AS e
JOIN departments AS d
    ON e.department_id = d.department_id;


SELECT
    e.name AS employee_name,
    m.name AS manager_name
FROM employees AS e
JOIN employees AS m
    ON e.manager_id = m.employee_id;


SELECT
    o.order_id,
    o.customer_id,
    c.customer_name
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id;


SELECT
    c.customer_name,
    o.order_id
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id;


SELECT
    c.customer_name,
    o.order_id
FROM customers AS c
RIGHT JOIN orders AS o
    ON c.customer_id = o.customer_id;
