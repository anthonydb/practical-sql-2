--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Try It Yourself Questions and Answers
--------------------------------------------------------------


--------------------------------------------------------------
-- Chapter 1: Creating Your First Database and Table
--------------------------------------------------------------

-- 1. Imagine you're building a database to catalog all the animals at your
-- local zoo. You want one table for tracking all the kinds of animals and
-- another table to track the specifics on each animal. Write CREATE TABLE
-- statements for each table that include some of the columns you need. Why did
-- you include the columns you chose?

-- Answer (yours will vary):

-- The first table will hold the animal types and their conservation status:

CREATE TABLE animal_types (
   animal_type_id bigserial CONSTRAINT animal_types_key PRIMARY KEY,
   common_name varchar(100) NOT NULL,
   scientific_name varchar(100) NOT NULL,
   conservation_status varchar(50) NOT NULL
);

-- Note that I have added keywords on some columns that define constraints
-- such as a PRIMARY KEY. You will learn about these in Chapters 6 and 7.

-- The second table will hold data on individual animals. Note that the
-- column animal_type_id references the column of the same name in the
-- table animal types. This is a foreign key, which you will learn about in
-- Chapter 7.

CREATE TABLE menagerie (
   menagerie_id bigserial CONSTRAINT menagerie_key PRIMARY KEY,
   animal_type_id bigint REFERENCES animal_types (animal_type_id),
   date_acquired date NOT NULL,
   gender varchar(1),
   acquired_from varchar(100),
   name varchar(100),
   notes text
);

-- 2. Now create INSERT statements to load sample data into the tables.
-- How can you view the data via the pgAdmin tool?

-- Answer (again, yours will vary):

INSERT INTO animal_types (common_name, scientific_name, conservation_status)
VALUES ('Bengal Tiger', 'Panthera tigris tigris', 'Endangered'),
       ('Arctic Wolf', 'Canis lupus arctos', 'Least Concern');
-- data source: https://www.worldwildlife.org/species/directory?direction=desc&sort=extinction_status

INSERT INTO menagerie (animal_type_id, date_acquired, gender, acquired_from, name, notes)
VALUES
(1, '3/12/1996', 'F', 'Dhaka Zoo', 'Ariel', 'Healthy coat at last exam.'),
(2, '9/30/2000', 'F', 'National Zoo', 'Freddy', 'Strong appetite.');

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

--------------------------------------------------------------
-- Chapter 2: Beginning Data Exploration with SELECT
--------------------------------------------------------------

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


--------------------------------------------------------------
-- Chapter 3: Understanding Data Types
--------------------------------------------------------------

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

-- 50 characters is a reasonable length for names, and varchar() ensures you
-- will not waste space when names are shorter. Separating first and last names
-- into their own columns will let you later sort on each independently.

-- 3. Assume you have a text column that includes strings formatted as dates.
-- One of the strings is written as '4//2017'. What will happen when you try
-- to convert that string to the timestamp data type?

-- Answer: Attempting to convert a string of text that does not conform to
-- accepted date/time formats will result in an error. You can see this with
-- the below example, which tries to cast the string as a timestamp.

SELECT CAST('4//2017' AS timestamp with time zone);


--------------------------------------------------------------
-- Chapter 4: Importing and Exporting Data
--------------------------------------------------------------

-- 1. Write a WITH statement to include with COPY to handle the import of an
-- imaginary text file that has a first couple of rows that look like this:

-- id:movie:actor
-- 50:#Mission: Impossible#:Tom Cruise

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
-- and pound sign for quoting, but anything is possible.

