## My Lec 07 Notes: JOINs (The Relationship Magic)

Up to this point, all my queries have been on *one table at a time*. But that's not how real data works. The *real* data is normalized (split up) into many tables.

The `student` table doesn't have the `major_name`, it has a `major_id`. The `major_name` is in the `majors` table. How do I get the student's name *and* their major's name?

This is where `JOIN`s come in. This is the "magic" that reconnects my normalized data. It's how I combine rows from two or more tables based on a shared value.

---

### 1. Intro to JOINs (The `INNER JOIN`)

This is the most common type of join.

* **Need of it:** To combine and read data from multiple tables in a single query.
* **Use of it:** To find a student's name (from `students`) and their major's name (from `majors`) at the same time.
* **The `ON` Keyword:** This is the *rule*. This is where I tell the database *how* the tables are related. It's the "where" of the join. (e.g., `ON students.major_id = majors.major_id`).

#### Aliases (The `AS` Keyword) - An Advantage
This is a "nickname" for my tables. Why type `my_long_student_table_name.student_name` when I can just type `s.student_name`?

* **Advantage:** It makes my query shorter, easier to read, and is *required* for some advanced joins (like Self Joins).

* **Syntax (with Aliases):**
    ```sql
    SELECT [column_names]
    FROM table1 AS t1
    JOIN table2 AS t2 ON t1.common_column = t2.common_column;
    ```
    *(Note: The `JOIN` keyword by itself is just shorthand for `INNER JOIN`)*

* **Example:**
    Let's get the name and major for every student.
    ```sql
    SELECT
        s.student_name,  -- Column from the 's' table
        m.major_name     -- Column from the 'm' table
    FROM
        students AS s
    JOIN
        majors AS m ON s.major_id = m.major_id;
    ```
* **Result:** This creates a *new*, temporary virtual table that has the student's name and their major's name side-by-side.

---

### 2. The Self Join (The "Mirror" Join)

This was a "mind-boggling" one. A Self Join is a table joining... *itself*.

* **What is it?** It's a regular `JOIN`, but I'm treating a single table *as if* it were two separate tables.
* **Use:** This is for when a table has a relationship with *itself*. The classic example is an `employees` table where a `manager_id` column points to another `employee_id` *in the same table*.
* **Mustness of Aliases:** This is the key. **Aliases are NOT optional here.** How else can the database know which "copy" of the table I'm talking about? I *must* give them different nicknames (e.g., `e` for "Employee" and `m` for "Manager").

* **Syntax:**
    ```sql
    SELECT [column_names]
    FROM my_table AS t1
    JOIN my_table AS t2 ON t1.some_column = t2.some_column;
    ```
* **Example:**
    Find every employee and their manager's name (from *one* `employees` table).
    ```sql
    SELECT
        e.employee_name AS Employee,
        m.employee_name AS Manager
    FROM
        employees AS e
    JOIN
        employees AS m ON e.manager_id = m.employee_id;
    ```
* **Result:** This will show `('Rishi', 'Priya')` if Rishi's `manager_id` is the same as Priya's `employee_id`.

---

### 3. Joining Multiple Tables (The "Chain" Join)

I don't have to stop at two tables. I can chain as many `JOIN`s as I need.

* **Step-by-Step Approach:**
    1.  Join Table A to Table B.
    2.  Then, join *that result* to Table C.
    3.  Then, join *that result* to Table D... and so on.

* **Syntax:**
    ```sql
    SELECT [column_names]
    FROM table1 AS t1
    JOIN table2 AS t2 ON t1.common_column = t2.common_column
    JOIN table3 AS t3 ON t2.common_column = t3.common_column;
    ```
* **Example:**
    Get the student name, their major name, *and* the department head for that major.
    (Students -> Majors -> Departments)
    ```sql
    SELECT
        s.student_name,
        m.major_name,
        d.department_head
    FROM
        students AS s
    JOIN
        majors AS m ON s.major_id = m.major_id
    JOIN
        departments AS d ON m.department_id = d.department_id;
    ```
* **Result:** A virtual table with three columns from three different tables.

---

### 4. Compound Joins (The "Composite Key" Join)

