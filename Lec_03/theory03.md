## My Lec 03 Notes: Getting My Hands Dirty (Setup & Sakila)

Alright, the first two lectures were all theory. Now it's time to actually... you know... *do stuff*. This is the "installing the video game" part of the journey.

---

### 1. The "Boring But Necessary" Setup

I can't just *will* a database into existence. I had to install the actual software.

* **MySQL Server:** This is the "brain." It's the engine that actually runs in the background, manages the data, and does all the hard work.
* **MySQL Workbench:** This is the "pretty face" (the GUI). It's where I can visually see my tables, run queries, and not feel like a 1980s hacker.
* **MySQL Shell:** This is the "hacker terminal" (the CLI). I'll probably use Workbench more, but it's good to know this exists for "real" server stuff.

After installing, the main task was getting **Workbench to connect to my Server**. It's like plugging the TV into the game console. Once I saw that "Connected" checkmark, I knew I was in business.

---

### 2. I Have No Data. (Why I Need a Playground)

I opened Workbench, and... it's empty. A blank void.

This is a problem. How am I supposed to practice finding "all customers who rented an action movie in July" if I don't *have* any customers, movies, or rentals?

It's like trying to learn to cook without any ingredients. I can't even practice a any kind of query!

To get good at queries, I need a *lot* of data, with complex, pre-linked tables. I need a digital playground.

---

### 3. Enter: The Sakila Database

This is the solution. The **Sakila Database** is a legendary sample database from MySQL.

**What is it?** It's a **fake movie rental store** (like a digital Blockbuster, R.I.P.).

It's *perfect* for learning because it's not just one or two simple tables. It's got everything:
* `film` table
* `actor` table
* `customer` table
* `rental` table
* `payment` table
...and a bunch more. It's all pre-linked with foreign keys. This is the ultimate playground.

**How I Set It Up:**
I had to download the Sakila setup files (a `.sql` script) from the MySQL website. Then, in Workbench, I just opened that script and hit the "Execute" (lightning bolt) button. It ran for a minute, and *poof*... I had a fully-stocked movie store.

---



### 4. What is a Data Type (And Why It's Important)?

A **Data Type** is a rule I set on a column. It's like choosing the right "container" for the data.
* **`INT`**: For whole numbers.
* **`VARCHAR(100)`**: For text (up to 100 chars).
* **`DECIMAL(3, 2)`**: For precise numbers like `3.85`.

**Why it's important:** It's my **first line of defense against garbage data**. This "Data Type Cop" stops me from accidentally putting a *name* (`'Rishi'`) in an `age` column, forcing my data to be clean.

---

### 5. The "Column Bouncers" (Constraints Explained)

"Constraints" are the *real* rules (the bouncers) at my column's door to ensure the data is valid.

* **`NULL` (The "Rule of No Rules"):**
    * Means "empty," "unknown," or "N/A." It's *not* `0` or an empty space. This is the default.

* **`NOT NULL` (The Tough Bouncer):**
    * The rule: "You *must* provide a value. This cannot be empty."
    * The database **REJECTS** the new row if this column is left blank.

* **`UNIQUE` (The "One-of-a-Kind" Bouncer):**
    * The rule: "No duplicates allowed."
    * It checks all other rows, and if it finds the value already exists... **REJECTED.**

* **`DEFAULT` (The "Helpful Assistant" Bouncer):**
    * The rule: "If you show up empty-handed, I'll give you this value."
    * e.g., `major VARCHAR(50) DEFAULT 'Undecided'`. If I don't provide a major, it automatically fills this in.

---

### 6. The `INSERT` Trap: "Order of Columns vs. Order of Values"

This is the concept that will *definitely* break my code if I'm not careful.

### The "Right Way" (Specifying Columns)
This is the smart, safe, and "future-proof" way. I explicitly tell the database which column gets which value.

```sql
INSERT INTO my_students (student_id, student_name, gpa)
VALUES (1, 'Rishi', 3.8);
```
### 7. `CREATE TABLE` (The Blueprint)

Playing with Sakila is great, but I need to build my own sandbox. Time to make a new table. The `CREATE TABLE` command is my blueprint.

This is where I define the **columns** and the **rules** for those columns.

```sql
CREATE TABLE my_students (
    student_id INT,
    student_name VARCHAR(100),
    gpa DECIMAL(3, 2)
);
```



