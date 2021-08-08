---------------------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition
-- by Anthony DeBarros

-- Chapter 5 Code Examples
----------------------------------------------------------------------------

-- Listing 5-1: Using COPY for data import
-- This is example syntax only; running it will produce an error

COPY table_name
FROM 'C:\YourDirectory\your_file.csv'
WITH (FORMAT CSV, HEADER);


-- Listing 5-2: CREATE TABLE statement for Census county population estimates
-- Data dictionary for estimates available at: https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2019/co-est2019-alldata.pdf
-- Data dictionary for additional columns at: http://www.census.gov/prod/cen2010/doc/pl94-171.pdf
-- Note: Some columns have been given more descriptive names

CREATE TABLE us_counties_pop_est_2019 (
    state_fips text,                         -- State FIPS code
    county_fips text,                        -- County FIPS code
    region smallint,                         -- Region
    state_name text,                         -- State name	
    county_name text,                        -- County name
    area_land bigint,                        -- Area (Land) in square meters
    area_water bigint,                       -- Area (Water) in square meters
    internal_point_lat numeric(10,7),        -- Internal point (latitude)
    internal_point_lon numeric(10,7),        -- Internal point (longitude)
    pop_est_2018 integer,                    -- 2018-07-01 resident total population estimate
    pop_est_2019 integer,                    -- 2019-07-01 resident total population estimate
    births_2019 integer,                     -- Births from 2018-07-01 to 2019-06-30
    deaths_2019 integer,                     -- Deaths from 2018-07-01 to 2019-06-30
    international_migr_2019 integer,         -- Net international migration from 2018-07-01 to 2019-06-30
    domestic_migr_2019 integer,              -- Net domestic migration from 2018-07-01 to 2019-06-30
    residual_2019 integer,                   -- Residual for 2018-07-01 to 2019-06-30
    CONSTRAINT counties_2019_key PRIMARY KEY (state_fips, county_fips)	
);

SELECT * FROM us_counties_pop_est_2019;

-- Listing 5-3: Importing Census data using COPY
-- Note! If you run into an import error here, be sure you downloaded the code and
-- data for the book according to the steps listed in Chapter 1.
-- Windows users: Please check the Note on PAGE XXXXXX as well.

COPY us_counties_pop_est_2019
FROM 'C:\YourDirectory\us_counties_pop_est_2019.csv'
WITH (FORMAT CSV, HEADER);

-- Checking the data

SELECT * FROM us_counties_pop_est_2019;

SELECT county_name, state_name, area_land
FROM us_counties_pop_est_2019
ORDER BY area_land DESC
LIMIT 3;

SELECT county_name, state_name, internal_point_lat, internal_point_lon
FROM us_counties_pop_est_2019
ORDER BY internal_point_lon DESC
LIMIT 5;


-- Listing 5-4: Creating a table to track supervisor salaries

CREATE TABLE supervisor_salaries (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    town text,
    county text,
    supervisor text,
    start_date text,
    salary numeric(10,2),
    benefits numeric(10,2)
);

-- Listing 5-5: Importing salaries data from CSV to three table columns

COPY supervisor_salaries (town, supervisor, salary)
FROM 'C:\YourDirectory\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- Check the data
SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;


-- Listing 5-6: Importing a subset of rows with WHERE

DELETE FROM supervisor_salaries;

COPY supervisor_salaries (town, supervisor, salary)
FROM 'C:\YourDirectory\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER)
WHERE town = 'New Brillig';

SELECT * FROM supervisor_salaries;


-- Listing 5-7: Using a temporary table to add a default value to a column during
-- import

DELETE FROM supervisor_salaries;

CREATE TEMPORARY TABLE supervisor_salaries_temp 
    (LIKE supervisor_salaries INCLUDING ALL);

COPY supervisor_salaries_temp (town, supervisor, salary)
FROM 'C:\YourDirectory\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

INSERT INTO supervisor_salaries (town, county, supervisor, salary)
SELECT town, 'Mills', supervisor, salary
FROM supervisor_salaries_temp;

DROP TABLE supervisor_salaries_temp;

-- Check the data
SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;


-- Listing 5-8: Exporting an entire table with COPY

COPY us_counties_pop_est_2019
TO 'C:\YourDirectory\us_counties_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');


-- Listing 5-9: Exporting selected columns from a table with COPY

COPY us_counties_pop_est_2019 
    (county_name, internal_point_lat, internal_point_lon)
TO 'C:\YourDirectory\us_counties_latlon_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- Listing 5-10: Exporting query results with COPY

COPY (
    SELECT county_name, state_name
    FROM us_counties_pop_est_2019
    WHERE county_name ILIKE '%mill%'
     )
TO 'C:\YourDirectory\us_counties_mill_export.csv'
WITH (FORMAT CSV, HEADER);