-- 2. Using the table us_counties_2010 you created and filled in this chapter,
-- export to a CSV file the 20 counties in the United States that have the most
-- housing units. Make sure you export only each county's name, state, and
-- number of housing units. (Hint: Housing units are totaled for each county in
-- the column housing_unit_count_100_percent.

-- Answer:

COPY (
    SELECT geo_name, state_us_abbreviation, housing_unit_count_100_percent
    FROM us_counties_2010 ORDER BY housing_unit_count_100_percent DESC LIMIT 20
     )
TO 'C:\YourDirectory\us_counties_housing_export.txt'
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


--------------------------------------------------------------
-- Chapter 5: Basic Math and Stats with SQL
--------------------------------------------------------------

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

-- 2. Using the 2010 Census county data, find out which New York state county
-- has the highest percentage of the population that identified as "American
-- Indian/Alaska Native Alone." What can you learn about that county from online
-- research that explains the relatively large proportion of American Indian
-- population compared with other New York counties?

-- Answer:
-- Franklin County, N.Y., with 7.4%. The county contains the St. Regis Mohawk
-- Reservation. https://en.wikipedia.org/wiki/St._Regis_Mohawk_Reservation

SELECT geo_name,
       state_us_abbreviation,
       p0010001 AS total_population,
       p0010005 AS american_indian_alaska_native_alone,
       (CAST (p0010005 AS numeric(8,1)) / p0010001) * 100
           AS percent_american_indian_alaska_native_alone
FROM us_counties_2010
WHERE state_us_abbreviation = 'NY'
ORDER BY percent_american_indian_alaska_native_alone DESC;

-- 3. Was the 2010 median county population higher in California or New York?

-- Answer:
-- California had a median county population of 179,140.5 in 2010, almost double
-- that of New York, at 91,301. Here are two solutions:

-- First, you can find the median for each state one at a time:

SELECT percentile_cont(.5)
        WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010
WHERE state_us_abbreviation = 'NY';

SELECT percentile_cont(.5)
        WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010
WHERE state_us_abbreviation = 'CA';

-- Or both in one query (credit: https://github.com/Kennith-eng)

SELECT state_us_abbreviation,
       percentile_cont(0.5)
          WITHIN GROUP (ORDER BY p0010001) AS median
FROM us_counties_2010
WHERE state_us_abbreviation IN ('NY', 'CA')
GROUP BY state_us_abbreviation;
              
-- Finally, this query shows the median for each state:

SELECT state_us_abbreviation,
       percentile_cont(0.5)
          WITHIN GROUP (ORDER BY p0010001) AS median
FROM us_counties_2010
GROUP BY state_us_abbreviation;


--------------------------------------------------------------
-- Chapter 6: Joining Tables in a Relational Database
--------------------------------------------------------------

-- 1. The table us_counties_2010 contains 3,143 rows, and us_counties_2000 has
-- 3,141. That reflects the ongoing adjustments to county-level geographies that
-- typically result from government decision making. Using appropriate joins and
-- the NULL value, identify which counties don't exist in both tables. For fun,
-- search online to  nd out why they’re missing

-- Answers:

-- Counties that exist in 2010 data but not 2000 include five county equivalents
-- in Alaska (called boroughs) plus Broomfield County, Colorado.

SELECT c2010.geo_name,
       c2010.state_us_abbreviation,
       c2000.geo_name
FROM us_counties_2010 c2010 LEFT JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips
WHERE c2000.geo_name IS NULL;

-- Counties that exist in 2000 data but not 2010 include three county
-- equivalents in Alaska (called boroughs) plus Clifton Forge city, Virginia,
-- which gave up its independent city status in 2001:

SELECT c2010.geo_name,
       c2000.geo_name,
       c2000.state_us_abbreviation
FROM us_counties_2010 c2010 RIGHT JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips
WHERE c2010.geo_name IS NULL;

-- 2. Using either the median() or percentile_cont() functions in Chapter 5,
-- determine the median of the percent change in county population.

-- Answer: 3.2%

-- Using median():

SELECT median(round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
           / c2000.p0010001 * 100, 1 )) AS median_pct_change
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips;

-- Using percentile_cont():

SELECT percentile_cont(.5)
       WITHIN GROUP (ORDER BY round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
           / c2000.p0010001 * 100, 1 )) AS percentile_50th
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips;

