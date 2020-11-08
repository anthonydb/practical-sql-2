---------------------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition
-- by Anthony DeBarros

-- Try It Yourself Questions and Answers
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- Chapter 1: Setting Up Your Coding Environment
----------------------------------------------------------------------------

-- There are no Try It Yourself exercises in this chapter!

----------------------------------------------------------------------------
-- Chapter 2: Creating Your First Database and Table
----------------------------------------------------------------------------

-- 1. Imagine you're building a database to catalog all the animals at your
-- local zoo. You want one table for tracking all the kinds of animals and
-- another table to track the specifics on each animal. Write CREATE TABLE
-- statements for each table that include some of the columns you need. Why did
-- you include the columns you chose?

-- Answer (yours will vary):

-- The first table will hold the animal types and their conservation status:

CREATE TABLE animal_types (
    animal_type_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    common_name text NOT NULL,
    scientific_name text NOT NULL,
    conservation_status text NOT NULL,
    CONSTRAINT common_name_unique UNIQUE (common_name)
);

-- It's OK if your answer doesn't have all the keywords in the example above. Those
-- keywords reference concepts you'll learn in later chapters, including table
-- constraints, primary keys and and IDENTITY columns. What's important is that you
-- considered the individual data items you would want to track.

-- The second table will hold data on individual animals. Note that the
-- column animal_type_id references the column of the same name in the
-- table animal types. This is a foreign key, which you will learn about in
-- Chapter 8.

CREATE TABLE menagerie (
   menagerie_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
   common_name text REFERENCES animal_types (common_name),
   date_acquired date NOT NULL,
   gender text,
   acquired_from text,
   name text,
   notes text
);

-- 2. Now create INSERT statements to load sample data into the tables.
-- How can you view the data via the pgAdmin tool?

-- Answer (again, yours will vary):

INSERT INTO animal_types (common_name, scientific_name, conservation_status)
VALUES ('Bengal Tiger', 'Panthera tigris tigris', 'Endangered'),
       ('Arctic Wolf', 'Canis lupus arctos', 'Least Concern');
-- data source: https://www.worldwildlife.org/species/directory?direction=desc&sort=extinction_status

INSERT INTO menagerie (common_name, date_acquired, gender, acquired_from, name, notes)
VALUES
('Bengal Tiger', '3/12/1996', 'F', 'Dhaka Zoo', 'Ariel', 'Healthy coat at last exam.'),
('Arctic Wolf', '9/30/2000', 'F', 'National Zoo', 'Freddy', 'Strong appetite.');

-- To view data via pgAdmin, in the object browser, right-click Tables and
-- select Refresh. Then right-click the table name and select
-- View/Edit Data > All Rows


-- 2b. Create an additional INSERT statement for one of your tables. On purpose,
-- leave out one of the required commas separating the entries in the VALUES
-- clause of the query. What is the error message? Does it help you find the
-- error in the code?

-- Answer: In this case, the error message points to the missing comma.

INSERT INTO animal_types (common_name, scientific_name, conservation_status)
VALUES ('Javan Rhino', 'Rhinoceros sondaicus' 'Critically Endangered');


----------------------------------------------------------------------------
-- Chapter 3: Beginning Data Exploration with SELECT
----------------------------------------------------------------------------

-- 1. The school district superintendent asks for a list of teachers in each
-- school. Write a query that lists the schools in alphabetical order along
-- with teachers ordered by last name A-Z.

-- Answer:

SELECT school, first_name, last_name
FROM teachers
ORDER BY school, last_name;

-- 2. Write a query that finds the one teacher whose first name starts
-- with the letter 'S' and who earns more than $40,000.

-- Answer:

SELECT first_name, last_name, school, salary
FROM teachers
WHERE first_name LIKE 'S%' -- remember that LIKE is case-sensitive!
      AND salary > 40000;

-- 3. Rank teachers hired since Jan. 1, 2010, ordered by highest paid to lowest.

-- Answer:

SELECT last_name, first_name, school, hire_date, salary
FROM teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC;


----------------------------------------------------------------------------
-- Chapter 4: Understanding Data Types
----------------------------------------------------------------------------

