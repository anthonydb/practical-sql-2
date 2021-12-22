# Practical SQL, 2nd Edition
### A Beginner's Guide to Storytelling with Data

[Practical SQL, 2nd Edition](https://nostarch.com/practical-sql-2nd-edition/) is a beginner-friendly guide to the database programming language SQL. Author [Anthony DeBarros](https://www.anthonydebarros.com) starts with beginner SQL concepts such as queries, data types, and basic math and aggregation, and then works through intermediate and advanced topics including statistics, cleaning data, GIS, and automating tasks. Along the way, you'll use real-world data from the U.S. Census and other government agencies and learn the fundamentals of good database design. This is a book not only about SQL but about best practices for using it for thorough, accurate data analysis.

## A Note About Editions
If you're reading the first edition of the book, published in 2018, please [use the code and data in the first edition repository](https://github.com/anthonydb/practical-sql/). If the cover of your copy does not say, "2nd Edition," then you're using the first edition. 

## Who Is This Book For?

Practical SQL is ideal for beginners as well as those who know some SQL and want to go deeper. 

## Which Database Does The Book Use?

We use [PostgreSQL](https://www.postgresql.org), which is free and open source. PostgreSQL is used by some of the world's largest companies. Its SQL syntax adheres closely to the ANSI SQL standard, and the concepts you learn will apply to most database management systems, including MySQL, Oracle, SQLite, and others. Note that Microsoft SQL Server employs a variant of SQL called T-SQL, which is not covered by Practical SQL.

## What's In This Repository?

**Code**: All the SQL statements and command-line listings used in each chapter, organized by chapter folders.

**Data**: CSV and JSON files plus GIS shapefiles for you to import, also organized by chapter. **NOTE!** See the warning below about opening CSV files with Excel or text editors in the section on Getting the Code and Data.

**Exercises**: The "Try It Yourself" questions and answers for each chapter, listed separately. Try working through the questions before peeking at the answers.

**Software Installation Updates**: Over time, the instructions for installing PostgreSQL and additional components may change. You'll find updates noted at [software-installation-updates.md](https://github.com/anthonydb/practical-sql-2/blob/master/software-installation-updates.md).

**FAQ, Updates, and Errata**: Answers to frequently asked questions,  updates, and corrections are noted at [faq-updates-errata.md](https://github.com/anthonydb/practical-sql-2/blob/master/faq-updates-errata.md).

**Resources**: Updates to the book's Appendix on Additional PostgreSQL Resources at [resources.md](https://github.com/anthonydb/practical-sql-2/blob/master/resources.md).

## What's Covered in Each Chapter?

* Chapter 1: Setting Up Your Coding Environment
* Chapter 2: Creating Your First Database and Table
* Chapter 3: Beginning Data Exploration with SELECT
* Chapter 4: Understanding Data Types
* Chapter 5: Importing and Exporting Data
* Chapter 6: Basic Math and Stats with SQL
* Chapter 7: Joining Tables in a Relational Database
* Chapter 8: Table Design That Works for You
* Chapter 9: Extracting Information by Grouping and Summarizing
* Chapter 10: Inspecting and Modifying Data
* Chapter 11: Statistical Functions In SQL
* Chapter 12: Working With Dates and Times
* Chapter 13: Advanced Query Techniques
* Chapter 14: Mining Text to Find Meaningful Data
* Chapter 15: Analyzing Spatial Data with PostGIS
* Chapter 16: Working With JSON Data
* Chapter 17: Saving Time with Views, Functions, and Triggers
* Chapter 18: Using PostgreSQL from the Command Line
* Chapter 19: Maintaining Your Database
* Chapter 20: Telling Your Data's Story
* Appendix: Additional PostgreSQL Resources

## How Do I Get the Code and Data?

**Non-GitHub Users**

You can obtain all the code and data at once by downloading this repository as a .zip file. To do that:

* Click the **Code** button at top right.
* Click **Download ZIP**
* Unzip the file on your computer. Place it in a directory that's easy to remember so you can reference it during the exercises that include importing data to PostgreSQL.
* For additional instructions, please read Chapter 1 in the book.

**Warning about CSV files!**: Opening CSV files with Excel could lead to data loss. Excel will remove leading zeros from numbers that are intended to be stored as text, such as ZIP codes. To view the contents of a CSV file, only do so with a plain-text editor and be careful not to save the file in an encoding other than UTF-8.

**GitHub Users**

GitHub users may want to clone the repository locally and occasionally perform a `git pull` to receive  updates.

# Where Can I Buy the Book?

Practical SQL, 2nd Edition is [available in PDF, .mobi, .epub, and classic print formats](https://nostarch.com/practical-sql-2nd-edition/).

# How Can I Get Help?

Questions? Please open an issue in this repository by navigating to `Issues` and clicking `New Issue`. Fill out the form, and I will answer usually within 1 to 2 business days. For other types of inquiries, please email [practicalsqlbook@gmail.com](mailto:practicalsqlbook@gmail.com). 
