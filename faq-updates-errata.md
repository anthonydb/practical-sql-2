## Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition

### FAQ, Updates, and Errata

This page contains answers to Frequently Asked Questions, updates to material and URLs, and errata for Practical SQL, 2nd Edition. Some of these apply to the first couple of printings of the book and may be corrected if you have a third printing or later. Check the copyright page to see which printing you have.


### Introduction

* No updates


### Chapter 1: Setting Up Your Coding Environment

* **Page 3: Downloading Code and Data from GitHub**

> The GitHub folder name has been renamed to `practical-sql-2-main` from `practical-sql-2-master` in line with GitHub conventions. (Applies only to first printing of the book.)

* **Pages 6 and 7: Configuring Python language support (Windows)**

> Note that the current version of the EDB Language Pack is updated from the version shown in the book. Use the folder and version name provided via the EDB Windows installer for `PATH` and `PYTHONHOME`. As of July 2023, that is `C:\edb\languagepack\v3\Python-3.10` 

* **Pages 12 and on: pgAdmin Renamed "Browser" to "Object Explorer"**

> In Figure 1-3 on page 12, and in text on that page and subsequent references, the book refers to a section of pgAdmin labeled as the "Browser" or "object browser." As of pgAdmin 4 v7.0, the user interface has changed to call that area the "Object Explorer." (Applies to first and second printings.)

* **Page 13: pgAdmin Dialog to Create Server**

> The location of the pgAdmin dialog to add a server has changed. Now, in the object browser, right-click `Servers` and then click `Register` > `Server`. The remaining steps in the Note on page 13 are the same. (Formerly, the dialog was accessed by right-clicking `Servers` and selecting `Create` > `Server`.) (Applies only to first printing of the book.)

* **Page 15, Figure 1-5: pgAdmin Query Tool**

> Version 6.9 of pgAdmin, released in May 2022, introduced a redesigned Query Tool Layout. General functionality is the same, but if you are using version 6.9 or later, you will see that some menu icons shown in the book at the top of the window are now placed atop the results grid. (Applies only to first printing of the book.)

### Chapter 2: Creating Your First Database and Table

* No updates

### Chapter 3: Beginning Data Exploration with SELECT

* No updates

### Chapter 4: Understanding Data Types

* No updates


### Chapter 5: Importing and Exporting Data

* **Page 65, Understanding Census Columns and Data Types**

> The URL for the 2010 Census technical documentation has been moved to [https://www2.census.gov/programs-surveys/decennial/rdo/about/2010-census-programs/2010Census_pl94-171_techdoc.pdf](https://www2.census.gov/programs-surveys/decennial/rdo/about/2010-census-programs/2010Census_pl94-171_techdoc.pdf)


### Chapter 6: Basic Math and Stats with SQL

* No updates

### Chapter 7: Joining Tables in a Relational Database

* No updates

### Chapter 8: Table Design That Works for You

* No updates

### Chapter 9: Extracting Information by Grouping and Summarizing

* No updates

### Chapter 10: Inspecting and Modifying Data

* **Page 180: Improving Performance When Updating Large Tables**

> The second statement in Listing 10-26 renames the copy we made with Listing 10-25 to the original name of the table. The text incorrectly says we are renaming the copy made in Listing 10-24.

### Chapter 11: Statistical Functions in SQL

* No updates

### Chapter 12: Working With Dates and Times

* **Page 214: Finding Patterns in New York City Taxi Data**

> The URL for the NYC tax trip data dictionary has moved to [https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)

### Chapter 13: Advanced Query Techniques

* **Page 240: Listing number**

> At the bottom of the page, the sentence should read, "The crosstab structure is the same as in Listing 13-17." (Applies to first and second printings.)

### Chapter 14: Mining Text to Find Meaningful Data

* **Pages 253, etc.: Turning Text to Data with Regular Expression Functions**

> The dates of crimes in this section are in the format MM/DD/YY. If your database has a `datestyle` setting other than `MDY` -- for example if you're in Europe -- then you will likely need to set your `datestyle` to complete the examples.

> Check your `datestyle` by running this query in pgAdmin:

```
SHOW datestyle;
```

> If the result is other than `ISO, MDY`, you can set the `datestyle` on a per-session basis by running this command:

```
SET datestyle to "ISO, MDY";
```
> You can then complete the examples. The change will persist until you restart pgAdmin.

* **Page 267: Creating a Table for Full-Text Search** 

> The `COPY` statement in Listing 14-18 uses an at-sign (@) for quoting, not an ampersand. 


### Chapter 15: Analyzing Spatial Data with PostGIS

* **Pages 282, etc.: Geometry Viewer Results Grid Icon**

> Beginning with version 6.9 of pgAdmin, released in May 2022, the icon to launch the Geometry Viewer in the result column header was changed from an eye to a map (makes sense). On Page 282 and later in the book, I mention clicking the eye icon to launch the viewer. Now, instead, click the map icon. (Applies to first printing of the book.)


### Chapter 16: Working With JSON Data

* No updates

### Chapter 17: Saving Time with Views, Functions, and Triggers

* No updates

### Chapter 18: Using PostgreSQL from the Command Line

* No updates

### Chapter 19: Maintaining Your Database

* No updates

### Index

* **Page 417: IN comparison operator**

> The entry should reference pages 36, 172, 229. (Applies to first printing of the book.)