-- Note: In both examples, you're finding the median of all the
-- county population percent change values.


-- 3. Which county had the greatest percentage loss of population between 2000
-- and 2010? Do you have any idea why? Hint: a weather event happened in 2005.

-- Answer: St. Bernard Parish, La. It and other Louisiana parishes (the county
-- equivalent name in Louisiana) experienced substantial population loss
-- following Hurricane Katrina in 2005.

SELECT c2010.geo_name,
       c2010.state_us_abbreviation,
       c2010.p0010001 AS pop_2010,
       c2000.p0010001 AS pop_2000,
       c2010.p0010001 - c2000.p0010001 AS raw_change,
       round( (CAST(c2010.p0010001 AS DECIMAL(8,1)) - c2000.p0010001)
           / c2000.p0010001 * 100, 1 ) AS pct_change
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
   AND c2010.county_fips = c2000.county_fips
ORDER BY pct_change ASC;

--------------------------------------------------------------
-- Chapter 7: Table Design that Works for You
--------------------------------------------------------------

-- Consider the following two tables from a database you’re making to keep
-- track of your vinyl LP collection. Start by reviewing these CREATE TABLE
-- statements.

-- The albums table includes information specific to the overall collection
-- of songs on the disc. The songs table catalogs each track on the album.
-- Each song has a title and its own artist column, because each song might.
-- feature its own collection of artists.

CREATE TABLE albums (
    album_id bigserial,
    album_catalog_code varchar(100),
    album_title text,
    album_artist text,
    album_time interval,
    album_release_date date,
    album_genre varchar(40),
    album_description text
);

CREATE TABLE songs (
    song_id bigserial,
    song_title text,
    song_artist text,
    album_id bigint
);

-- Use the tables to answer these questions:

-- 1. Modify these CREATE TABLE statements to include primary and foreign keys
-- plus additional constraints on both tables. Explain why you made your
-- choices.

CREATE TABLE albums (
    album_id bigserial,
    album_catalog_code varchar(100) NOT NULL,
    album_title text NOT NULL,
    album_artist text NOT NULL,
    album_release_date date,
    album_genre varchar(40),
    album_description text,
    CONSTRAINT album_id_key PRIMARY KEY (album_id),
    CONSTRAINT release_date_check CHECK (album_release_date > '1/1/1925')
);

CREATE TABLE songs (
    song_id bigserial,
    song_title text NOT NULL,
    song_artist text NOT NULL,
    album_id bigint REFERENCES albums (album_id),
    CONSTRAINT song_id_key PRIMARY KEY (song_id)
);

-- Answers:
-- a) Both tables get a primary key using surrogate key id values that are
-- auto-generated via serial data types.

-- b) The songs table references albums via a foreign key constraint.

-- c) In both tables, the title and artist columns cannot be empty, which
-- is specified via a NOT NULL constraint. We assume that every album and
-- song should at minimum have that information.

-- d) In albums, the album_release_date column has a CHECK constraint
-- because it would be likely impossible for us to own an LP made before 1925.


-- 2. Instead of using album_id as a surrogate key for your primary key, are
-- there any columns in albums that could be useful as a natural key? What would
-- you have to know to decide?

-- Answer:
-- We could consider the album_catalog_code. We would have to answer yes to
-- these questions:
-- - Is it going to be unique across all albums released by all companies?
-- - Will we always have one?


-- 3. To speed up queries, which columns are good candidates for indexes?

-- Answer:
-- Primary key columns get indexes by default, but we should add an index
-- to the album_id foreign key column in the songs table because we'll use
-- it in table joins. It's likely that we'll query these tables to search
-- by titles and artists, so those columns in both tables should get indexes
-- too. The album_release_date in albums also is a candidate if we expect
-- to perform many queries that include date ranges.


