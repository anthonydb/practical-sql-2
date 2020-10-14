---------------------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition
-- by Anthony DeBarros

-- Chapter 11 Code Examples
----------------------------------------------------------------------------

-- Listing 11-1: Create Census 2011-2015 ACS 5-Year stats table and import data

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
FROM '/Users/adebarros/Dropbox/DataMonky/Book-Writing/PracticalSQL_2e/Code-Repo/Chapter_11/acs_2014_2018_stats.csv'
--FROM 'C:\YourDirectory\acs_2014_2018_stats.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

SELECT * FROM acs_2014_2018_stats;

-- Listing 11-2: Using corr(Y, X) to measure the relationship between 
-- education and income

SELECT corr(median_hh_income, pct_bachelors_higher)
    AS bachelors_income_r
FROM acs_2014_2018_stats;

-- Listing 11-3: Using corr(Y, X) on additional variables

SELECT
    round(
      corr(median_hh_income, pct_bachelors_higher)::numeric, 2
      ) AS bachelors_income_r,
    round(
      corr(pct_travel_60_min, median_hh_income)::numeric, 2
      ) AS income_travel_r,
    round(
      corr(pct_travel_60_min, pct_bachelors_higher)::numeric, 2
      ) AS bachelors_travel_r
FROM acs_2014_2018_stats;

-- Listing 11-4: Regression slope and intercept functions

SELECT
    round(
        regr_slope(median_hh_income, pct_bachelors_higher)::numeric, 2
        ) AS slope,
    round(
        regr_intercept(median_hh_income, pct_bachelors_higher)::numeric, 2
        ) AS y_intercept
FROM acs_2014_2018_stats;

-- Listing 11-5: Calculating the coefficient of determination, or r-squared

SELECT round(
        regr_r2(median_hh_income, pct_bachelors_higher)::numeric, 3
        ) AS r_squared
FROM acs_2014_2018_stats;

-- Bonus: Additional stats functions.
-- Variance
SELECT var_pop(median_hh_income)
FROM acs_2014_2018_stats;

-- Standard deviation of the entire population
SELECT stddev_pop(median_hh_income)
FROM acs_2014_2018_stats;

-- Covariance
SELECT covar_pop(median_hh_income, pct_bachelors_higher)
FROM acs_2014_2018_stats;

-- Listing 11-6: The rank() and dense_rank() window functions

CREATE TABLE widget_companies (
    id bigserial,
    company varchar(30) NOT NULL,
    widget_output integer NOT NULL
);

INSERT INTO widget_companies (company, widget_output)
VALUES
    ('Morse Widgets', 125000),
    ('Springfield Widget Masters', 143000),
    ('Best Widgets', 196000),
    ('Acme Inc.', 133000),
    ('District Widget Inc.', 201000),
    ('Clarke Amalgamated', 620000),
    ('Stavesacre Industries', 244000),
    ('Bowers Widget Emporium', 201000);

SELECT
    company,
    widget_output,
    rank() OVER (ORDER BY widget_output DESC),
    dense_rank() OVER (ORDER BY widget_output DESC)
FROM widget_companies;

-- Listing 11-7: Applying rank() within groups using PARTITION BY

CREATE TABLE store_sales (
    store varchar(30),
    category varchar(30) NOT NULL,
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

SELECT
    category,
    store,
    unit_sales,
    rank() OVER (PARTITION BY category ORDER BY unit_sales DESC)
FROM store_sales;



-- 

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
FROM '/Users/adebarros/Dropbox/DataMonky/Book-Writing/PracticalSQL_2e/Code-Repo/Chapter_11/cbp_naics_72_establishments.csv'
--FROM 'C:\YourDirectory\cbp_naics_72_establishments.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


SELECT cbp.state_fips || cbp.county_fips AS fips,
       cbp.county,
       cbp.st,
       cbp.establishments,
       pop.pop_est_2018,
       round(
           (cbp.establishments::numeric / pop.pop_est_2018) * 1000, 1
           ) AS estabs_per_1000       
FROM 
cbp_naics_72_establishments cbp LEFT JOIN us_counties_pop_est_2019 pop
ON cbp.state_fips = pop.state_fips
    AND cbp.county_fips = pop.county_fips
WHERE pop.pop_est_2018 >= 50000
ORDER BY cbp.establishments::numeric / pop.pop_est_2018 DESC;

-- OLD first edition


-- Listing 11-8: Create and fill a 2015 FBI crime data table

CREATE TABLE fbi_crime_data_2015 (
    st varchar(20),
    city varchar(50),
    population integer,
    violent_crime integer,
    property_crime integer,
    burglary integer,
    larceny_theft integer,
    motor_vehicle_theft integer,
    CONSTRAINT st_city_key PRIMARY KEY (st, city)
);

COPY fbi_crime_data_2015
FROM 'C:\YourDirectory\fbi_crime_data_2015.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');

SELECT * FROM fbi_crime_data_2015
ORDER BY population DESC;

-- Listing 11-9: Find property crime rates per thousand in cities with 500,000
-- or more people

SELECT
    city,
    st,
    population,
    property_crime,
    round(
        (property_crime::numeric / population) * 1000, 1
        ) AS pc_per_1000
FROM fbi_crime_data_2015
WHERE population >= 500000
ORDER BY (property_crime::numeric / population) DESC;
