-- ----------
-- 2
-- ----------

CREATE TABLE teachers (
    id bigserial,
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);

-- This command will remove (drop) the table.
-- DROP TABLE teachers;

-- Listing 2-3 Inserting data into the teachers table

INSERT INTO teachers (first_name, last_name, school, hire_date, salary)
VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
       ('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000),
       ('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500),
       ('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
       ('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500),
       ('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);
	   
-- ----------
-- 4
-- ----------

CREATE TABLE char_data_types (
    char_column char(10),
    varchar_column varchar(10),
    text_column text
);

INSERT INTO char_data_types
VALUES
    ('abc', 'abc', 'abc'),
    ('defghi', 'defghi', 'defghi');

-- Listing 4-2: Number data types in action

CREATE TABLE number_data_types (
    numeric_column numeric(20,5),
    real_column real,
    double_column double precision
);

INSERT INTO number_data_types
VALUES
    (.7, .7, .7),
    (2.13579, 2.13579, 2.13579),
    (2.1357987654, 2.1357987654, 2.1357987654);

-- Listing 4-3: Rounding issues with float columns
-- Assumes table created and loaded with Listing 4-2


CREATE TABLE date_time_types (
    timestamp_column timestamp with time zone,
    interval_column interval
);

INSERT INTO date_time_types
VALUES
    ('2022-12-31 01:00 EST','2 days'),
    ('2022-12-31 01:00 PST','1 month'),
    ('2022-12-31 01:00 Australia/Melbourne','1 century'),
    (now(),'1 week');

-- ----------
-- 5
-- ----------

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

-- Listing 5-3: Importing Census data using COPY
-- Note! If you run into an import error here, be sure you downloaded the code and
-- data for the book according to the steps listed in Chapter 1.
-- Windows users: Please check the Note on PAGE XXXXXX as well.

COPY us_counties_pop_est_2019
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_05/us_counties_pop_est_2019.csv'
WITH (FORMAT CSV, HEADER);

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
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_05/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- ----------
-- 6
-- ----------

CREATE TABLE percent_change (
    department text,
    spend_2019 numeric(10,2),
    spend_2022 numeric(10,2)
);

INSERT INTO percent_change
VALUES
    ('Assessor', 178556, 179500),
    ('Building', 250000, 289000),
    ('Clerk', 451980, 650000),
    ('Library', 87777, 90001),
    ('Parks', 250000, 223000),
    ('Water', 199000, 195000);

-- ----------
-- 7
-- ----------

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
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_07/us_counties_pop_est_2010.csv'
WITH (FORMAT CSV, HEADER);

-- ----------
-- 8
-- ----------

-- As a table constraint
CREATE TABLE natural_key_example (
    license_id text,
    first_name text,
    last_name text,
    CONSTRAINT license_key PRIMARY KEY (license_id)
);

-- Listing 8-2: Example of a primary key violation

INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Gem', 'Godfrey');

-- Listing 8-3: Declaring a composite primary key as a natural key

CREATE TABLE natural_key_composite_example (
    student_id text,
    school_day date,
    present boolean,
    CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
);

-- Listing 8-4: Example of a composite primary key violation
INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/22/2022', 'Y');

INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES(775, '1/23/2022', 'Y');

CREATE TABLE surrogate_key_example (
    order_number bigint GENERATED ALWAYS AS IDENTITY,
    product_name text,
    order_time timestamp with time zone,
    CONSTRAINT order_number_key PRIMARY KEY (order_number)
);

INSERT INTO surrogate_key_example (product_name, order_time)
VALUES ('Beachball Polish', '2020-03-15 09:21-07'),
       ('Wrinkle De-Atomizer', '2017-05-22 14:00-07'),
       ('Flux Capacitor', '1985-10-26 01:18:00-07');

INSERT INTO surrogate_key_example
OVERRIDING SYSTEM VALUE
VALUES (4, 'Chicken Coop', '2021-09-03 10:33-07');

ALTER TABLE surrogate_key_example ALTER COLUMN order_number RESTART WITH 5;

INSERT INTO surrogate_key_example (product_name, order_time)
VALUES ('Aloe Plant', '2020-03-15 10:09-07');

CREATE TABLE licenses (
    license_id text,
    first_name text,
    last_name text,
    CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

CREATE TABLE registrations (
    registration_id text,
    registration_date timestamp with time zone,
    license_id text REFERENCES licenses (license_id),
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Steve', 'Rothery');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '3/17/2022', 'T229901');

CREATE TABLE check_constraint_example (
    user_id bigint GENERATED ALWAYS AS IDENTITY,
    user_role text,
    salary numeric(10,2),
    CONSTRAINT user_id_key PRIMARY KEY (user_id),
    CONSTRAINT check_role_in_list CHECK (user_role IN('Admin', 'Staff')),
    CONSTRAINT check_salary_not_below_zero CHECK (salary >= 0)
);



-- Listing 8-9: UNIQUE constraint example

CREATE TABLE unique_constraint_example (
    contact_id bigint GENERATED ALWAYS AS IDENTITY,
    first_name text,
    last_name text,
    email text,
    CONSTRAINT contact_id_key PRIMARY KEY (contact_id),
    CONSTRAINT email_unique UNIQUE (email)
);

INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES ('Samantha', 'Lee', 'slee@example.org');

INSERT INTO unique_constraint_example (first_name, last_name, email)
VALUES ('Betty', 'Diaz', 'bdiaz@example.org');

CREATE TABLE not_null_example (
    student_id bigint GENERATED ALWAYS AS IDENTITY,
    first_name text NOT NULL,
    last_name text NOT NULL,
    CONSTRAINT student_id_key PRIMARY KEY (student_id)
);

-- Listing 8-11: Dropping and adding a primary key and a NOT NULL constraint

-- Drop
ALTER TABLE not_null_example DROP CONSTRAINT student_id_key;

-- Add
ALTER TABLE not_null_example ADD CONSTRAINT student_id_key PRIMARY KEY (student_id);

-- Drop
ALTER TABLE not_null_example ALTER COLUMN first_name DROP NOT NULL;

-- Add
ALTER TABLE not_null_example ALTER COLUMN first_name SET NOT NULL;


CREATE TABLE new_york_addresses (
    longitude numeric(9,6),
    latitude numeric(9,6),
    street_number text,
    street text,
    unit text,
    postcode text,
    id integer CONSTRAINT new_york_key PRIMARY KEY
);

COPY new_york_addresses
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_08/city_of_new_york.csv'
WITH (FORMAT CSV, HEADER);

CREATE INDEX street_idx ON new_york_addresses (street);

-- ----------
-- 9
-- ----------

-- Listing 9-1: Creating and filling the 2018 Public Libraries Survey table

CREATE TABLE pls_fy2018_libraries (
    stabr text NOT NULL,
    fscskey text CONSTRAINT fscskey_2018_pkey PRIMARY KEY,
    libid text NOT NULL,
    libname text NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    zip text NOT NULL,
    county text NOT NULL,
    phone text NOT NULL,
    c_relatn text NOT NULL,
    c_legbas text NOT NULL,
    c_admin text NOT NULL,
    c_fscs text NOT NULL,
    geocode text NOT NULL,
    lsabound text NOT NULL,
    startdate text NOT NULL,
    enddate text NOT NULL,
    popu_lsa integer NOT NULL,
    popu_und integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl integer NOT NULL,
    video_ph integer NOT NULL,
    video_dl integer NOT NULL,
    ec_lo_ot integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    reference integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    totpro integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    obereg text NOT NULL,
    statstru text NOT NULL,
    statname text NOT NULL,
    stataddr text NOT NULL,
    longitude numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL
);

COPY pls_fy2018_libraries
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_09/pls_fy2018_libraries.csv'
WITH (FORMAT CSV, HEADER);

CREATE INDEX libname_2018_idx ON pls_fy2018_libraries (libname);

-- Listing 9-2: Creating and filling the 2017 and 2016 Public Libraries Survey tables

CREATE TABLE pls_fy2017_libraries (
    stabr text NOT NULL,
    fscskey text CONSTRAINT fscskey_17_pkey PRIMARY KEY,
    libid text NOT NULL,
    libname text NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    zip text NOT NULL,
    county text NOT NULL,
    phone text NOT NULL,
    c_relatn text NOT NULL,
    c_legbas text NOT NULL,
    c_admin text NOT NULL,
    c_fscs text NOT NULL,
    geocode text NOT NULL,
    lsabound text NOT NULL,
    startdate text NOT NULL,
    enddate text NOT NULL,
    popu_lsa integer NOT NULL,
    popu_und integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl integer NOT NULL,
    video_ph integer NOT NULL,
    video_dl integer NOT NULL,
    ec_lo_ot integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    reference integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    totpro integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    obereg text NOT NULL,
    statstru text NOT NULL,
    statname text NOT NULL,
    stataddr text NOT NULL,
    longitude numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL
);

CREATE TABLE pls_fy2016_libraries (
    stabr text NOT NULL,
    fscskey text CONSTRAINT fscskey_16_pkey PRIMARY KEY,
    libid text NOT NULL,
    libname text NOT NULL,
    address text NOT NULL,
    city text NOT NULL,
    zip text NOT NULL,
    county text NOT NULL,
    phone text NOT NULL,
    c_relatn text NOT NULL,
    c_legbas text NOT NULL,
    c_admin text NOT NULL,
    c_fscs text NOT NULL,
    geocode text NOT NULL,
    lsabound text NOT NULL,
    startdate text NOT NULL,
    enddate text NOT NULL,
    popu_lsa integer NOT NULL,
    popu_und integer NOT NULL,
    centlib integer NOT NULL,
    branlib integer NOT NULL,
    bkmob integer NOT NULL,
    totstaff numeric(8,2) NOT NULL,
    bkvol integer NOT NULL,
    ebook integer NOT NULL,
    audio_ph integer NOT NULL,
    audio_dl integer NOT NULL,
    video_ph integer NOT NULL,
    video_dl integer NOT NULL,
    ec_lo_ot integer NOT NULL,
    subscrip integer NOT NULL,
    hrs_open integer NOT NULL,
    visits integer NOT NULL,
    reference integer NOT NULL,
    regbor integer NOT NULL,
    totcir integer NOT NULL,
    kidcircl integer NOT NULL,
    totpro integer NOT NULL,
    gpterms integer NOT NULL,
    pitusr integer NOT NULL,
    wifisess integer NOT NULL,
    obereg text NOT NULL,
    statstru text NOT NULL,
    statname text NOT NULL,
    stataddr text NOT NULL,
    longitude numeric(10,7) NOT NULL,
    latitude numeric(10,7) NOT NULL
);

COPY pls_fy2017_libraries
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_09/pls_fy2017_libraries.csv'
WITH (FORMAT CSV, HEADER);

COPY pls_fy2016_libraries
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_09/pls_fy2016_libraries.csv'
WITH (FORMAT CSV, HEADER);

CREATE INDEX libname_2017_idx ON pls_fy2017_libraries (libname);
CREATE INDEX libname_2016_idx ON pls_fy2016_libraries (libname);

-- ----------
-- 10
-- ----------

CREATE TABLE meat_poultry_egg_establishments (
    establishment_number text CONSTRAINT est_number_key PRIMARY KEY,
    company text,
    street text,
    city text,
    st text,
    zip text,
    phone text,
    grant_date date,
    activities text,
    dbas text
);

COPY meat_poultry_egg_establishments
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_10/MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER);

-- Listing 10-9: Creating and filling the st_copy column with ALTER TABLE and UPDATE

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN st_copy text;

UPDATE meat_poultry_egg_establishments
SET st_copy = st;


-- Listing 10-11: Updating the st column for three establishments

UPDATE meat_poultry_egg_establishments
SET st = 'MN'
WHERE establishment_number = 'V18677A';

UPDATE meat_poultry_egg_establishments
SET st = 'AL'
WHERE establishment_number = 'M45319+P45319';

UPDATE meat_poultry_egg_establishments
SET st = 'WI'
WHERE establishment_number = 'M263A+P263A+V263A'
RETURNING establishment_number, company, city, st, zip;

-- Listing 10-12: Restoring original st column values

-- Restoring from the column backup
UPDATE meat_poultry_egg_establishments
SET st = st_copy;

-- Restoring from the table backup
UPDATE meat_poultry_egg_establishments original
SET st = backup.st
FROM meat_poultry_egg_establishments_backup backup
WHERE original.establishment_number = backup.establishment_number; 

-- Listing 10-13: Creating and filling the company_standard column

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN company_standard text;

UPDATE meat_poultry_egg_establishments
SET company_standard = company;

-- Listing 10-14: Use UPDATE to modify column values that match a string

UPDATE meat_poultry_egg_establishments
SET company_standard = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%'
RETURNING company, company_standard;

-- Listing 10-15: Creating and filling the zip_copy column

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN zip_copy text;

UPDATE meat_poultry_egg_establishments
SET zip_copy = zip;

-- Listing 10-16: Modify codes in the zip column missing two leading zeros

UPDATE meat_poultry_egg_establishments
SET zip = '00' || zip
WHERE st IN('PR','VI') AND length(zip) = 3;

-- Listing 10-17: Modify codes in the zip column missing one leading zero

UPDATE meat_poultry_egg_establishments
SET zip = '0' || zip
WHERE st IN('CT','MA','ME','NH','NJ','RI','VT') AND length(zip) = 4;

-- Listing 10-18: Creating and filling a state_regions table

CREATE TABLE state_regions (
    st text CONSTRAINT st_key PRIMARY KEY,
    region text NOT NULL
);

COPY state_regions
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_10/state_regions.csv'
WITH (FORMAT CSV, HEADER);

-- Listing 10-19: Adding and updating an inspection_deadline column

ALTER TABLE meat_poultry_egg_establishments
    ADD COLUMN inspection_deadline timestamp with time zone;

UPDATE meat_poultry_egg_establishments establishments
SET inspection_deadline = '2022-12-01 00:00 EST'
WHERE EXISTS (SELECT state_regions.region
              FROM state_regions
              WHERE establishments.st = state_regions.st 
                    AND state_regions.region = 'New England');

-- Listing 10-21: Delete rows matching an expression

DELETE FROM meat_poultry_egg_establishments
WHERE st IN('AS','GU','MP','PR','VI');

-- Listing 10-22: Remove a column from a table using DROP

ALTER TABLE meat_poultry_egg_establishments DROP COLUMN zip_copy;

-- Listing 10-23: Remove a table from a database using DROP

DROP TABLE meat_poultry_egg_establishments_backup;

-- Listing 10-24: Demonstrating a transaction block

-- Start transaction and perform update
START TRANSACTION;

UPDATE meat_poultry_egg_establishments
SET company = 'AGRO Merchantss Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

-- view changes
SELECT company
FROM meat_poultry_egg_establishments
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- Revert changes
ROLLBACK;

-- See restored state
SELECT company
FROM meat_poultry_egg_establishments
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- Alternately, commit changes at the end:
START TRANSACTION;

UPDATE meat_poultry_egg_establishments
SET company = 'AGRO Merchants Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

COMMIT;

-- Listing 10-25: Backing up a table while adding and filling a new column

CREATE TABLE meat_poultry_egg_establishments_backup AS
SELECT *,
       '2023-02-14 00:00 EST'::timestamp with time zone AS reviewed_date
FROM meat_poultry_egg_establishments;

-- Listing 10-26: Swapping table names using ALTER TABLE

ALTER TABLE meat_poultry_egg_establishments RENAME TO meat_poultry_egg_establishments_temp;
ALTER TABLE meat_poultry_egg_establishments_backup RENAME TO meat_poultry_egg_establishments;
ALTER TABLE meat_poultry_egg_establishments_temp RENAME TO meat_poultry_egg_establishments_backup;

-- ----------
-- 11
-- ----------

-- Listing 11-1: Create Census 2014-2018 ACS 5-Year stats table and import data

CREATE TABLE acs_2014_2018_stats (
    geoid text CONSTRAINT geoid_key PRIMARY KEY,
    county text NOT NULL,
    st text NOT NULL,
    pct_travel_60_min numeric(5,2),
    pct_bachelors_higher numeric(5,2),
    pct_masters_higher numeric(5,2),
    median_hh_income integer,
    CHECK (pct_masters_higher <= pct_bachelors_higher)
);

COPY acs_2014_2018_stats
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_11/acs_2014_2018_stats.csv'
WITH (FORMAT CSV, HEADER);

CREATE TABLE widget_companies (
    id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    company text NOT NULL,
    widget_output integer NOT NULL
);

INSERT INTO widget_companies (company, widget_output)
VALUES
    ('Dom Widgets', 125000),
    ('Ariadne Widget Masters', 143000),
    ('Saito Widget Co.', 201000),
    ('Mal Inc.', 133000),
    ('Dream Widget Inc.', 196000),
    ('Miles Amalgamated', 620000),
    ('Arthur Industries', 244000),
    ('Fischer Worldwide', 201000);
	
CREATE TABLE store_sales (
    store text NOT NULL,
    category text NOT NULL,
    unit_sales bigint NOT NULL,
    CONSTRAINT store_category_key PRIMARY KEY (store, category)
);

INSERT INTO store_sales (store, category, unit_sales)
VALUES
    ('Broders', 'Cereal', 1104),
    ('Wallace', 'Ice Cream', 1863),
    ('Broders', 'Ice Cream', 2517),
    ('Cramers', 'Ice Cream', 2112),
    ('Broders', 'Beer', 641),
    ('Cramers', 'Cereal', 1003),
    ('Cramers', 'Beer', 640),
    ('Wallace', 'Cereal', 980),
    ('Wallace', 'Beer', 988);
	
CREATE TABLE cbp_naics_72_establishments (
    state_fips text,
    county_fips text,
    county text NOT NULL,
    st text NOT NULL,
    naics_2017 text NOT NULL,
    naics_2017_label text NOT NULL,
    year smallint NOT NULL,
    establishments integer NOT NULL,
    CONSTRAINT cbp_fips_key PRIMARY KEY (state_fips, county_fips)
);

COPY cbp_naics_72_establishments
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_11/cbp_naics_72_establishments.csv'
WITH (FORMAT CSV, HEADER);


CREATE TABLE us_exports (
    year smallint,
    month smallint,
    citrus_export_value bigint,	
    soybeans_export_value bigint
);

COPY us_exports
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_11/us_exports.csv'
WITH (FORMAT CSV, HEADER);

-- ----------
-- 12
-- ----------

-- Listing 12-3: Comparing current_timestamp and clock_timestamp() during row insert

CREATE TABLE current_time_example (
    time_id integer GENERATED ALWAYS AS IDENTITY,
    current_timestamp_col timestamp with time zone,
    clock_timestamp_col timestamp with time zone
);

INSERT INTO current_time_example
            (current_timestamp_col, clock_timestamp_col)
    (SELECT current_timestamp,
            clock_timestamp()
     FROM generate_series(1,1000));
	 
	 
CREATE TABLE nyc_yellow_taxi_trips (
    trip_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vendor_id text NOT NULL,
    tpep_pickup_datetime timestamp with time zone NOT NULL,
    tpep_dropoff_datetime timestamp with time zone NOT NULL,
    passenger_count integer NOT NULL,
    trip_distance numeric(8,2) NOT NULL,
    pickup_longitude numeric(18,15) NOT NULL,
    pickup_latitude numeric(18,15) NOT NULL,
    rate_code_id text NOT NULL,
    store_and_fwd_flag text NOT NULL,
    dropoff_longitude numeric(18,15) NOT NULL,
    dropoff_latitude numeric(18,15) NOT NULL,
    payment_type text NOT NULL,
    fare_amount numeric(9,2) NOT NULL,
    extra numeric(9,2) NOT NULL,
    mta_tax numeric(5,2) NOT NULL,
    tip_amount numeric(9,2) NOT NULL,
    tolls_amount numeric(9,2) NOT NULL,
    improvement_surcharge numeric(9,2) NOT NULL,
    total_amount numeric(9,2) NOT NULL
);

COPY nyc_yellow_taxi_trips (
    vendor_id,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    pickup_longitude,
    pickup_latitude,
    rate_code_id,
    store_and_fwd_flag,
    dropoff_longitude,
    dropoff_latitude,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount
   )
-- FROM 'C:\YourDirectory\nyc_yellow_taxi_trips.csv'
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_12/nyc_yellow_taxi_trips.csv'
WITH (FORMAT CSV, HEADER);

CREATE INDEX tpep_pickup_idx
ON nyc_yellow_taxi_trips (tpep_pickup_datetime);

-- Listing 12-11: Creating a table to hold train trip data

CREATE TABLE train_rides (
    trip_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    segment text NOT NULL,
    departure timestamp with time zone NOT NULL,
    arrival timestamp with time zone NOT NULL
);

INSERT INTO train_rides (segment, departure, arrival)
VALUES
    ('Chicago to New York', '2020-11-13 21:30 CST', '2020-11-14 18:23 EST'),
    ('New York to New Orleans', '2020-11-15 14:15 EST', '2020-11-16 19:32 CST'),
    ('New Orleans to Los Angeles', '2020-11-17 13:45 CST', '2020-11-18 9:00 PST'),
    ('Los Angeles to San Francisco', '2020-11-19 10:10 PST', '2020-11-19 21:24 PST'),
    ('San Francisco to Denver', '2020-11-20 9:10 PST', '2020-11-21 18:38 MST'),
    ('Denver to Chicago', '2020-11-22 19:10 MST', '2020-11-23 14:50 CST');
	
-- -----
-- 13
-- -----

CREATE TABLE us_counties_2019_top10 AS
SELECT * FROM us_counties_pop_est_2019;

DELETE FROM us_counties_2019_top10
WHERE pop_est_2019 < (
    SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY pop_est_2019)
    FROM us_counties_2019_top10
    );
	
-- Listing 13-7: Creating and filling a retirees table

CREATE TABLE retirees (
    id int,
    first_name text,
    last_name text
);

INSERT INTO retirees
VALUES (2, 'Janet', 'King'),
       (4, 'Michael', 'Taylor');
	   
-- Listing 13-12: Using a subquery with a LATERAL join

ALTER TABLE teachers ADD CONSTRAINT id_key PRIMARY KEY (id);

CREATE TABLE teachers_lab_access (
    access_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    access_time timestamp with time zone,
    lab_name text,
    teacher_id bigint REFERENCES teachers (id)
);

INSERT INTO teachers_lab_access (access_time, lab_name, teacher_id)
VALUES ('2022-11-30 08:59:00-05', 'Science A', 2),
       ('2022-12-01 08:58:00-05', 'Chemistry B', 2),
       ('2022-12-21 09:01:00-05', 'Chemistry A', 2),
       ('2022-12-02 11:01:00-05', 'Science B', 6),
       ('2022-12-07 10:02:00-05', 'Science A', 6),
       ('2022-12-17 16:00:00-05', 'Science B', 6);

CREATE TABLE ice_cream_survey (
    response_id integer PRIMARY KEY,
    office text,
    flavor text
);

COPY ice_cream_survey
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_13/ice_cream_survey.csv'
WITH (FORMAT CSV, HEADER);

-- Listing 13-18: Creating and filling a temperature_readings table

CREATE TABLE temperature_readings (
    station_name text,
    observation_date date,
    max_temp integer,
    min_temp integer,
    CONSTRAINT temp_key PRIMARY KEY (station_name, observation_date)
);

COPY temperature_readings
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_13/temperature_readings.csv'
WITH (FORMAT CSV, HEADER);

-- ----
-- 14
-- ----

-- Listing 14-5: Creating and loading the crime_reports table
-- Data from https://sheriff.loudoun.gov/dailycrime

CREATE TABLE crime_reports (
    crime_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    case_number text,
    date_1 timestamp with time zone,
    date_2 timestamp with time zone,
    street text,
    city text,
    crime_type text,
    description text,
    original_text text NOT NULL
);

COPY crime_reports (original_text)
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_14/crime_reports.csv'
WITH (FORMAT CSV, HEADER OFF, QUOTE '"');

CREATE TABLE president_speeches (
    president text NOT NULL,
    title text NOT NULL,
    speech_date date NOT NULL,
    speech_text text NOT NULL,
    search_speech_text tsvector,
    CONSTRAINT speech_key PRIMARY KEY (president, speech_date)
);

COPY president_speeches (president, title, speech_date, speech_text)
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_14/president_speeches.csv'
WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@');

-- ----
-- 15
-- ----

CREATE EXTENSION postgis;

CREATE TABLE farmers_markets (
    fmid bigint PRIMARY KEY,
    market_name text NOT NULL,
    street text,
    city text,
    county text,
    st text NOT NULL,
    zip text,
    longitude numeric(10,7),
    latitude numeric(10,7),
    organic text NOT NULL
);

COPY farmers_markets
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_15/farmers_markets.csv'
WITH (FORMAT CSV, HEADER);

ALTER TABLE farmers_markets ADD COLUMN geog_point geography(POINT,4326);

-- Now fill that column with the lat/long
UPDATE farmers_markets
SET geog_point = ST_SetSRID(
                            ST_MakePoint(longitude,latitude),4326
                           )::geography;

-- Add a GiST index
CREATE INDEX market_pts_idx ON farmers_markets USING GIST (geog_point);

-- ----
-- 16
-- ----

CREATE TABLE films (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    film jsonb NOT NULL
);

COPY films (film)
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_16/films.json';

CREATE INDEX idx_film ON films USING GIN (film);

CREATE TABLE earthquakes (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    earthquake jsonb NOT NULL
);

COPY earthquakes (earthquake)
FROM '/Users/debarrosa/development-github.com/practical-sql-2e/Chapter_16/earthquakes.json';

CREATE INDEX idx_earthquakes ON earthquakes USING GIN (earthquake);

-- ----
-- 17
-- ----

CREATE OR REPLACE VIEW nevada_counties_pop_2019 AS
    SELECT county_name,
           state_fips,
           county_fips,
           pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE state_name = 'Nevada'
    ORDER BY county_fips;

CREATE OR REPLACE VIEW county_pop_change_2019_2010 AS
    SELECT c2019.county_name,
           c2019.state_name,
           c2019.state_fips,
           c2019.county_fips,
           c2019.pop_est_2019 AS pop_2019,
           c2010.estimates_base_2010 AS pop_2010,
           round( (c2019.pop_est_2019::numeric - c2010.estimates_base_2010)
               / c2010.estimates_base_2010 * 100, 1 ) AS pct_change_2019_2010
    FROM us_counties_pop_est_2019 AS c2019
        JOIN us_counties_pop_est_2010 AS c2010
    ON c2019.state_fips = c2010.state_fips
        AND c2019.county_fips = c2010.county_fips
        ORDER BY c2019.state_fips, c2019.county_fips;
		
DROP VIEW nevada_counties_pop_2019;

CREATE MATERIALIZED VIEW nevada_counties_pop_2019 AS
    SELECT county_name,
           state_fips,
           county_fips,
           pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE state_name = 'Nevada'
    ORDER BY county_fips;
	
CREATE OR REPLACE VIEW employees_tax_dept AS
     SELECT emp_id,
            first_name,
            last_name,
            dept_id
     FROM employees
     WHERE dept_id = 1
     ORDER BY emp_id
     WITH LOCAL CHECK OPTION;
INSERT INTO employees_tax_dept (emp_id, first_name, last_name, dept_id)
VALUES (5, 'Suzanne', 'Legere', 1);
UPDATE employees_tax_dept
SET last_name = 'Le Gere'
WHERE emp_id = 5;
DELETE FROM employees_tax_dept
WHERE emp_id = 5;

CREATE OR REPLACE FUNCTION
percent_change(new_value numeric,
               old_value numeric,
               decimal_places integer DEFAULT 1)
RETURNS numeric AS
$$
    SELECT round(
            ((new_value - old_value) / old_value) * 100, decimal_places
    );
$$
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;


ALTER TABLE teachers ADD COLUMN personal_days integer;
CREATE OR REPLACE PROCEDURE update_personal_days()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE teachers
    SET personal_days =
        CASE WHEN (now() - hire_date) >= '10 years'::interval
                  AND (now() - hire_date) < '15 years'::interval THEN 4
             WHEN (now() - hire_date) >= '15 years'::interval
                  AND (now() - hire_date) < '20 years'::interval THEN 5
             WHEN (now() - hire_date) >= '20 years'::interval
                  AND (now() - hire_date) < '25 years'::interval THEN 6
             WHEN (now() - hire_date) >= '25 years'::interval THEN 7
             ELSE 3
        END;
    RAISE NOTICE 'personal_days updated!';
END
$$;

-- To invoke the procedure:
CALL update_personal_days();


CREATE TABLE grades (
    student_id bigint,
    course_id bigint,
    course text NOT NULL,
    grade text NOT NULL,
PRIMARY KEY (student_id, course_id)
);

INSERT INTO grades
VALUES
    (1, 1, 'Biology 2', 'F'),
    (1, 2, 'English 11B', 'D'),
    (1, 3, 'World History 11B', 'C'),
    (1, 4, 'Trig 2', 'B');

CREATE TABLE grades_history (
    student_id bigint NOT NULL,
    course_id bigint NOT NULL,
    change_time timestamp with time zone NOT NULL,
    course text NOT NULL,
    old_grade text NOT NULL,
    new_grade text NOT NULL,
PRIMARY KEY (student_id, course_id, change_time)
);  

-- Listing 17-20: Creating the record_if_grade_changed() function

CREATE OR REPLACE FUNCTION record_if_grade_changed()
    RETURNS trigger AS
$$
BEGIN
    IF NEW.grade <> OLD.grade THEN
    INSERT INTO grades_history (
        student_id,
        course_id,
        change_time,
        course,
        old_grade,
        new_grade)
    VALUES
        (OLD.student_id,
         OLD.course_id,
         now(),
         OLD.course,
         OLD.grade,
         NEW.grade);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Listing 17-21: Creating the grades_update trigger

CREATE TRIGGER grades_update
  AFTER UPDATE
  ON grades
  FOR EACH ROW
  EXECUTE PROCEDURE record_if_grade_changed();


CREATE TABLE temperature_test (
    station_name text,
    observation_date date,
    max_temp integer,
    min_temp integer,
    max_temp_group text,
PRIMARY KEY (station_name, observation_date)
);

-- Listing 17-24: Creating the classify_max_temp() function
-- CHECK AGAINST CATEGORIES USED PREVIOUSLY

CREATE OR REPLACE FUNCTION classify_max_temp()
    RETURNS trigger AS
$$
BEGIN
    CASE
       WHEN NEW.max_temp >= 90 THEN
           NEW.max_temp_group := 'Hot';
       WHEN NEW.max_temp >= 70 AND NEW.max_temp < 90 THEN
           NEW.max_temp_group := 'Warm';
       WHEN NEW.max_temp >= 50 AND NEW.max_temp < 70 THEN
           NEW.max_temp_group := 'Pleasant';
       WHEN NEW.max_temp >= 33 AND NEW.max_temp < 50 THEN
           NEW.max_temp_group := 'Cold';
       WHEN NEW.max_temp >= 20 AND NEW.max_temp < 33 THEN
           NEW.max_temp_group := 'Frigid';
       WHEN NEW.max_temp < 20 THEN
           NEW.max_temp_group := 'Inhumane';    
       ELSE NEW.max_temp_group := 'No reading';
    END CASE;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Listing 17-25: Creating the temperature_insert trigger

CREATE TRIGGER temperature_insert
    BEFORE INSERT
    ON temperature_test
    FOR EACH ROW
    EXECUTE PROCEDURE classify_max_temp();

-- Listing 17-26: Inserting rows to test the temperature_update trigger

INSERT INTO temperature_test
VALUES
    ('North Station', '1/19/2023', 10, -3),
    ('North Station', '3/20/2023', 28, 19),
    ('North Station', '5/2/2023', 65, 42),
    ('North Station', '8/9/2023', 93, 74),
    ('North Station', '12/14/2023', NULL, NULL);

SELECT * FROM temperature_test ORDER BY observation_date;
