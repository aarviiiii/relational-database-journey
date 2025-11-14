# 🔗 Lecture 07: JOINs (The Relationship Magic)

## Topics I Covered

This was a huge one. I learned how to combine data from multiple tables at once, which is the core of how real-world data works.

* I learned about `JOIN` (which is really `INNER JOIN`) to combine matching rows from two tables using the `ON` keyword.
* I started using `AS` (aliases) to make my queries shorter and easier to read.
* I learned about **Self Joins**, where a table joins *itself* (and why aliases are mandatory for this).
* I practiced **chaining joins** to pull data from three or more tables at once.
* I learned about **Compound Joins** for tables that are related by a composite key (using `AND` in the `ON` clause).
* I finally understood the difference between `INNER JOIN` (the "strict bouncer") and `OUTER JOIN`s (`LEFT` and `RIGHT`), which let me include rows that *don't* have a match.

---

My detailed notes, syntax, and bouncer analogies are in `theory07.md`.