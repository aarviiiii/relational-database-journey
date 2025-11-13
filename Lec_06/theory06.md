## My Lec 06 Notes: Fancier Filters, Sorting, and the "U" in CRUD

Lec 05 was all about getting the *real* power with the `WHERE` clause. This lecture is about making that `WHERE` clause a *lot* smarter. I'm learning new operators for filtering, how to sort the results, and how to do pagination.

Oh, and I'm *finally* learning the "U" in CRUD: `UPDATE`.

---

### 1. The `BETWEEN` Operator (The "Range" Bouncer)

This is a clean shortcut. Instead of writing `gpa >= 3.5 AND gpa <= 4.0`, I can use `BETWEEN`.

* **Use:** It's for checking if a value falls *within a range*.
* **Gotcha:** It's **inclusive**, meaning it *includes* the start and end values.

* **Syntax:**
    ```sql
    SELECT column_names
    FROM table_name
    WHERE column_name BETWEEN value1 AND value2;
    ```
* **Example:**
    Get all students with a GPA from 3.5 to 4.0 (inclusive).
    ```sql
    SELECT student_name, gpa
    FROM my_students
    WHERE gpa BETWEEN 3.5 AND 4.0;
    ```

---

### 2. The `LIKE` Operator (The "Pattern" Search)

This is my "search bar" operator. It's for when I *don't* know the exact value, but I know the *pattern*. It's for strings.

* **Actual Use:** Finding a student named "John" (or "Jon"), or finding all users with a `@gmail.com` email address.

* **Syntax:**
    ```sql
    SELECT column_names
    FROM table_name
    WHERE column_name LIKE 'pattern';
    ```

To build the 'pattern', I use two special wildcards:

#### A) The `%` (Percent) Wildcard
* **What it is:** A placeholder for **zero, one, or *many*** characters.
* **Example 1: Starts With**
    Find all students whose name *starts with* 'S'.
    ```sql
    SELECT student_name FROM my_students
    WHERE student_name LIKE 'S%';
    ```
    *Result:* 'Sonia', 'Sam', 'Stephanie'
* **Example 2: Ends With**
    Find all students whose name *ends with* 'a'.
    ```sql
    SELECT student_name FROM my_students
    WHERE student_name LIKE '%a';
    ```
    *Result:* 'Priya', 'Sonia', 'Anika'
* **Example 3: Contains**
    Find all students whose name *contains* the letter 'a' *anywhere*.
    ```sql
    SELECT student_name FROM my_students
    WHERE student_name LIKE '%a%';
    ```
    *Result:* 'Priya', 'Vikram', 'Sonia', 'Anika', 'Sam'