----------------------------------------------------------------
-- Chapter 8: Extracting Information by Grouping and Summarizing
----------------------------------------------------------------

-- 1. We saw that library visits have declined in most places. But what is the
-- pattern in the use of technology in libraries? Both the 2014 and 2009 library
-- survey tables contain the columns gpterms (the number of internet-connected
-- computers used by the public) and pitusr (uses of public internet computers
-- per year). Modify the code in Listing 8-13 to calculate the percent change in
-- the sum of each column over time. Watch out for negative values!

-- Answer:
-- Use sum() on gpterms (computer terminals) by state, find percent change, and
-- then sort.

SELECT pls14.stabr,
       sum(pls14.gpterms) AS gpterms_2014,
       sum(pls09.gpterms) AS gpterms_2009,
       round( (CAST(sum(pls14.gpterms) AS decimal(10,1)) - sum(pls09.gpterms)) /
                    sum(pls09.gpterms) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.gpterms >= 0 AND pls09.gpterms >= 0
GROUP BY pls14.stabr
ORDER BY pct_change DESC;

-- The query results show a consistent increase in the number of internet
-- computers used by the public in most states.

-- Use sum() on pitusr (uses of public internet computers per year) by state,
-- add percent change, and sort.

SELECT pls14.stabr,
       sum(pls14.pitusr) AS pitusr_2014,
       sum(pls09.pitusr) AS pitusr_2009,
       round( (CAST(sum(pls14.pitusr) AS decimal(10,1)) - sum(pls09.pitusr)) /
                    sum(pls09.pitusr) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.pitusr >= 0 AND pls09.pitusr >= 0
GROUP BY pls14.stabr
ORDER BY pct_change DESC;

-- The query results show most states have seen a decrease in the total uses
-- of public internet computers per year.

-- 2. Both library survey tables contain a column called obereg, a two-digit
-- Bureau of Economic Analysis Code that classifies each library agency
-- according to a region of the United States, such as New England, Rocky
-- Mountains, and so on. Just as we calculated the percent change in visits
-- grouped by state, do the same to group percent changes in visits by US
-- regions using obereg. Consult the survey documentation to find the meaning
-- of each region code. For a bonus challenge, create a table with the obereg
-- code as the primary key and the region name as text, and join it to the
-- summary query to group by the region name rather than the code.

-- Answer:

-- a) sum() visits by region.

SELECT pls14.obereg,
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY pls14.obereg
ORDER BY pct_change DESC;

-- b) Bonus: creating the regions lookup table and adding it to the query.

CREATE TABLE obereg_codes (
    obereg varchar(2) CONSTRAINT obereg_key PRIMARY KEY,
    region varchar(50)
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
       sum(pls14.visits) AS visits_2014,
       sum(pls09.visits) AS visits_2009,
       round( (CAST(sum(pls14.visits) AS decimal(10,1)) - sum(pls09.visits)) /
                    sum(pls09.visits) * 100, 2 ) AS pct_change
FROM pls_fy2014_pupld14a pls14 JOIN pls_fy2009_pupld09a pls09
   ON pls14.fscskey = pls09.fscskey
JOIN obereg_codes
   ON pls14.obereg = obereg_codes.obereg
WHERE pls14.visits >= 0 AND pls09.visits >= 0
GROUP BY obereg_codes.region
ORDER BY pct_change DESC;


-- 3. Thinking back to the types of joins you learned in Chapter 6, which join
-- type will show you all the rows in both tables, including those without a
-- match? Write such a query and add an IS NULL filter in a WHERE clause to
-- show agencies not included in one or the other table.

-- Answer: a FULL OUTER JOIN will show all rows in both tables.

SELECT pls14.libname, pls14.city, pls14.stabr, pls14.statstru, pls14.c_admin, pls14.branlib,
       pls09.libname, pls09.city, pls09.stabr, pls09.statstru, pls09.c_admin, pls09.branlib
FROM pls_fy2014_pupld14a pls14 FULL OUTER JOIN pls_fy2009_pupld09a pls09
ON pls14.fscskey = pls09.fscskey
WHERE pls14.fscskey IS NULL OR pls09.fscskey IS NULL;

-- Note: The IS NULL statements in the WHERE clause limit results to those
-- that do not appear in both tables.

--------------------------------------------------------------
-- Chapter 9: Inspecting and Modifying Data
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

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN meat_processing boolean;
ALTER TABLE meat_poultry_egg_inspect ADD COLUMN poultry_processing boolean;

SELECT * FROM meat_poultry_egg_inspect; -- view table with new empty columns

-- b) Update the columns

