## My Lec 05 Notes: Filtering at Last! (WHERE, DISTINCT, and IN)

In Lec 04, I learned to `SELECT` data, but I was getting *everything*. It was like asking for "all the books" from the robot librarian.

Now, I'm learning how to be specific. This is where I get the *real* power.

---

### 1. The `DISTINCT` Keyword (The "De-Duplicator")

This is my tool for getting rid of duplicates.

**The Problem:** If I ask for all majors, I get a list with a ton of repeats.
`SELECT major FROM my_students;`
*Result:* 'CS', 'CS', 'Math', 'Physics', 'CS', 'Math'

I don't want that. I want a *clean list* of which majors are available.

#### A) `DISTINCT` on a Single Column

This gives me the unique list of values for *that one column*.

* **Syntax:**
    ```sql
    SELECT DISTINCT column_name FROM table_name;
    ```
* **Example:**
    ```sql
    SELECT DISTINCT major FROM my_students;
    ```
* **Result:**
    'CS', 'Math', 'Physics'
    (All the duplicates are gone. Perfect.)

#### B) `DISTINCT` on Multiple Columns

This one is trickier. It doesn't find unique majors *and* unique GPAs separately. It finds unique **rows** (or combinations) of the columns I listed.

* **Syntax:**
    ```sql
    SELECT DISTINCT column1, column2 FROM table_name;
    ```
* **Example:**
    ```sql
    SELECT DISTINCT major, gpa FROM my_students;
    ```
* **Result:**
    If my data is `('CS', 3.8)`, `('CS', 3.8)`, and `('CS', 4.0)`, this query will return:
    * `('CS', 3.8)`
    * `('CS', 4.0)`
    It returns `('CS', 3.8)` *only once* because the *combination* is a duplicate.

---

### 2. `SELECT` as `print()` (The "SQL Calculator")

This was a "mind-boggling" moment. I realized `SELECT` doesn't *have* to come from a table. I can just use it to... *do stuff*. It's SQL's version of a `print()` function or a calculator.

**Use Cases:**
* Testing math logic.
* Checking the current date/time.
* Just seeing what an expression does.

* **Syntax:**
    ```sql
    SELECT [expression];
    ```
* **Example (Math):**
    ```sql
    SELECT 100 * 5 + 3;
    ```
    *Result:* `503`

* **Example (Text):**
    ```sql
    SELECT 'Hello, this is a string!';
    ```
    *Result:* `'Hello, this is a string!'`

---

### 3. Operations on Columns

I can use that "SQL Calculator" idea *on my columns*. I can create new, *calculated* columns on the fly.

**Operators I can use:**
* `+` (Add)
* `-` (Subtract)
* `*` (Multiply)
* `/` (Divide)
* `%` (Modulo / Remainder)

* **Syntax:**
    ```sql
    SELECT column1, column2, (column1 + 10) FROM table_name;
    ```
* **Example:**
    Let's say I want to see every student's GPA, and also what their GPA would be if I added 1 point to it.
    ```sql
    SELECT student_name, gpa, gpa + 1
    FROM my_students;
    ```