This is just a `JOIN` that needs *more than one rule* in the `ON` clause. This is the dance partner for the composite keys I learned about in Lec 02.

* **Syntax:**
    ```sql
    SELECT [column_names]
    FROM table1 AS t1
    JOIN table2 AS t2 ON t1.col_A = t2.col_A AND t1.col_B = t2.col_B;
    ```
* **Example:**
    (Using our old example) Link a `grades` table to an `enrollment` table. The unique "enrollment" is the *combination* of a student and a class.
    ```sql
    SELECT *
    FROM
        student_enrollment AS e
    JOIN
        grades AS g ON e.student_id = g.student_id
                     AND e.class_id = g.class_id;
    ```
* **Result:** This `JOIN` only connects rows where *both* the student ID and the class ID match.

---

### 5. Types of JOINs (The "Bouncer" Analogy)

This is the most critical part.

**The Big Question:** What happens if the `ON` condition is *false*? What if a student has `major_id = NULL`, or `major_id = 5` and there *is no* Major #5?

**The Answer:** It depends on the *type* of join.

#### A) `INNER JOIN` (The "Strict Bouncer")
* **This is what I've been using all along.** `JOIN` is just shorthand for `INNER JOIN`.
* **The Rule:** "If you have a matching partner in the other table, you *both* get in. If you don't have a match, *neither of you* gets in."
* **Result:** It *only* shows rows that have a match in *both* tables. The student with `major_id = NULL` will **not be in the results**.

#### B) `OUTER JOIN` (The "Chill Bouncer")
This is for when I *want* to see the data that *doesn't* match.

##### 1. `LEFT JOIN`
* **The Rule:** "The bouncer is chill for the **LEFT** table (the one after `FROM`)."
* **What it means:**
    1.  *Every* row from the **LEFT** table gets in, no matter what.
    2.  The database *tries* to find a match in the RIGHT table.
    3.  If it finds a match, great, it brings that data.
    4.  If it *doesn't* find a match, the row from the LEFT table *still* gets in, but the columns from the RIGHT table are just filled with **`NULL`**.
* **`LEFT JOIN` includes:** All rows from the LEFT table + matching rows from the RIGHT (or `NULL`s).

* **Syntax:**
    ```sql
    SELECT [column_names]
    FROM table1 AS t1
    LEFT JOIN table2 AS t2 ON t1.common_column = t2.common_column;
    ```
* **Example:**
    I want to see *all* students, even if they haven't declared a major.
    ```sql
    SELECT s.student_name, m.major_name
    FROM students AS s
    LEFT JOIN majors AS m ON s.major_id = m.major_id;
    ```
* **Result:**
    * 'Rishi', 'Data Science'
    * 'Priya', 'Physics'
    * 'Vikram', **`NULL`** (Vikram had `major_id = NULL`, so he was *excluded* by an `INNER JOIN`, but is *included* by a `LEFT JOIN`).

##### 2. `RIGHT JOIN`
* **The Rule:** "The bouncer is chill for the **RIGHT** table (the one after `JOIN`)."
* **What it means:**
    1.  *Every* row from the **RIGHT** table gets in, no matter what.
    2.  If it finds a match in the LEFT table, great.
    3.  If not, the RIGHT table row *still* gets in, and the LEFT table's columns are filled with **`NULL`**.
* **`RIGHT JOIN` includes:** All rows from the RIGHT table + matching rows from the LEFT (or `NULL`s).

* **Syntax:**
    ```sql
    SELECT [column_names]
    FROM table1 AS t1
    RIGHT JOIN table2 AS t2 ON t1.common_column = t2.common_column;
    ```
* **Example:**
    I want to see *all* majors, even if no student is enrolled in them.
    ```sql
    SELECT s.student_name, m.major_name
    FROM students AS s
    RIGHT JOIN majors AS m ON s.major_id = m.major_id;
    ```
* **Result:**
    * 'Rishi', 'Data Science'
    * 'Priya', 'Physics'
    * **`NULL`**, 'Art History' (The 'Art History' major had no students, so it was *excluded* by an `INNER JOIN`, but is *included* by a `RIGHT JOIN`).