#### B) The `_` (Underscore) Wildcard
* **What it is:** A placeholder for **exactly one** character.
* **Example:**
    Find all students whose name is 4 letters long and ends in 'shi'.
    ```sql
    SELECT student_name FROM my_students
    WHERE student_name LIKE '_shi';
    ```
    *Result:* 'Rishi' (It would *not* match 'Takashi', because that's 7 letters).

---

### 3. The `IS NULL` Operator (The "Empty Spot" Finder)

This was a "mind-boggling" gotcha. My first instinct was to write `WHERE major = NULL`. That **does not work**.

`NULL` isn't a *value* (like `0` or `''`). It's a *state*. It's the "unknown" or "empty" spot. The only way to check for this state is with the `IS` keyword.

* **Use:** Find all rows where a value was never provided.

* **Syntax (to find the empty ones):**
    ```sql
    SELECT column_names
    FROM table_name
    WHERE column_name IS NULL;
    ```
* **Syntax (to find the *not* empty ones):**
    ```sql
    SELECT column_names
    FROM table_name
    WHERE column_name IS NOT NULL;
    ```
* **Example:**
    Find all students who *haven't* declared a major yet.
    ```sql
    SELECT student_name, major
    FROM my_students
    WHERE major IS NULL;
    ```

---

### 4. The `ORDER BY` Clause (The "Sorter")

This is the last part of the "Robot Librarian's" execution order. After the `FROM`, `WHERE`, and `SELECT` are all done, `ORDER BY` *sorts* the final results before showing them to me.

* **Use:** To sort my results by name, date, price, etc.

* **Syntax:**
    ```sql
    SELECT column_names
    FROM table_name
    WHERE [condition]
    ORDER BY column_name [ASC | DESC];
    ```

#### Nuances: `ASC` vs. `DESC`
* **`ASC`**: **Ascending** order (A-Z, 1-10). This is the **default**, so I don't even have to type it.
* **`DESC`**: **Descending** order (Z-A, 10-1). I *must* type this one.

* **Example:**
    Get all students, sorted by their GPA from *highest to lowest*.
    ```sql
    SELECT student_name, gpa
    FROM my_students
    ORDER BY gpa DESC;
    ```

#### Nuances: Tie-Breakers
* **The Problem:** What if two students have the *exact same* GPA (e.g., 4.0)? How do I sort *them*?
* **The Solution:** I can add a *second* column to the `ORDER BY` clause. This is the **tie-breaker**.

* **Example:**
    Sort by GPA (highest first). If there's a tie, sort *those* students by their name (A-Z).
    ```sql
    SELECT student_name, gpa
    FROM my_students
    ORDER BY gpa DESC, student_name ASC;
    ```
* **The Rule:** If I *don't* specify a tie-breaker, the order of the tied rows isn't guaranteed (though it often *appears* to be sorted by the Primary Key, I shouldn't rely on it). **It's always better to be explicit.**

---

### 5. The `LIMIT` Clause (The "Page 1" Button)

This is for when I *don't* want all 10 million rows. I just want... some.

* **Need:** Imagine Google. When I search, it doesn't show me 8 billion results. It shows me 10. This is **pagination**. `LIMIT` is the tool for this. It "limits" the number of rows returned.

* **Syntax:**
    ```sql
    SELECT column_names
    FROM table_name
    ORDER BY column_name
    LIMIT number_of_rows;
    ```
* **Example:**
    I want to find my **Top 3** students by GPA.
    ```sql
    SELECT student_name, gpa
    FROM my_students
    ORDER BY gpa DESC
    LIMIT 3;
    ```
* **Result:** This gives me *only* the top 3 rows.

---

### 6. The `OFFSET` Clause (The "Page 2" Button)

This is the "lack in `LIMIT`" that you mentioned. `LIMIT 3` is great for Page 1. But how do I get **Page 2** (the *next* 3 students)?

That's what `OFFSET` does. It tells the database to "skip" a certain number of rows before it starts counting for the `LIMIT`.

* **Syntax:**
    ```sql
    SELECT column_names
    FROM table_name
    ORDER BY column_name
    LIMIT number_of_rows OFFSET number_to_skip;
    ```
* **Pagination Example (showing 3 students per page):**

    * **Page 1:** (Skip 0, Show 3)
        ```sql
        SELECT * FROM my_students ORDER BY gpa DESC
        LIMIT 3 OFFSET 0;
        ```
    * **Page 2:** (Skip 3, Show 3)
        ```sql
        SELECT * FROM my_students ORDER BY gpa DESC
        LIMIT 3 OFFSET 3;
        ```
    * **Page 3:** (Skip 6, Show 3)
        ```sql
        SELECT * FROM my_students ORDER BY gpa DESC
        LIMIT 3 OFFSET 6;
        ```

---

### 7. The `UPDATE` Command (The "U" in CRUD)

I'm finally here. The "U" in CRUD. This is how I *change* data that's already in a table.

It's a two-part command:
1.  **`UPDATE [table_name]`**: Tells the database *which* table to change.
2.  **`SET [column = new_value]`**: Tells the database *what* to change.

#### The **MOST IMPORTANT** Part: `WHERE`

If I forget the `WHERE` clause, I will change **EVERY. SINGLE. ROW.**
`UPDATE my_students SET gpa = 0;` <-- This would **set everyone's GPA to 0**. A total nightmare.

**My New Motto:** NEVER, EVER write an `UPDATE` command without writing the `WHERE` clause *first*.

* **Syntax:**
    ```sql
    UPDATE table_name
    SET column1 = new_value1, column2 = new_value2
    WHERE [condition];
    ```
* **Example:**
    Student 'Rishi' decided to change his major to 'Data Science'.
    ```sql
    UPDATE my_students
    SET major = 'Data Science'
    WHERE student_id = 1;
    ```
* **Result:** The database finds *only* the row where `student_id = 1` and changes *only* that row's `major` column to 'Data Science'. Phew.