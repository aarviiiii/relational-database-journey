Markdown

## My Lec 04 Notes: The CRUD Operations (Finally!)

Okay, so far I've:
* Learned *why* files are a "junk drawer" (Lec 01).
* Met the "robot librarian" (DBMS) and its "keys" (Lec 02).
* Built the empty "bookshelf" (`CREATE TABLE`) (Lec 03).

Now, it's finally time to learn what I can *do* with the data. What operations can I perform on the "books" (the data)?

This is where the most famous acronym in all of tech comes in: **CRUD**.

* **C**reate (Add a new book)
* **R**ead (Look at a book)
* **U**pdate (Fix a typo in a book)
* **D**elete (Burn the book)

These four operations are the heart of literally *every* application. A social media post? You `CREATE` it. Scrolling your feed? You're `READ`ing. Editing your profile? `UPDATE`. Deleting an old photo? `DELETE`.

This lecture, I'm focusing on the "C" and the "R".

---

### The "C" in CRUD: CREATE

This is a point of confusion I'm glad I cleared up.

* `CREATE TABLE` is **NOT** the "C" in CRUD. That's a DDL (Data Definition Language) command. That's me *building the bookshelf*.
* The "C" in CRUD is the `INSERT` command. This is a DML (Data Manipulation Language) command. This is me *putting a new book on the shelf*.

**1. `INSERT` (The "Right Way" review)**

From Lec 03, I know the "Right Way" is to always specify the columns.

```sql
INSERT INTO my_students (student_id, student_name, gpa)
VALUES (1, 'Rishi', 3.8);
```
Explanation:

- INSERT INTO my_students: I'm telling the database I want to add a new row to the my_students table.

- (student_id, student_name, gpa): I'm being specific about which columns I'm providing data for.

- VALUES (1, 'Rishi', 3.8): I'm providing the data, matching the exact order of the columns I just listed. student_id gets 1, student_name gets 'Rishi', and gpa gets 3.8.

**2. INSERT (Multiple Rows at Once)**
This is the "power user" move. If I have 3 new students to add, I don't need to run 3 separate INSERT commands. That's 3 separate trips to the database (slow).

I can "batch" them into one command. I just add a comma after each value set:


```sql
INSERT INTO my_students (student_id, student_name, gpa)
VALUES
    (2, 'Priya', 4.0),
    (3, 'Vikram', 3.5),
    (4, 'Sonia', 3.9);
```
Explanation:

- his is the same as the single INSERT, but after the VALUES keyword, I've listed three sets of values (called "tuples").

- Each set ( ) is separated by a comma.

This is way more efficient. One command, one trip to the database, three new rows added.

### The "R" in CRUD: READ
This is, without a doubt, the most important part of most applications.

**1. The Write-to-Read Ratio**
I had to think about this. A "write" is an INSERT, UPDATE, or DELETE. A "read" is a SELECT.

- My thought process: Think about an app like Instagram.

- How many times do I write? I post a picture (an INSERT) maybe once a week.

- How many times do I read? I open the app 10 times a day and scroll (SELECT) 500 posts.

My ratio is like 1:5000 (Write:Read).

**Why is this important?** It means my database's performance, my app's speed, and my user's happiness depend almost entirely on how fast I can READ (select) data.

This is why I learned about keys, indexes (later), and good table design. It's all to make SELECT queries blazing fast.

**2. The SELECT Query**
This is the command to read data. The basic syntax is:
```sql
 SELECT [what columns] FROM [what table] WHERE [what conditions];
```
**3. The * (The Lazy Button)**
I can do this:

```sql
SELECT * FROM my_students;
```
Explanation:
- SELECT *: The * (asterisk) is a wildcard that means "all columns."

- FROM my_students: I'm telling it which table to get those columns from.

- This query means: "Give me every single column from every single row in the my_students table."

- Why this is a trap (just like the lazy INSERT):

- It's Slow: My users table might have 50 columns, including password_hash, last_login_ip, created_at, etc. Do I really need to pull all that data just to show a list of usernames? No.

- It's Wasteful: I'm moving data I don't need.

- It's Brittle: (Just like the lazy INSERT trap!) If my app code is expecting 3 columns and I later add a 4th, my code might break.

- My New Motto: SELECT * is fine for me to test in Workbench, but it should NEVER be in my application's code. I will always specify the columns.



-  The "Right Way" for SELECT
```SQL
SELECT student_name, gpa FROM my_students;
```
Explanation:

- SELECT student_name, gpa: This is the "Right Way." I'm asking for only the student_name and gpa columns.

- FROM my_students: From the my_students table.

This is faster and safer. I only get the data I actually need.

### 4. My Query "Pseudocode" (How I Think vs. How I Write)
When I want data, my brain thinks in plain English. This is my "pseudocode."

My Thought: "Hey robot librarian, go to the my_students bookshelf. Look through all the books. When you're done, just tell me all the student names."

The SQL:

```SQL
SELECT student_name
FROM my_students;
```
Explanation:

- SELECT student_name: I'm saying what I want to see.

- FROM my_students: I'm saying where to look.

- The SQL is just the formal language for my thought.

- SQL's Execution Order (The Simple Version)
This is something that seems simple now but gets tricky later. I write the query in one order, but the database executes it in a specific order.

**This is the order I write (the "Human Order"):**

```SQL
(1) SELECT student_name, gpa
(2) FROM my_students;
```

- This is the order the Database runs (the "Robot Librarian's Order"):

**Step 1: FROM my_students**

-"First, I'll go get the entire my_students table. I don't care about the SELECT yet. I just need my big, raw pile of data."

**Step 2: SELECT student_name, gpa**

-"Okay, from that big pile I just got, I will now pick out only the student_name and gpa columns. I'll discard student_id and any other columns."

**Why does this matter?** This seems really simple, but it's the foundation. The database always finds the table (FROM) before it decides which columns (SELECT) to show. 