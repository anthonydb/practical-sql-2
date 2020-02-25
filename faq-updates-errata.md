## Practical SQL: A Beginner's Guide to Storytelling with Data

### FAQ, Updates, and Errata

This page contains answers to Frequently Asked Questions, additional information, and errata related to material in Practical SQL.

### Introduction

#### Working with pgAdmin: Changes to pgAdmin app

**Browser app:** Figure 1 on page xxxiii of the Introduction shows the pgAdmin app's opening screen. Beginning with version 3.0 of pgAdmin, released in April 2018, the application loads as a tab within your default web browser. Previous versions of pgAdmin run as a standalone desktop application. All other functionality for pgAdmin described in the book remains the same. Early copies of the book show pgAdmin as a standalone app. This has been updated in more recent printings. 

**Master password:** Beginning with version 4.7 of pgAdmin, released in May 2019, the application asks you to set a "master password" that's used in addition to the database password set on installation.

**Execute/refresh button icon:** Beginning with version 4.15 of pgAdmin, the icon for the button that executes a SQL statement was changed from a lightning bolt to a "play" symbol.

### Chapter 1: Creating Your First Database and Table

**Updated execute/refresh button icon:**

Step 7 on page 4 and Step 3 on page 7 both refer to clicking a lightning bolt icon in pgAdmin to execute your SQL statements. Starting with version 4.15 of pgAdmin, the icon for the button that executes a SQL statement was changed from a lightning bolt to a "play" symbol.

### Chapter 4: Importing and Exporting Data

**Avoiding common import errors**:

Be sure to download the data files and code examples from this repo using the steps outlined on page xxvii of the book's Introduction. That is, on the [main GitHub page for this repo](https://github.com/anthonydb/practical-sql), click the `Clone or Download` button and download a ZIP file with all the materials. Trying to copy/paste from GitHub often creates problems because HTML coding can get added to the data.

In addition, avoid opening or changing CSV files with Excel or a text editor, which can lead to data loss or encoding changes. See page 135 of the book for details.

### Chapter 9: Inspecting and Modifying Data

**Updated data file**:

As of February 24, 2019, this repository contains a revised version of the CSV file `MPI_Directory_by_Establishment_Name.csv'`. The only difference between it and the original is the format of the dates in the `grant_date` column. They are now in ISO 8601 international standard format, `YYYY-MM-DD`. I made the change to accommodate international translation of Practical SQL. This change affects none of the exercises. If you would like to use the original CSV for some reason, I moved it to the [Misc folder](https://github.com/anthonydb/practical-sql/blob/master/Misc/).

### Chapter 11: Working With Dates and Times

**New data dictionary URL for taxi trip times data**

Page 182: The PDF of the data dictionary describing the columns and codes for the New York City taxi data has moved. It is now at [https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf](https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)

### Chapter 12: Advanced Query Techniques

**Errata**:

Page 195: The results shown for Listing 12-3 are correct. However, the first sentence after the results has an incorrect number. It should read, "The difference between the median and average, 72,376, is nearly three times the size of the median."

### Chapter 13: Mining Text to Find Meaningful Data

**Errata**:

Page 230: The final line in Listing 13-13 should have a space instead of a comma between the quote marks in the second argument. It should read:

`SELECT regexp_split_to_array('Phil Mike Tony Steve', ' ');`

It's correct in the code listing on GitHub [here](https://github.com/anthonydb/practical-sql/blob/master/Chapter_13/Chapter_13.sql#L223).

Page 238: The final line of Listing 13-25 is missing a semi-colon. It should read:

`LIMIT 5;`

It's correct in the code listing on GitHub [here](https://github.com/anthonydb/practical-sql/blob/master/Chapter_13/Chapter_13.sql#L349).

### Chapter 14: Analyzing Spatial Data with PostGIS

#### macOS PostGIS Shapefile and DBF Loader Exporter Unavailable

As noted on page 257 of the book, the shapefile GUI tool that's available for Windows and Linux is unfortunately no longer maintained for macOS. If that changes, I'll note here. In the meantime, use the `shp2pgsql` utility covered in Chapter 16 to load shapefiles into your database. The commands for both the Census county data and the New Mexico roads and waterways are [here](https://github.com/anthonydb/practical-sql/blob/master/Chapter_16/psql_commands.txt#L81).

### Chapter 15: Saving Time with Views, Functions, and Triggers

#### PL/Python Extension Windows Installation Error

When attempting to run the command `CREATE EXTENSION plpythonu;` from Listing 15-14 on page 281, Windows users may receive the error `could not access file "$libdir/plpython2": No such file or directory`. This means PostgreSQL was unable to find the necessary Python language files on your system.

Upon investigation, I discovered that the file `plpython3.dll` included with PostgreSQL during the EnterpriseDB Windows installation is looking for the file `python34.dll` to be present in the `C:\Windows\System32` directory. This file is included with the EDB Language Pack but not placed in that directory.

Here's how to remedy the situation. Note that you must have installed the EDB Language Pack as described on page xxx of the introduction to "Practical SQL":

* Using your File Explorer, navigate to `C:\edb\languagepack-10\x64\Python-3.4`
* Copy the file `python34.dll` (right-click and select Copy).
* Using File Explorer, navigate to `C:\Windows\System32` and paste the file.
* You then should be able to execute the command `CREATE EXTENSION plpython3u;` within your database. Note that this command is slightly different than in the book. You're naming `plpython3u` instead of `plpythonu`.