UPDATE meat_poultry_egg_inspect
SET meat_processing = TRUE
WHERE activities ILIKE '%meat processing%'; -- case-insensitive match with wildcards

UPDATE meat_poultry_egg_inspect
SET poultry_processing = TRUE
WHERE activities ILIKE '%poultry processing%'; -- case-insensitive match with wildcards

-- c) view the updated table

SELECT * FROM meat_poultry_egg_inspect;

-- d) Count meat and poultry processors

SELECT count(meat_processing), count(poultry_processing)
FROM meat_poultry_egg_inspect;

-- e) Count those who do both

SELECT count(*)
FROM meat_poultry_egg_inspect
WHERE meat_processing = TRUE AND
      poultry_processing = TRUE;

--------------------------------------------------------------
-- Chapter 10: Statistical Functions in SQL
--------------------------------------------------------------

-- 1. In Listing 10-2, the correlation coefficient, or r value, of the
-- variables pct_bachelors_higher and median_hh_income was about .68.
-- Write a query to show the correlation between pct_masters_higher and
-- median_hh_income. Is the r value higher or lower? What might explain
-- the difference?

-- Answer:
-- The r value of pct_bachelors_higher and median_hh_income is about .57, which
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
FROM acs_2011_2015_stats;


-- 2. In the FBI crime data, Which cities with a population of 500,000 or
-- more have the highest rates of motor vehicle thefts (column
-- motor_vehicle_theft)? Which have the highest violent crime rates
-- (column violent_crime)?

-- Answer:
-- a) In 2015, Milwaukee and Albuquerque had the two highest rates of motor
-- vehicle theft:

SELECT
    city,
    st,
    population,
    motor_vehicle_theft,
    round(
        (motor_vehicle_theft::numeric / population) * 100000, 1
        ) AS vehicle_theft_per_100000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY vehicle_theft_per_100000 DESC;

-- b) In 2015, Detroit and Memphis had the two highest rates of violent crime.

SELECT
    city,
    st,
    population,
    violent_crime,
    round(
        (violent_crime::numeric / population) * 100000, 1
        ) AS violent_crime_per_100000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY violent_crime_per_100000 DESC;

-- 3. As a bonus challenge, revisit the libraries data in the table
-- pls_fy2014_pupld14a in Chapter 8. Rank library agencies based on the rate
-- of visits per 1,000 population (variable popu_lsa), and limit the query to
-- agencies serving 250,000 people or more.

-- Answer:
-- Cuyahoga County Public Library tops the rankings with 12,963 visits per
-- thousand people (or roughly 13 visits per person).

SELECT
    libname,
    stabr,
    visits,
    popu_lsa,
    round(
        (visits::numeric / popu_lsa) * 1000, 1
        ) AS visits_per_1000,
    rank() OVER (ORDER BY (visits::numeric / popu_lsa) * 1000 DESC)
FROM pls_fy2014_pupld14a
WHERE popu_lsa >= 250000;


--------------------------------------------------------------
-- Chapter 11: Working with Dates and Times
--------------------------------------------------------------

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
FROM nyc_yellow_taxi_trips_2016_06_01
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