-- 1. Your company delivers fruit and vegetables to local grocery stores, and
-- you need to track the mileage driven by each driver each day to a tenth
-- of a mile. Assuming no driver would ever travel more than 999 miles in
-- a day, what would be an appropriate data type for the mileage column in your
-- table. Why?

-- Answer:

numeric(4,1)

-- numeric(4,1) provides four digits total (the precision) and one digit after
-- the decimal (the scale). That would allow you to store a value as large
-- as 999.9.

-- In practice, you may want to consider that the assumption on maximum miles
-- in a day could conceivably exceed 999.9 and go with the larger numeric(5,1).

-- 2. In the table listing each driver in your company, what are appropriate
-- data types for the drivers’ first and last names? Why is it a good idea to
-- separate first and last names into two columns rather than having one
-- larger name column?

-- Answer:

varchar(50)
-- or
text

-- 50 characters is a reasonable length for names, and using either varchar(50)
-- or text ensures you will not waste space when names are shorter. Using text will
-- ensure that if you run into the exceptionally rare circumstance of a name longer
-- than 50 characters, you'll be covered. Also, separating first and last names
-- into their own columns will let you later sort on each independently.


-- 3. Assume you have a text column that includes strings formatted as dates.
-- One of the strings is written as '4//2017'. What will happen when you try
-- to convert that string to the timestamp data type?

-- Answer: Attempting to convert a string of text that does not conform to
-- accepted date/time formats will result in an error. You can see this with
-- the below example, which tries to cast the string as a timestamp.

SELECT CAST('4//2021' AS timestamp with time zone);


----------------------------------------------------------------------------
-- Chapter 5: Importing and Exporting Data
----------------------------------------------------------------------------

-- 1. Write a WITH statement to include with COPY to handle the import of an
-- imaginary text file that has a first couple of rows that look like this:

id:movie:actor
50:#Mission: Impossible#:Tom Cruise

-- Answer: The WITH statement will need the options seen here:

COPY actors
FROM 'C:\YourDirectory\movies.txt'
WITH (FORMAT CSV, HEADER, DELIMITER ':', QUOTE '#');

-- If you'd like to try actually importing this data, save the data in a file
-- called movies.txt and create the actors table below. You can then run the COPY
-- statement.

CREATE TABLE actors (
    id integer,
    movie text,
    actor text
);

-- Note: You may never encounter a file that uses a colon as a delimiter and
-- pound sign for quoting, but anything is possible!


-- 2. Using the table us_counties_pop_est_2019 you created and filled in this
-- chapter, export to a CSV file the 20 counties in the United States that had
-- the most births. Make sure you export only each county’s name, state, and
-- number of births. (Hint: births are totaled for each county in the column
-- births_2019.)

-- Answer:

COPY (
    SELECT county_name, state_name, births_2019
    FROM us_counties_pop_est_2019 ORDER BY births_2019 DESC LIMIT 20
     )
TO 'C:\YourDirectory\us_counties_births_export.txt'
WITH (FORMAT CSV, HEADER);

-- Note: This COPY statement uses a SELECT statement to limit the output to
-- only the desired columns and rows.


-- 3. Imagine you're importing a file that contains a column with these values:
      -- 17519.668
      -- 20084.461
      -- 18976.335
-- Will a column in your target table with data type numeric(3,8) work for these
-- values? Why or why not?

-- Answer:
-- No, it won't. In fact, you won't even be able to create a column with that
-- data type because the precision must be larger than the scale. The correct
-- type for the example data is numeric(8,3).


----------------------------------------------------------------------------
-- Chapter 6: Basic Math and Stats with SQL
----------------------------------------------------------------------------

-- 1. Write a SQL statement for calculating the area of a circle whose radius is
-- 5 inches. Do you need parentheses in your calculation? Why or why not?

-- Answer:
-- (The formula for the area of a circle is: pi * radius squared.)

SELECT 3.14 * 5 ^ 2;

-- The result is an area of 78.5 square inches.
-- Note: You do not need parentheses because exponents and roots take precedence
-- over multiplication. However, you could include parentheses for clarity. This
-- statement produces the same result:

