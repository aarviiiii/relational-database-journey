
## My Lec 02 Notes: Unlocking the Mystery of Keys 🔑

Alright, Lec 01 was about *why* files are a "junk drawer." Now Lec 02 is about *how* a database (our "robot librarian") actually finds anything.

It's all about **Keys**. A key is just a way to **find a specific row** and (just as importantly) **tell it apart from other rows.**

---

### 1. The Super Key (The "Over-achiever")

My first thought for finding a row is "just use all the columns!" And that's basically a Super Key.

A **Super Key** is *any set of columns* that can uniquely find a single row.

* Imagine a `Students` table: `(StudentID, Email, Name, Age)`
* A Super Key could be `(StudentID)`. (Yep, that works).
* A Super Key could *also* be `(StudentID, Name)`. (That also works, but it's overkill).
* A Super Key could *also* be `(StudentID, Name, Age, Email)`. (This will *definitely* find one row, but it's ridiculous).

The problem is that super keys are full of **redundant columns**. If `StudentID` *alone* can find the student, why am I also including `Name` and `Age`? It's like using your full passport, driver's license, and birth certificate just to check out a library book.

---

### 2. The Candidate Key (The "Minimalist")

A **Candidate Key** is a Super Key that has been to a minimalist boot camp. It's a Super Key with **zero redundant columns**. It's the *absolute bare minimum* needed to find a row.

Let's go back to our table: `(StudentID, Email, Name, Age)`
* `StudentID` is unique.
* `Email` is (or should be) unique.
* `Name` is not (there could be two "John Smiths").

So, what are our **Candidate Keys**?
1.  `(StudentID)`
2.  `(Email)`

That's it. These are the "candidates" for the main job.

> Every **Candidate Key** is a **Super Key**.
> But not every **Super Key** is a **Candidate Key**.
>
> `(StudentID, Name)` is a Super Key (it works), but it's *not* a Candidate Key (because `Name` is redundant junk).

---

### 3. The Primary Key (The "Chosen One")

The **Primary Key** is the... well... *primary* one. It's the **one Candidate Key** that I (the database designer) officially choose to be the main identifier for the table.

* I have two candidates: `(StudentID)` and `(Email)`.
* I have to pick one to be "The One."
* I'm going to choose `(StudentID)`. This is now my **Primary Key**.
* `Email` is still a Candidate Key, so I'll just mark it as `UNIQUE` (meaning, "don't allow duplicates") and call it a day.

**Why do I need a Primary Key?** Because I need *one reliable way* to find a row. It can't be null, and it *must* be unique. It's the row's permanent ID.

---

### 4. Hold On... Keys Can Be a "Team-Up" (Composite Keys)

I've been using single columns, but a key can be a **set of columns**. This is called a **Composite Key**.

* **When would I need this?** What if no *single* column is unique?
* **Example:** A `Student_Enrollment` table.
    * It has `StudentID` and `ClassID`.
    * `StudentID` will repeat (I'm in 5 classes).
    * `ClassID` will repeat (50 students are in this class).
    * But the *combination* of `(StudentID, ClassID)` is **unique**. I can only be enrolled in "History 101" *once*.
* So, in this table, the *pair* of columns `(StudentID, ClassID)` is a **Candidate Key**.
* Since it's the *only* logical Candidate Key, I'd make it the **Primary Key**.
* This means my **Primary Key** is now a **Composite Key**.

This is totally allowed for Super Keys, Candidate Keys, and Primary Keys.

---

### 5. How I Should Choose My Primary Key

So, I *can* use a composite key like `(StudentID, ClassID)` as my Primary Key.

But... should I?

That means any other table that needs to link to this one (like a `Grades` table) will need *two columns* just to make the connection. That's getting complicated.

**The ideal Primary Key is simple.**
* **Reason:** It's *fast*. Searching for one single integer (`id = 117`) is *way* faster than searching for two integers (`StudentID = 12` and `ClassID = 54`).
* **Reason:** It's *stable*. What if a student *changes* classes? That `(StudentID, ClassID)` key is now a headache.

**This leads to the best idea: The `id` column.**
Even in my `Student_Enrollment` table, I *could* just add a *new* column: `EnrollmentID`.
* `EnrollmentID` (Primary Key, auto-increments: 1, 2, 3...)
* `StudentID` (links to Students)
* `ClassID` (links to Classes)

This is the **PERFECT** Primary Key.
* It's an integer (super fast).
* It's guaranteed unique (it just keeps counting up).
* It will **never change**.
* It has **no real-world meaning** (this is called a "Surrogate Key"). Who cares what student or class it is? The "enrollment event" is ID `42`. It's beautiful.

---



### 6. Foreign Key (The "Relationship Builder") 🤝

This is the "phone-a-friend" key. It's how I link tables together.

A **Foreign Key** is just a column (or set of columns) in one table that **points to a Candidate Key (usually the PK) in another table.**

This creates a "relationship" and, more importantly, **enforces rules**.

* **Simple Example:** My `Orders` table has a `Cust_ID` column. I tell the database this `Cust_ID` is a Foreign Key that *points to* the `CustomerID` (the Primary Key) in my `Customers` table.
* **The Payoff:** Now, if I try to add an order with `Cust_ID = 99` and there *is no customer 99*... the database **REJECTS** it. This is called "referential integrity," and it stops me from creating "ghost" orders.

* **Composite FK:** This works for "team-up" keys, too. If my `Grades` table needs to link to my `Student_Enrollment` table (which has a `(StudentID, ClassID)` composite PK), my `Grades` table will have a **composite Foreign Key** of `(f_StudentID, f_ClassID)` that points to that pair.

* **Myth-Busting Time!**
    * **Myth:** I thought a Foreign Key *must* point to a Primary Key.
    * **BUSTED:** It just has to point to a **guaranteed unique** key. This is the Primary Key 99% of the time, but it *could* also point to another Candidate Key that has a `UNIQUE` constraint.

---

### 7. What if I Delete/Update Something? (The Rules)

What happens if I try to delete/Update a `Customer` (from the simple example) who has 10 `Orders`? The `Cust_ID` in the `Orders` table will be pointing to... nothing. A ghost. That's bad.

My database has rules for this:

* **CASCADE:** The "Domino Effect." If I delete/Updates the `Customer`, the database **automatically deletes/Updates all 10 of their orders.** This is powerful and... honestly, a little scary.

* **NO ACTION / NOT ALLOW / RESTRICT:** (They're all pretty much the same). This is "The Bouncer." The database *stops me*. It throws an error: "HEY! You can't delete/Update this customer. They still have orders. Go delete/Update those orders *first*." This is the safest option and usually the default.


