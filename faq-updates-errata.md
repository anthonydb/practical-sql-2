## Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition

### FAQ, Updates, and Errata

This page contains answers to Frequently Asked Questions, updates to material and URLs, and errata for Practical SQL, 2nd Edition.


### Introduction

None yet


### Chapter 1: Setting Up Your Coding Environment

**Page 3: Downloading Code and Data from GitHub**

The GitHub folder name has been renamed to `practical-sql-2-main` from `practical-sql-2-master` in line with GitHub conventions. 

**Page 13: pgAdmin Dialog to Create Server**

The location of the pgAdmin dialog to add a server has changed. Now, in the object browser, right-click `Servers` and then click `Register` > `Server`. The remaining steps in the Note on page 13 are the same. (Formerly, the dialog was accessed by right-clicking `Servers` and selecting `Create` > `Server`.)

**Page 15, Figure 1-5: pgAdmin Query Tool**

Version 6.9 of pgAdmin, released in May 2022, introduced a redesigned Query Tool Layout. General functionality is the same, but if you are using version 6.9 or later, you will see that some menu icons shown in the book at the top of the window are now placed atop the results grid. 

### Chapter 2: Creating Your First Database and Table

None yet

### Chapter 3: Beginning Data Exploration with SELECT

None yet

### Chapter 4: Understanding Data Types

None yet


### Chapter 5: Importing and Exporting Data

**Page 65, Understanding Census Columns and Data Types**

The URL for the 2010 Census technical documentation has been moved to [https://www2.census.gov/programs-surveys/decennial/rdo/about/2010-census-programs/2010Census_pl94-171_techdoc.pdf](https://www2.census.gov/programs-surveys/decennial/rdo/about/2010-census-programs/2010Census_pl94-171_techdoc.pdf)


### Chapter 6: Basic Math and Stats with SQL

None yet

### Chapter 7: Joining Tables in a Relational Database

None yet

### Chapter 8: Table Design That Works for You

None yet

### Chapter 9: Extracting Information by Grouping and Summarizing

None yet

### Chapter 10: Inspecting and Modifying Data

None yet

### Chapter 11: Statistical Functions in SQL

None yet

### Chapter 12: Working With Dates and Times

None yet

### Chapter 13: Advanced Query Techniques

None yet

### Chapter 14: Mining Text to Find Meaningful Data

**Pages 253, etc.: Turning Text to Data with Regular Expression Functions**

The dates of crimes in this section are in the format MM/DD/YY. If your database has a `datestyle` setting other than `MDY` -- for example if you're in Europe -- then you will likely need to set your `datestyle` to complete the examples.

Check your `datestyle` by running this query in pgAdmin:

```
SHOW datestyle;
```

If the result is other than `ISO, MDY`, you can set the `datestyle` on a per-session basis by running this command:

```
SET datestyle to "ISO, MDY";
```
You can then complete the examples. The change will persist until you restart pgAdmin.


### Chapter 15: Analyzing Spatial Data with PostGIS

**Pages 282, etc.: Geometry Viewer Results Grid Icon**

Beginning with version 6.9 of pgAdmin, released in May 2022, the icon to launch the Geometry Viewer in the result column header was changed from an eye to a map (makes sense). On Page 282 and later in the book, I mention clicking the eye icon to launch the viewer. Now, instead, click the map icon.


### Chapter 16: Working With JSON Data

None yet

### Chapter 17: Saving Time with Views, Functions, and Triggers

None yet

### Chapter 18: Using PostgreSQL from the Command Line

None yet

### Chapter 19: Maintaining Your Database

None yet

### Index

**Page 417: IN comparison operator**

The entry should reference pages 36, 172, 229.