SELECT 3.14 * (5 ^ 2);


-- 2. Using the 2019 Census county estimates data, calculate a ratio of births to 
-- deaths for each county in New York state. Which region of the state generally
-- saw a higher ratio of births to deaths in 2019?

-- Answer:

SELECT county_name,
       state_name,
       births_2019 AS births,
       deaths_2019 AS DEATHS,
       births_2019::numeric / deaths_2019 AS birth_death_ratio
FROM us_counties_pop_est_2019
WHERE state_name = 'New York'
ORDER BY birth_death_ratio DESC;

-- Generally, counties in and around New York City had the highest ratio of births
-- to deaths in the 2019 estimates. One exception to the trend is Jefferson County,
-- which is upstate on the U.S./Canadian border.


-- 3. Was the 2019 median county population estimate higher in California or New York?

-- Answer:
-- California had a median county population estimate of 187,029 in 2019, almost double
-- that of New York, at 86,687. Here are two solutions:

-- First, you can find the median for each state one at a time:

SELECT percentile_cont(.5)
        WITHIN GROUP (ORDER BY pop_est_2019)
FROM us_counties_pop_est_2019
WHERE state_name = 'New York';

SELECT percentile_cont(.5)
        WITHIN GROUP (ORDER BY pop_est_2019)
FROM us_counties_pop_est_2019
WHERE state_name = 'California';

-- Or both in one query (credit: https://github.com/Kennith-eng)

SELECT state_name,
       percentile_cont(0.5)
          WITHIN GROUP (ORDER BY pop_est_2019) AS median
FROM us_counties_pop_est_2019
WHERE state_name IN ('New York', 'California')
GROUP BY state_name;

-- Finally, this query shows the median for each state:

SELECT state_name,
       percentile_cont(0.5)
          WITHIN GROUP (ORDER BY pop_est_2019) AS median
FROM us_counties_pop_est_2019
GROUP BY state_name;


----------------------------------------------------------------------------
-- Chapter 7: Joining Tables in a Relational Database
----------------------------------------------------------------------------

-- 1. According to the Census population estimates, which county had the
-- greatest percentage loss of population between 2010 and 2019? Try
-- an Internet search to find out what happened. (Hint: The loss is related
-- to a particular type of facility.)

-- Answer: 

-- Concho County, Texas, lost 33 percent of its population from 2010 to
-- 2019, the result of the closure of Eden Detention Center. 
-- https://www.texasstandard.org/stories/after-edens-prison-closes-what-comes-next-for-this-small-texas-town/

-- Simply use ASC in the ORDER BY clause to re-order the results, like this:
SELECT c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019 AS pop_2019,
       c2010.estimates_base_2010 AS pop_2010,
       c2019.pop_est_2019 - c2010.estimates_base_2010 AS raw_change,
       round( (c2019.pop_est_2019::numeric - c2010.estimates_base_2010)
           / c2010.estimates_base_2010 * 100, 1 ) AS pct_change       
FROM us_counties_pop_est_2019 AS c2019
    JOIN us_counties_pop_est_2010 AS c2010
ON c2019.state_fips = c2010.state_fips
    AND c2019.county_fips = c2010.county_fips
ORDER BY pct_change ASC;


-- 2. Apply the concepts you learned about UNION to create query 
-- results that merge queries of the Census county population estimates
-- for 2010 and 2019. Your results should include a column called year
-- that specifies the year of the estimate for each row in the results.

-- Answer:
-- Note that you pass a string for the year in both queries.
SELECT '2010' AS year,
       state_fips,
       county_fips,
       county_name,
       state_name,
       estimates_base_2010 AS estimate
FROM us_counties_pop_est_2010
UNION 
SELECT '2019' AS year,
       state_fips,
       county_fips,
       county_name,
       state_name,       
       pop_est_2019 AS estimate
FROM us_counties_pop_est_2019
ORDER BY state_fips, county_fips, year;


-- 3. Using the percentile_cont() function from Chapter 6,
-- determine the median of the percent change in estimated county
-- population between 2010 and 2019.

-- Answer: -0.5%

SELECT percentile_cont(.5)
       WITHIN GROUP (ORDER BY round( (c2019.pop_est_2019::numeric - c2010.estimates_base_2010)
           / c2010.estimates_base_2010 * 100, 1 )) AS percentile_50th
FROM us_counties_pop_est_2019 AS c2019
    JOIN us_counties_pop_est_2010 AS c2010
ON c2019.state_fips = c2010.state_fips
    AND c2019.county_fips = c2010.county_fips;
    

----------------------------------------------------------------------------
-- Chapter 8: Table Design That Works for You
----------------------------------------------------------------------------

-- Consider the following two tables from a database you’re making to keep
-- track of your vinyl LP collection. Start by reviewing these CREATE TABLE
-- statements.

-- The albums table includes information specific to the overall collection
-- of songs on the disc. The songs table catalogs each track on the album.
-- Each song has a title and a column for its composers, who might be 
-- different than the album artist.

CREATE TABLE albums (
    album_id bigserial,
    catalog_code varchar(100),
    title text,
    artist text,
    release_date date,
    genre varchar(40),
    description text
);

CREATE TABLE songs (
    song_id bigserial,
    title text,
    composers text,
    album_id bigint
);

-- Use the tables to answer these questions:

-- 1. Modify these CREATE TABLE statements to include primary and foreign keys
-- plus additional constraints on both tables. Explain why you made your
-- choices.

-- Answer (yours may vary slightly):

CREATE TABLE albums (
    album_id bigint GENERATED ALWAYS AS IDENTITY,
    catalog_code text NOT NULL,
    title text NOT NULL,
    artist text NOT NULL,
    release_date date,
    genre text,
    description text,
    CONSTRAINT album_id_key PRIMARY KEY (album_id),
    CONSTRAINT release_date_check CHECK (release_date > '1/1/1925')
);

CREATE TABLE songs (
    song_id bigint GENERATED ALWAYS AS IDENTITY,
    title text NOT NULL,
    composer text NOT NULL,
    album_id bigint REFERENCES albums (album_id),
    CONSTRAINT song_id_key PRIMARY KEY (song_id)
);

-- Answers:
-- a) Both tables get a primary key using surrogate key id values that are
-- auto-generated via IDENTITY.

