---------------------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition
-- by Anthony DeBarros

-- Chapter 7 Code Examples
----------------------------------------------------------------------------


-- Listing 7-1: Creating the departments and employees tables

CREATE TABLE departments (
    dept_id integer,
    dept text,
    city text,
    CONSTRAINT dept_key PRIMARY KEY (dept_id),
    CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE employees (
    emp_id integer,
    first_name text,
    last_name text,
    salary numeric(10,2),
    dept_id integer REFERENCES departments (dept_id),
    CONSTRAINT emp_key PRIMARY KEY (emp_id)
);

INSERT INTO departments
VALUES
    (1, 'Tax', 'Atlanta'),
    (2, 'IT', 'Boston');

INSERT INTO employees
VALUES
    (1, 'Julia', 'Reyes', 115300, 1),
    (2, 'Janet', 'King', 98000, 1),
    (3, 'Arthur', 'Pappas', 72700, 2),
    (4, 'Michael', 'Taylor', 89500, 2);

-- Listing 7-2: Joining the employees and departments tables

SELECT *
FROM employees JOIN departments
ON employees.dept_id = departments.dept_id
ORDER BY employees.dept_id;

-- Listing 7-3: Creating two tables to explore JOIN types

CREATE TABLE district_2020 (
    id integer CONSTRAINT id_key_2020 PRIMARY KEY,
    school_2020 text
);

CREATE TABLE district_2035 (
    id integer CONSTRAINT id_key_2035 PRIMARY KEY,
    school_2035 text
);

INSERT INTO district_2020 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (5, 'Dover Middle School'),
    (6, 'Webutuck High School');

INSERT INTO district_2035 VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (3, 'Morrison Elementary'),
    (4, 'Chase Magnet Academy'),
    (6, 'Webutuck High School');

-- Listing 7-4: Using JOIN

SELECT *
FROM district_2020 JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- Bonus: Also can be specified as INNER JOIN
SELECT *
FROM district_2020 INNER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- Listing 7-5: JOIN with USING

SELECT *
FROM district_2020 JOIN district_2035
USING (id)
ORDER BY district_2020.id;

-- Listing 7-6: Using LEFT JOIN

SELECT *
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- Listing 7-7: Using RIGHT JOIN

SELECT *
FROM district_2020 RIGHT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2035.id;

-- Listing 7-8: Using FULL OUTER JOIN

SELECT *
FROM district_2020 FULL OUTER JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- Listing 7-9: Using CROSS JOIN

SELECT *
FROM district_2020 CROSS JOIN district_2035
ORDER BY district_2020.id, district_2035.id;

-- Alternately, a CROSS JOIN can be written with a comma-join syntax:
SELECT *
FROM district_2020, district_2035
ORDER BY district_2020.id, district_2035.id;

-- Or it can be written as a JOIN with true in the ON clause:
SELECT *
FROM district_2020 JOIN district_2035 ON true
ORDER BY district_2020.id, district_2035.id;

-- Listing 7-10: Filtering to show missing values with IS NULL

SELECT *
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
WHERE district_2035.id IS NULL;

-- alternately, with a RIGHT JOIN
SELECT *
FROM district_2020 RIGHT JOIN district_2035
ON district_2020.id = district_2035.id
WHERE district_2020.id IS NULL;

-- Listing 7-11: Querying specific columns in a join

SELECT district_2020.id,
       district_2020.school_2020,
       district_2035.school_2035
FROM district_2020 LEFT JOIN district_2035
ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- Listing 7-12: Simplifying code with table aliases

SELECT d20.id,
       d20.school_2020,
       d35.school_2035
FROM district_2020 AS d20 LEFT JOIN district_2035 AS d35
ON d20.id = d35.id
ORDER BY d20.id;

-- Listing 7-13: Joining multiple tables

CREATE TABLE district_2020_enrollment (
    id integer,
    enrollment integer
);

CREATE TABLE district_2020_grades (
    id integer,
    grades varchar(10)
);

INSERT INTO district_2020_enrollment
VALUES
    (1, 360),
    (2, 1001),
    (5, 450),
    (6, 927);

INSERT INTO district_2020_grades
VALUES
    (1, 'K-3'),
    (2, '9-12'),
    (5, '6-8'),
    (6, '9-12');

SELECT d20.id,
       d20.school_2020,
       en.enrollment,
       gr.grades
FROM district_2020 AS d20 JOIN district_2020_enrollment AS en
    ON d20.id = en.id
JOIN district_2020_grades AS gr
    ON d20.id = gr.id
ORDER BY d20.id;

-- Listing 7-14: Combining query results with UNION

SELECT * FROM district_2020
UNION
SELECT * FROM district_2035
ORDER BY id;

-- Listing 7-15: Combining query results with UNION ALL

SELECT * FROM district_2020
UNION ALL
SELECT * FROM district_2035
ORDER BY id;

-- Listing 7-16: Customizing a UNION query

SELECT '2020' AS year,
       school_2020 AS school
FROM district_2020
UNION ALL
SELECT '2035' AS year,
       school_2035
FROM district_2035
ORDER BY school, year;

-- Listing 7-17: Combining query results with INTERSECT and EXCEPT

SELECT * FROM district_2020
INTERSECT
SELECT * FROM district_2035
ORDER BY id;

SELECT * FROM district_2020
EXCEPT
SELECT * FROM district_2035
ORDER BY id;

-- Listing 7-18: Performing math on joined Census population estimates tables

CREATE TABLE us_counties_pop_est_2010 (
    state_fips text,                         -- State FIPS code
    county_fips text,                        -- County FIPS code
    region smallint,                         -- Region
    state_name text,                         -- State name
    county_name text,                        -- County name
    estimates_base_2010 integer,             -- 4/1/2010 resident total population estimates base
    CONSTRAINT counties_2010_key PRIMARY KEY (state_fips, county_fips)
);

COPY us_counties_pop_est_2010
FROM 'C:\YourDirectory\us_counties_pop_est_2010.csv'
WITH (FORMAT CSV, HEADER);

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
ORDER BY pct_change DESC;