-- 3. As a bonus challenge, use the statistics functions in Chapter 10 to
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
FROM nyc_yellow_taxi_trips_2016_06_01
WHERE tpep_dropoff_datetime - tpep_pickup_datetime <= '3 hours'::interval;

-- Note: Both correlations are strong, with r values of 0.80 or higher. We'd
-- expect this given that cost of a taxi ride is based on both time and distance.

--------------------------------------------------------------
-- Chapter 12: Advanced Query Techniques
--------------------------------------------------------------

-- 1. Revise the code in Listing 12-15 to dig deeper into the nuances of
-- Waikiki’s high temperatures. Limit the temps_collapsed table to the Waikiki
-- maximum daily temperature observations. Then use the WHEN clauses in the
-- CASE statement to reclassify the temperatures into seven groups that would
-- result in the following text output:

-- '90 or more'
-- '88-89'
-- '86-87'
-- '84-85'
-- '82-83'
-- '80-81'
-- '79 or less'

-- In which of those groups does Waikiki’s daily maximum temperature fall most
-- often?

-- Answer: Between 86 and 87 degrees. Nice.

WITH temps_collapsed (station_name, max_temperature_group) AS
    (SELECT station_name,
           CASE WHEN max_temp >= 90 THEN '90 or more'
                WHEN max_temp BETWEEN 88 AND 89 THEN '88-89'
                WHEN max_temp BETWEEN 86 AND 87 THEN '86-87'
                WHEN max_temp BETWEEN 84 AND 85 THEN '84-85'
                WHEN max_temp BETWEEN 82 AND 83 THEN '82-83'
                WHEN max_temp BETWEEN 80 AND 81 THEN '80-81'
                WHEN max_temp <= 79 THEN '79 or less'
            END
    FROM temperature_readings
    WHERE station_name = 'WAIKIKI 717.2 HI US')

SELECT station_name, max_temperature_group, count(*)
FROM temps_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY max_temperature_group;

-- 2. Revise the ice cream survey crosstab in Listing 12-11 to flip the table.
-- In other words, make flavor the rows and office the columns. Which elements
-- of the query do you need to change? Are the counts different?

-- Answer: You need to re-order the columns in the first subquery so flavor is
-- first and office is second. count(*) stays third. Then, you must change
-- the second subquery to produce a grouped list of office. Finally, you must
-- add the office names to the output list.

-- The numbers don't change, just the order presented in the crosstab.