-- b) The songs table references albums via a foreign key constraint.

-- c) In both tables, the title and artist/composer columns cannot be empty, which
-- is specified via a NOT NULL constraint. We assume that every album and
-- song should at minimum have that information.

-- d) In albums, the release_date column has a CHECK constraint
-- because it would be likely impossible for us to own an LP made before 1925.


-- 2. Instead of using album_id as a surrogate key for your primary key, are
-- there any columns in albums that could be useful as a natural key? What would
-- you have to know to decide?

-- Answer:
-- We could consider the catalog_code. We would have to answer yes to
-- these questions:
-- 1. Is it going to be unique across all albums released by all companies?
-- 2. Will an album always have a catelog code?


-- 3. To speed up queries, which columns are good candidates for indexes?

-- Answer:
-- Primary key columns get indexes by default, but we should add an index
-- to the album_id foreign key column in the songs table because we'll use
-- it in table joins. It's likely that we'll query these tables to search
-- by titles and artists, so those columns in both tables should get indexes
-- too. The release_date in albums also is a candidate if we expect
-- to perform many queries that include date ranges.


----------------------------------------------------------------------------
-- Chapter 9: Extracting Information by Grouping and Summarizing
----------------------------------------------------------------------------

-- 1. We saw that library visits have declined recently in most places. But 
-- what is the pattern in library employment? All three library survey tables
-- contain the column totstaff, which is the number of paid full-time equivalent
-- employees. Modify the code in Listings 9-13 and 9-14 to calculate the 
-- percent change in the sum of the column over time, examining all states as 
-- well as states with the most visitors. Watch out for negative values!

-- Answer (all states):

SELECT pls18.stabr,
       sum(pls18.totstaff) AS totstaff_2018,
       sum(pls17.totstaff) AS totstaff_2017,
       sum(pls16.totstaff) AS totstaff_2016,
       round( (sum(pls18.totstaff::numeric) - sum(pls17.totstaff)) /
            sum(pls17.totstaff) * 100, 1 ) AS chg_2018_17,
       round( (sum(pls17.totstaff::numeric) - sum(pls16.totstaff)) /
            sum(pls16.hrs_open) * 100, 1 ) AS chg_2017_16