* **Result:**
    * 'Rishi', 3.8, 4.8
    * 'Priya', 4.0, 5.0
    * 'Vikram', 3.5, 4.5
    (That `gpa + 1` column is just *calculated* for this query; it doesn't change the real data).

---

### 4. `INSERT INTO ... SELECT` (The "Copy-Paste" Command)

This is a powerful combo. I learned `INSERT` (the "C") and `SELECT` (the "R"). Now I'm combining them to copy data from one table straight into another.

This is perfect for making backups or creating summaries.

It's literally two queries in one:
1.  `INSERT INTO target_table (col1, col2)`
2.  `SELECT source_col1, source_col2 FROM source_table`

* **Syntax:**
    ```sql
    INSERT INTO target_table (column1, column2)
    SELECT source_column1, source_column2
    FROM source_table;
    ```
* **Example:**
    I want to back up all my "CS" students into a new table called `cs_students_backup`.
    ```sql
    INSERT INTO cs_students_backup (student_id, student_name)
    SELECT student_id, student_name
    FROM my_students;
    ```
* **Result:**
    This query will *read* all the 'CS' students from `my_students` and *insert* them directly into `cs_students_backup`. So efficient.

---

### 5. The `WHERE` Clause (The "Bouncer")

This is it. This is the *real* power.

Until now, I was getting *all the rows*. `SELECT` lets me pick the *columns*. `WHERE` lets me pick the *rows*.

This is the bouncer at the door. "You can come in, you can't."

* **Syntax:**
    ```sql
    SELECT column_names
    FROM table_name
    WHERE [condition is TRUE];
    ```
* **Example:**
    I only want students with a GPA over 3.5.
    ```sql
    SELECT student_name, gpa
    FROM my_students
    WHERE gpa > 3.5;
    ```
* **Result:**
    * 'Rishi', 3.8
    * 'Priya', 4.0
    * 'Sonia', 3.9
    ('Vikram', 3.5, is *filtered out* because his row didn't pass the `WHERE` condition).

---

### 6. Logical Operators (The "Bouncer's Rules")

What if my bouncer needs *multiple* rules? That's what `AND`, `OR`, and `NOT` are for.

* **`AND`**: The strict bouncer. *All* conditions must be true.
* **`OR`**: The chill bouncer. *Any* single condition can be true.
* **`NOT`**: The opposite bouncer. Reverses the condition (e.g., `NOT 'CS'` means "everyone *except* CS").

* **Example (AND):**
    I want students who are 'CS' majors *and* have a GPA over 3.5.
    ```sql
    SELECT student_name, major, gpa
    FROM my_students
    WHERE major = 'CS' AND gpa > 3.5;
    ```
* **Example (OR):**
    I want students who are 'CS' majors *or* just have a GPA over 3.5 (I'll take either).
    ```sql
    SELECT student_name, major, gpa
    FROM my_students
    WHERE major = 'CS' OR gpa > 3.5;
    ```

#### Why Parentheses `( )` are CRITICAL

This is a classic trap. `AND` and `OR` together are confusing.
Look at this:
`... WHERE major = 'CS' AND gpa > 3.5 OR major = 'Math'`

What does this mean?
* **Option 1:** (CS majors with > 3.5) OR (Math majors)?
* **Option 2:** CS majors AND ( > 3.5 GPA or Math majors)?

The database has its own rules (like PEMDAS in math), but I shouldn't rely on it. I have to use parentheses to **group my logic** and remove all doubt.

* **My Intention:** I want students in 'CS' or 'Math' *who also* have a GPA over 3.5.
* **The Query:**
    ```sql
    SELECT student_name, major, gpa
    FROM my_students
    WHERE (major = 'CS' OR major = 'Math') AND gpa > 3.5;
    ```
* **My New Motto:** When mixing `AND` and `OR`, **ALWAYS use parentheses**.

---

### 7. The `IN` Operator (The "Shortcut")

This is a "quality-of-life" command. It's a shortcut for a bunch of `OR`s.

**The Problem:** The query I just wrote is okay, but what if I want students from 4 majors?
`... WHERE major = 'CS' OR major = 'Math' OR major = 'Physics' OR major = 'Art'`
This is getting ugly and hard to read.

**The Solution:** The `IN` operator lets me check if a value is "in a list."

* **Syntax:**
    ```sql
    SELECT column_names
    FROM table_name
    WHERE column_name IN (value1, value2, value3);
    ```
* **Example:**
    This query does the *exact same thing* as that ugly `OR` query.
    ```sql
    SELECT student_name, major
    FROM my_students
    WHERE major IN ('CS', 'Math', 'Physics', 'Art');
    ```
* **Advantages:**
    * It's *way* cleaner and easier to read.
    * It's easier to add/remove items from the list.
    * The database can often run this *faster* than a long chain of `OR`s.