SELECT *
FROM crosstab('SELECT flavor,
                      office,
                      count(*)
               FROM ice_cream_survey
               GROUP BY flavor, office
               ORDER BY flavor',

              'SELECT office
               FROM ice_cream_survey
               GROUP BY office
               ORDER BY office')

AS (flavor varchar(20),
    downtown bigint,
    midtown bigint,
    uptown bigint);


-------------------------------------------------------------
-- Chapter 13: Mining Text to Find Meaningful Data
--------------------------------------------------------------

-- 1. The style guide of a publishing company you're writing for wants you to
-- avoid commas before suffixes in names. But there are several names like
-- Alvarez, Jr. and Williams, Sr. in your author database. Which functions can
-- you use to remove the comma? Would a regular expression function help?
-- How would you capture just the suffixes to place them into a separate column?

-- Answer: You can use either the standard SQL replace() function or the
-- PostgreSQL regexp_replace() function:

SELECT replace('Williams, Sr.', ', ', ' ');
SELECT regexp_replace('Williams, Sr.', ', ', ' ');

-- Answer: To capture just the suffixes, search for characters after a comma
-- and space and place those inside a match group:

SELECT (regexp_match('Williams, Sr.', '.*, (.*)'))[1];


-- 2. Using any one of the State of the Union addresses, count the number of
-- unique words that are five characters or more. Hint: you can use
-- regexp_split_to_table() in a subquery to create a table of words to count.
-- Bonus: remove commas and periods at the end of each word.

-- Answer:

WITH
    word_list (word)
AS
    (
        SELECT regexp_split_to_table(speech_text, '\s') AS word
        FROM president_speeches
        WHERE speech_date = '1974-01-30'
    )

SELECT lower(
               replace(replace(replace(word, ',', ''), '.', ''), ':', '')
             ) AS cleaned_word,
       count(*)
FROM word_list
WHERE length(word) >= 5
GROUP BY cleaned_word
ORDER BY count(*) DESC;

-- Note: This query uses a Common Table Expression to first separate each word
-- in the text into a separate row in a table named word_list. Then the SELECT
-- statement counts the words, which are cleaned up with two operations. First,
-- several nested replace functions remove commas, periods, and colons. Second,
-- all words are converted to lowercase so that when we count we group words
-- that may appear with various cases (e.g., "Military" and "military").


-- 3. Rewrite the query in Listing 13-25 using the ts_rank_cd() function
-- instead of ts_rank(). According to th PostgreSQL documentation, ts_rank_cd()
-- computes cover density, which takes into account how close the lexeme search
-- terms are to each other. Does using the ts_rank_cd() function significantly
-- change the results?

-- Answer:
-- The ranking does change, although the same speeches are generally
-- represented. The change might be more or less pronounced given another set
-- of texts.

SELECT president,
       speech_date,
       ts_rank_cd(search_speech_text, search_query, 2) AS rank_score
FROM president_speeches,
     to_tsquery('war & security & threat & enemy') search_query
WHERE search_speech_text @@ search_query
ORDER BY rank_score DESC
LIMIT 5;


--------------------------------------------------------------
-- Chapter 14: Analyzing Spatial Data with PostGIS
--------------------------------------------------------------

-- 1. Earlier, you found which US county has the largest area. Now,
-- aggregate the county data to find the area of each state in square
-- miles. (Use the statefp10 column in the us_counties_2010_shp table.)
-- How many states are bigger than the Yukon-Koyukuk area?

-- Answer: Just three states are bigger than Yukon-Koyukuk: Of course,
-- one is Alaska itself (FIPS 02). The other two are Texas (FIPS 48),
-- and California (FIPS 06).

SELECT statefp10 AS st,
       round (
              ( sum(ST_Area(geom::geography) / 2589988.110336))::numeric, 2
             ) AS square_miles
FROM us_counties_2010_shp
GROUP BY statefp10
ORDER BY square_miles DESC;

-- 2. Using ST_Distance(), determine how many miles separate these two farmers’
-- markets: the Oakleaf Greenmarket (9700 Argyle Forest Blvd, Jacksonville,
-- Florida) and Columbia Farmers Market (1701 West Ash Street, Columbia,
-- Missouri). You’ll need to first find the coordinates for both in the
-- farmers_markets table.
-- Tip: you can also write this query using the Common Table Expression syntax
-- you learned in Chapter 12.

-- Answer: About 851 miles.

WITH
    market_start (geog_point) AS
    (
     SELECT geog_point
     FROM farmers_markets
     WHERE market_name = 'The Oakleaf Greenmarket'
    ),
    market_end (geog_point) AS
    (
     SELECT geog_point
     FROM farmers_markets
     WHERE market_name = 'Columbia Farmers Market'
    )
SELECT ST_Distance(market_start.geog_point, market_end.geog_point) / 1609.344 -- convert to meters to miles
FROM market_start, market_end;

-- 3. More than 500 rows in the farmers_markets table are missing a value
-- in the county column, an example of dirty government data. Using the
-- us_counties_2010_shp table and the ST_Intersects() function, perform a
-- spatial join to find the missing county names based on the longitude and
-- latitude of each market. Because geog_point in farmers_markets is of the
-- geography type and its SRID is 4326, you’ll need to cast geom in the Census
-- table to the geography type and change its SRID using ST_SetSRID().

-- Answer:

SELECT census.name10,
       census.statefp10,
       markets.market_name,
       markets.county,
       markets.st
FROM farmers_markets markets JOIN us_counties_2010_shp census
    ON ST_Intersects(markets.geog_point, ST_SetSRID(census.geom,4326)::geography)
    WHERE markets.county IS NULL
ORDER BY census.statefp10, census.name10;

-- Note that this query also highlights a farmer's market that is mis-geocoded.
-- Can you spot it?

--------------------------------------------------------------
-- Chapter 15: Saving Time with Views, Functions, and Triggers
--------------------------------------------------------------

-- 1. Create a view that displays the number of New York City taxi trips per
-- hour. Use the taxi data in Chapter 11 and the query in Listing 11-8.

-- Answer:

CREATE VIEW nyc_taxi_trips_per_hour AS
    SELECT
         date_part('hour', tpep_pickup_datetime),
         count(date_part('hour', tpep_pickup_datetime))
    FROM nyc_yellow_taxi_trips_2016_06_01
    GROUP BY date_part('hour', tpep_pickup_datetime)
    ORDER BY date_part('hour', tpep_pickup_datetime);

SELECT * FROM nyc_taxi_trips_per_hour;

-- 2. In Chapter 10, you learned how to calculate rates per thousand. Turn that
-- formula into a rates_per_thousand() function that takes three arguments
-- to calculate the result: observed_number, base_number, and decimal_places.

-- Answer: This uses PL/pgSQL, but you could use a SQL function as well.

CREATE OR REPLACE FUNCTION
rate_per_thousand(observed_number numeric,
                  base_number numeric,
                  decimal_places integer DEFAULT 1)
RETURNS numeric(10,2) AS $$
BEGIN
    RETURN
        round(
        (observed_number / base_number) * 1000, decimal_places
        );
END;
$$ LANGUAGE plpgsql;

-- Test the function:

SELECT rate_per_thousand(50, 11000, 2);

-- 3. In Chapter 9, you worked with the meat_poultry_egg_inspect table that
-- listed food processing facilities. Write a trigger that automatically adds an
-- inspection date each time you insert a new facility into the table. Use the
-- inspection_date column added in Listing 9-19, and set the date to be six
-- months from the current date. You should be able to describe the steps needed
-- to implement a trigger and how the steps relate to each other.

-- Answer:
-- a) Add the column