FROM pls_fy2018_libraries pls18
       JOIN pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
       JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.totstaff >= 0
       AND pls17.totstaff >= 0
       AND pls16.totstaff >= 0
GROUP BY pls18.stabr
ORDER BY chg_2018_17 DESC;

-- Answer (filtered with HAVING):

SELECT pls18.stabr,
       sum(pls18.totstaff) AS totstaff_2018,
       sum(pls17.totstaff) AS totstaff_2017,
       sum(pls16.totstaff) AS totstaff_2016,
       round( (sum(pls18.totstaff::numeric) - sum(pls17.totstaff)) /
            sum(pls17.totstaff) * 100, 1 ) AS chg_2018_17,
       round( (sum(pls17.totstaff::numeric) - sum(pls16.totstaff)) /
            sum(pls16.hrs_open) * 100, 1 ) AS chg_2017_16
FROM pls_fy2018_libraries pls18
       JOIN pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
       JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.totstaff >= 0
       AND pls17.totstaff >= 0
       AND pls16.totstaff >= 0
GROUP BY pls18.stabr
HAVING sum(pls18.visits) > 50000000
ORDER BY chg_2018_17 DESC;

-- 2. The library survey tables contain a column called obereg, a two-digit
-- Bureau of Economic Analysis Code that classifies each library agency
-- according to a region of the United States, such as New England, Rocky
-- Mountains, and so on. Just as we calculated the percent change in visits
-- grouped by state, do the same to group percent changes in visits by U.S.
-- region using obereg. Consult the survey documentation to find the meaning
-- of each region code. For a bonus challenge, create a table with the obereg
-- code as the primary key and the region name as text, and join it to the
-- summary query to group by the region name rather than the code.

-- Answer:

-- a) sum() visits by region.
    
SELECT pls18.obereg,
       sum(pls18.visits) AS visits_2018,
       sum(pls17.visits) AS visits_2017,
       sum(pls16.visits) AS visits_2016,
       round( (sum(pls18.visits::numeric) - sum(pls17.visits)) /
            sum(pls17.visits) * 100, 1 ) AS chg_2018_17,
       round( (sum(pls17.visits::numeric) - sum(pls16.visits)) /
            sum(pls16.visits) * 100, 1 ) AS chg_2017_16
FROM pls_fy2018_libraries pls18
       JOIN pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
       JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.visits >= 0
       AND pls17.visits >= 0
       AND pls16.visits >= 0
GROUP BY pls18.obereg
ORDER BY chg_2018_17 DESC;

-- b) Bonus: creating the regions lookup table and adding it to the query.

CREATE TABLE obereg_codes (
    obereg text CONSTRAINT obereg_key PRIMARY KEY,
    region text
);

INSERT INTO obereg_codes
VALUES ('01', 'New England (CT ME MA NH RI VT)'),
       ('02', 'Mid East (DE DC MD NJ NY PA)'),
       ('03', 'Great Lakes (IL IN MI OH WI)'),
       ('04', 'Plains (IA KS MN MO NE ND SD)'),
       ('05', 'Southeast (AL AR FL GA KY LA MS NC SC TN VA WV)'),
       ('06', 'Soutwest (AZ NM OK TX)'),
       ('07', 'Rocky Mountains (CO ID MT UT WY)'),
       ('08', 'Far West (AK CA HI NV OR WA)'),
       ('09', 'Outlying Areas (AS GU MP PR VI)');

-- sum() visits by region.

SELECT obereg_codes.region,
       sum(pls18.visits) AS visits_2018,
       sum(pls17.visits) AS visits_2017,
       sum(pls16.visits) AS visits_2016,
       round( (sum(pls18.visits::numeric) - sum(pls17.visits)) /
            sum(pls17.visits) * 100, 1 ) AS chg_2018_17,
       round( (sum(pls17.visits::numeric) - sum(pls16.visits)) /
            sum(pls16.visits) * 100, 1 ) AS chg_2017_16
