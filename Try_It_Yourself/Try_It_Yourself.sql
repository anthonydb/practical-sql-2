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