ALTER TABLE meat_poultry_egg_inspect ADD COLUMN inspection_date date;

-- b) Create the function that the trigger will execute.

CREATE OR REPLACE FUNCTION add_inspection_date()
    RETURNS trigger AS $$
    BEGIN
       UPDATE meat_poultry_egg_inspect
       SET inspection_date = now() + '6 months'::interval; -- Here, we set the inspection date to six months in the future
    RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

-- c) Create the trigger

CREATE TRIGGER inspection_date_update
  AFTER INSERT
  ON meat_poultry_egg_inspect
  FOR EACH ROW
  EXECUTE PROCEDURE add_inspection_date();

-- d) Test the insertion of a company and examine the result

INSERT INTO meat_poultry_egg_inspect(est_number, company)
VALUES ('test123', 'testcompany');

SELECT * FROM meat_poultry_egg_inspect
WHERE company = 'testcompany';

--------------------------------------------------------------
-- Chapter 16: Using PostgreSQL From the Command Line
--------------------------------------------------------------

-- For this chapter, use psql to review any of the exercises in the book.


--------------------------------------------------------------
-- Chapter 17: Maintaining Your Database
--------------------------------------------------------------

-- To back up the gis_analysis database, use the pg_dump utility at the command line:
-- pg_dump -d gis_analysis -U [your-username] -Fc > gis_analysis_backup_custom.sql


-----------------------------------------------------------------
-- Chapter 18: Identifying and Telling the Story Behind Your Data
-----------------------------------------------------------------

-- This is a non-coding chapter.