FROM pls_fy2018_libraries pls18
       JOIN pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
       JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
       JOIN obereg_codes ON pls18.obereg = obereg_codes.obereg
WHERE pls18.visits >= 0
       AND pls17.visits >= 0
       AND pls16.visits >= 0
GROUP BY obereg_codes.region
ORDER BY chg_2018_17 DESC;

-- 3. Thinking back to the types of joins you learned in Chapter 7,
-- which join type will show you all the rows in all three tables,
-- including those without a match? Write such a query and add an
-- IS NULL filter in a WHERE clause to show agencies not included
-- in one or more of the tables.

-- Answer: a FULL OUTER JOIN will show all rows in both tables.

SELECT pls18.libname, pls18.city, pls18.stabr, pls18.statstru, 
       pls17.libname, pls17.city, pls17.stabr, pls17.statstru, 
       pls16.libname, pls16.city, pls16.stabr, pls16.statstru
FROM pls_fy2018_libraries pls18
       FULL OUTER JOIN pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
       FULL OUTER JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls16.fscskey IS NULL OR pls17.fscskey IS NULL;

-- Note: The IS NULL statements in the WHERE clause limit results to those
-- that do not appear in one or more tables.

--------------------------------------------------------------
-- Chapter 10: Inspecting and Modifying Data
--------------------------------------------------------------

-- In this exercise, you’ll turn the meat_poultry_egg_inspect table into useful
-- information. You needed to answer two questions: How many of the companies
-- in the table process meat, and how many process poultry?

-- Create two new columns called meat_processing and poultry_processing. Each
-- can be of the type boolean.

-- Using UPDATE, set meat_processing = TRUE on any row where the activities
-- column contains the text 'Meat Processing'. Do the same update on the
-- poultry_processing column, but this time lookup for the text
-- 'Poultry Processing' in activities.

-- Use the data from the new, updated columns to count how many companies
-- perform each type of activity. For a bonus challenge, count how many
-- companies perform both activities.

-- Answer:
-- a) Add the columns

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN meat_processing boolean;
ALTER TABLE meat_poultry_egg_establishments ADD COLUMN poultry_processing boolean;

SELECT * FROM meat_poultry_egg_establishments; -- view table with new empty columns

-- b) Update the columns

UPDATE meat_poultry_egg_establishments
SET meat_processing = TRUE
WHERE activities ILIKE '%meat processing%'; -- case-insensitive match with wildcards

UPDATE meat_poultry_egg_establishments
SET poultry_processing = TRUE
WHERE activities ILIKE '%poultry processing%'; -- case-insensitive match with wildcards

-- c) view the updated table

SELECT * FROM meat_poultry_egg_establishments;

-- d) Count meat and poultry processors

SELECT count(meat_processing), count(poultry_processing)
FROM meat_poultry_egg_establishments;

-- e) Count those who do both

SELECT count(*)
FROM meat_poultry_egg_establishments
WHERE meat_processing = TRUE AND
      poultry_processing = TRUE;

----------------------------------------------------------------------------
-- Chapter 11: Creating Your First Database and Table
----------------------------------------------------------------------------

-- 1. In Listing 11-2, the correlation coefficient, or r value, of the
-- variables pct_bachelors_higher and median_hh_income was about .70.
-- Write a query to show the correlation between pct_masters_higher and
-- median_hh_income. Is the r value higher or lower? What might explain
-- the difference?

-- Answer:
-- The r value of pct_bachelors_higher and median_hh_income is about .60, which
-- shows a lower connection between percent master's degree or higher and
-- income than percent bachelor's degree or higher and income. One possible
-- explanation is that attaining a master's degree or higher may have a more
-- incremental impact on earnings than attaining a bachelor's degree.

SELECT
    round(
      corr(median_hh_income, pct_bachelors_higher)::numeric, 2
      ) AS bachelors_income_r,
    round(
      corr(median_hh_income, pct_masters_higher)::numeric, 2
      ) AS masters_income_r
FROM acs_2014_2018_stats;


