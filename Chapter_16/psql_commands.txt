--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros

-- Chapter 16 Code Examples
--------------------------------------------------------------


-- Connecting psql to a database on a local server

psql -d [database name] -U [username]
psql -d analysis -U postgres

-- Changing user and database name

\c [database name] [user name]
\c gis_analysis postgres

-- Listing 16-1: Entering a single-line query in psql
-- Enter this at the psql prompt:

SELECT geo_name FROM us_counties_2010 LIMIT 3;

-- Listing 16-2: Entering a multi-line query in psql
-- Type each line separately, followed by Enter

SELECT geo_name
FROM us_counties_2010
LIMIT 3;


-- Listing 16-3: Showing open parentheses in the psql prompt

CREATE TABLE wineries (
id bigint,
winery_name varchar(100)
);

-- Listing 16-4: A query with scrolling results

SELECT geo_name FROM us_counties_2010;

-- Listings 16-5 and 16-6: Normal and expanded displays of results
-- Use \x to toggle expanded on/off

SELECT * FROM grades;

-- Listing 16-7: Importing data using \copy

DROP TABLE state_regions;

CREATE TABLE state_regions (
    st varchar(2) CONSTRAINT st_key PRIMARY KEY,
    region varchar(20) NOT NULL
);

\copy state_regions FROM 'C:\YourDirectory\state_regions.csv' WITH (FORMAT CSV, HEADER);

-- Listing 16-8: Saving query output to a file

-- Enter psql settings
\a \f , \pset footer

-- This will be the query
SELECT * FROM grades;

-- Set psql to output results
-- Note that Windows users must suppply forward slashes for
-- this command, which is opposite of normal use.
\o 'C:/YourDirectory/query_output.csv'

-- Run the query and output
SELECT * FROM grades;


-- createdb: Create a database named box_office

createdb -U postgres -e box_office


-- Loading shapefiles into PostgreSQL

-- For the US Census county shapefile in Chapter 14:
shp2pgsql -I -s 4269 -W Latin1 tl_2010_us_county10.shp us_counties_2010_shp | psql -d gis_analysis -U postgres

-- For the Santa Fe roads and waterways shapfiles in Chapter 14:
shp2pgsql -I -s 4269 tl_2016_35049_roads.shp santafe_roads_2016 | psql -d gis_analysis -U postgres
shp2pgsql -I -s 4269 tl_2016_35049_linearwater.shp santafe_linearwater_2016 | psql -d gis_analysis -U postgres
