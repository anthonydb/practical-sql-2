## Practical SQL: A Beginner's Guide to Storytelling with Data

[Practical SQL](https://www.nostarch.com/practicalSQL) from No Starch Press is a beginner-friendly guide to the database programming language SQL. Journalist and data analyst  [Anthony DeBarros](https://www.anthonydebarros.com) begins with SQL basics, using the free open-source database PostgreSQL and interface pgAdmin, and walks through intermediate and advanced topics including statistics, aggregation, cleaning data, GIS and automating tasks. Along the way, you'll use real-world data from the U.S. Census and other government agencies and learn the fundamentals of good database design. This book is ideal for beginners as well as those who know some SQL and want to go deeper.

Practical SQL is [available in PDF, .mobi, .epub, and classic print formats](https://www.nostarch.com/practicalSQL).

Questions? Please email [practicalsqlbook@gmail.com](mailto:practicalsqlbook@gmail.com)

## What's Here

**Code**: All the SQL statements and command-line listings used in each chapter, organized by chapter folders.

**Data**: CSV files and GIS shapefiles for you to import, also organized by chapter. **NOTE!** See the warning below about opening CSV files with Excel or text editors in the section on Getting the Code and Data.

**Exercises**: The "Try It Yourself" questions and answers for each chapter, listed separately. Try working through the questions before peeking at the answers!

**FAQ, Updates, and Errata**: Answers to frequently asked questions,  updates, and corrections are noted at [faq-updates-errata.md](https://github.com/anthonydb/practical-sql/blob/master/faq-updates-errata.md).

**Resources**: Updates to the book's Appendix on Additional PostgreSQL Resources at [resources.md](https://github.com/anthonydb/practical-sql/blob/master/resources.md).

## Chapters

* Chapter 1: Setting Up Your Environment
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
* Chapter 16: JSON
* Chapter 17: Saving Time with Views, Functions, and Triggers
* Chapter 18: Using PostgreSQL from the Command Line
* Chapter 19: Maintaining Your Database
* Chapter 20: Identifying and Telling the Story Behind Your Data
* Appendix: Additional PostgreSQL Resources

## Getting the Code and Data on Your Computer

**Non-GitHub Users**

You can obtain all the code and data at once by downloading this repository as a .zip file. To do that:

* Select the **Clone or Download** button at top right.
* Select **Download ZIP**
* Unzip the file on your computer. Place it in a directory that's easy to remember so you can reference it during the exercises that include importing data to PostgreSQL.

**Warning about CSV files!**: Opening CSV files with Excel could lead to data loss. Excel will remove leading zeros from numbers that are intended to be stored as text, such as zip codes. If you wish to view the contents of a CSV file, only do so with a plain-text editor and be careful not to save the file in an encoding other than UTF-8 (e.g., `Notepad.exe` on Windows defaults to ANSI).

**GitHub Users**

GitHub users may want to clone the repository locally and occasionally perform a `git pull` to receive any updates.