-- 2. Using the exports data, create a 12-month rolling sum using the values
-- in the column soybeans_export_value and the query pattern from 
-- Listing 11-8. Copy and paste the results from the pgAdmin output 
-- pane and graph the values using Excel. What trend do you see?  

-- Answer: Soybean exports rose considerably during the late 2000s
-- and dropped off considerably starting in 2018 following the start of the 
-- U.S. trade war with China.

SELECT year, month, soybeans_export_value,
    round(   
       sum(soybeans_export_value) 
            OVER(ORDER BY year, month 
                 ROWS BETWEEN 11 PRECEDING AND CURRENT ROW), 0)
       AS twelve_month_avg
FROM us_exports
ORDER BY year, month;

-- 3. As a bonus challenge, revisit the libraries data in the table
-- pls_fy2018_libraries in Chapter 9. Rank library agencies based on the rate
-- of visits per 1,000 population (variable popu_lsa), and limit the query to
-- agencies serving 250,000 people or more.

-- Answer:
-- Pinellas Public Library Coop tops the rankings with 9,705 visits per
-- thousand people (or roughly 10 visits per person).

SELECT
    libname,
    stabr,
    visits,
    popu_lsa,
    round(
        (visits::numeric / popu_lsa) * 1000, 1
        ) AS visits_per_1000,
    rank() OVER (ORDER BY (visits::numeric / popu_lsa) * 1000 DESC)
FROM pls_fy2018_libraries
WHERE popu_lsa >= 250000;


----------------------------------------------------------------------------
-- Chapter 12: Working with Dates and Times
----------------------------------------------------------------------------

-- 1. Using the New York City taxi data, calculate the length of each ride using
-- the pickup and drop-off timestamps. Sort the query results from the longest
-- ride to the shortest. Do you notice anything about the longest or shortest
-- trips that you might want to ask city officials about?

-- Answer: More than 480 of the trips last more than 10 hours, which seems
-- excessive. Moreover, two records have drop-off times before the pickup time,
-- and several have pickup and drop-off times that are the same. It's worth
-- asking whether these records have timestamp errors.

SELECT
    trip_id,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    tpep_dropoff_datetime - tpep_pickup_datetime AS length_of_ride
FROM nyc_yellow_taxi_trips
ORDER BY length_of_ride DESC;

-- 2. Using the AT TIME ZONE keywords, write a query that displays the date and
-- time for London, Johannesburg, Moscow, and Melbourne the moment January 1,
-- 2100, arrives in New York City.

-- Answer:

SELECT '2100-01-01 00:00:00-05' AT TIME ZONE 'US/Eastern' AS new_york,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Europe/London' AS london,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Africa/Johannesburg' AS johannesburg,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Europe/Moscow' AS moscow,
       '2100-01-01 00:00:00-05' AT TIME ZONE 'Australia/Melbourne' AS melbourne;

-- 3. As a bonus challenge, use the statistics functions in Chapter 11 to
-- calculate the correlation coefficient and r-squared values using trip time
-- and the total_amount column in the New York City taxi data, which represents
-- total amount charged to passengers. Do the same with trip_distance and
-- total_amount. Limit the query to rides that last three hours or less.

-- Answer:

SELECT
    round(
          corr(total_amount, (
              date_part('epoch', tpep_dropoff_datetime) -
              date_part('epoch', tpep_pickup_datetime)
                ))::numeric, 2
          ) AS amount_time_corr,
    round(
        regr_r2(total_amount, (
              date_part('epoch', tpep_dropoff_datetime) -
              date_part('epoch', tpep_pickup_datetime)
        ))::numeric, 2
    ) AS amount_time_r2,
    round(
          corr(total_amount, trip_distance)::numeric, 2
          ) AS amount_distance_corr,
    round(
        regr_r2(total_amount, trip_distance)::numeric, 2
    ) AS amount_distance_r2
FROM nyc_yellow_taxi_trips
WHERE tpep_dropoff_datetime - tpep_pickup_datetime <= '3 hours'::interval;

-- Note: Both correlations are strong, with r values of 0.80 or higher. We'd
-- expect this given the cost of a taxi ride is based on both time and distance.

