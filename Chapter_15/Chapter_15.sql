---------------------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition
-- by Anthony DeBarros

-- Chapter 15 Code Examples
----------------------------------------------------------------------------


-- Listing 15-1: Loading the PostGIS extension

CREATE EXTENSION postgis;

SELECT postgis_full_version(); -- shows PostGIS version

-- Listing 15-2: Retrieving the well-known text for SRID 4326

SELECT srtext
FROM spatial_ref_sys
WHERE srid = 4326;

-- Listing 15-3: Using ST_GeomFromText() to create spatial objects

SELECT ST_GeomFromText('POINT(-74.9233606 42.699992)', 4326);

SELECT ST_GeomFromText('LINESTRING(-74.9 42.7, -75.1 42.7)', 4326);

SELECT ST_GeomFromText('POLYGON((-74.9 42.7, -75.1 42.7,
                                 -75.1 42.6, -74.9 42.7))', 4326);

SELECT ST_GeomFromText('MULTIPOINT (-74.9 42.7, -75.1 42.7)', 4326);

SELECT ST_GeomFromText('MULTILINESTRING((-76.27 43.1, -76.06 43.08),
                                        (-76.2 43.3, -76.2 43.4,
                                         -76.4 43.1))', 4326);

SELECT ST_GeomFromText('MULTIPOLYGON((
                                     (-74.92 42.7, -75.06 42.71,
                                      -75.07 42.64, -74.92 42.7),
                                     (-75.0 42.66, -75.0 42.64,
                                      -74.98 42.64, -74.98 42.66,
                                      -75.0 42.66)))', 4326);

-- Listing 15-4: Using ST_GeogFromText() to create spatial objects

SELECT
ST_GeogFromText('SRID=4326;MULTIPOINT(-74.9 42.7, -75.1 42.7, -74.924 42.6)');

-- Listing 15-5: Functions specific to making points

SELECT ST_PointFromText('POINT(-74.9233606 42.699992)', 4326);

SELECT ST_MakePoint(-74.9233606, 42.699992);
SELECT ST_SetSRID(ST_MakePoint(-74.9233606, 42.699992), 4326);

-- Listing 15-6: Functions specific to making LineStrings

SELECT ST_LineFromText('LINESTRING(-105.90 35.67,-105.91 35.67)', 4326);
SELECT ST_MakeLine(ST_MakePoint(-74.9, 42.7), ST_MakePoint(-74.1, 42.4));

-- Listing 15-7: Functions specific to making Polygons

SELECT ST_PolygonFromText('POLYGON((-74.9 42.7, -75.1 42.7,
                                    -75.1 42.6, -74.9 42.7))', 4326);

SELECT ST_MakePolygon(
           ST_GeomFromText('LINESTRING(-74.92 42.7, -75.06 42.71,
                                       -75.07 42.64, -74.92 42.7)', 4326));

SELECT ST_MPolyFromText('MULTIPOLYGON((
                                       (-74.92 42.7, -75.06 42.71,
                                        -75.07 42.64, -74.92 42.7),
                                       (-75.0 42.66, -75.0 42.64,
                                        -74.98 42.64, -74.98 42.66,
                                        -75.0 42.66)
                                      ))', 4326);


-- ANALYZING FARMERS MARKETS DATA
-- https://www.ams.usda.gov/local-food-directories/farmersmarkets


-- Listing 15-8: Creating and loading the farmers_markets table

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
FROM 'C:\YourDirectory\farmers_markets.csv'
WITH (FORMAT CSV, HEADER);

SELECT count(*) FROM farmers_markets; -- should return 8,681 rows

-- Listing 15-9: Creating and indexing a geography column
-- There's also a function: https://postgis.net/docs/AddGeometryColumn.html

-- Add column
ALTER TABLE farmers_markets ADD COLUMN geog_point geography(POINT,4326);

-- Now fill that column with the lat/long
UPDATE farmers_markets
SET geog_point = 
     ST_SetSRID(
               ST_MakePoint(longitude,latitude)::geography,4326
               );

-- Add a spatial (R-Tree) index using GIST
CREATE INDEX market_pts_idx ON farmers_markets USING GIST (geog_point);

-- View the geography column
SELECT longitude,
       latitude,
       geog_point,
       ST_AsEWKT(geog_point)
FROM farmers_markets
WHERE longitude IS NOT NULL
LIMIT 5;

-- Listing 15-10: Using ST_DWithin() to locate farmers' markets within 10 kilometers of a point

SELECT market_name,
       city,
       st,
       geog_point
FROM farmers_markets
WHERE ST_DWithin(geog_point,
                 ST_GeogFromText('POINT(-93.6204386 41.5853202)'),
                 10000)
ORDER BY market_name;

-- Listing 15-11: Using ST_Distance() to calculate the miles between Yankee Stadium
-- and Citi Field (Mets)
-- 1609.344 meters/mile

SELECT ST_Distance(
                   ST_GeogFromText('POINT(-73.9283685 40.8296466)'),
                   ST_GeogFromText('POINT(-73.8480153 40.7570917)')
                   ) / 1609.344 AS mets_to_yanks;

-- Listing 15-12: Using ST_Distance() for each row in farmers_markets

SELECT market_name,
       city,
       round(
           (ST_Distance(geog_point,
                        ST_GeogFromText('POINT(-93.6204386 41.5853202)')
                        ) / 1609.344)::numeric, 2
            ) AS miles_from_dt
FROM farmers_markets
WHERE ST_DWithin(geog_point,
                 ST_GeogFromText('POINT(-93.6204386 41.5853202)'),
                 10000)
ORDER BY miles_from_dt ASC;

-- Listing 15-13: Using the <-> distance operator for a nearest neighbors search

SELECT market_name,
       city,
       st,
       round(
           (ST_Distance(geog_point,
                        ST_GeogFromText('POINT(-68.2041607 44.3876414)')
                        ) / 1609.344)::numeric, 2
            ) AS miles_from_bh
FROM farmers_markets
ORDER BY geog_point <-> ST_GeogFromText('POINT(-68.2041607 44.3876414)')
LIMIT 3;

-- WORKING WITH SHAPEFILES

-- Resources:
   -- TIGER/Line® Shapefiles and TIGER/Line® Files
   -- https://www.census.gov/geo/maps-data/data/tiger-line.html
   -- Cartographic Boundary Shapefiles - Counties
   -- https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html


-- Import (for use on command line if on macOS or Linux; see Chapter 18)
shp2pgsql -I -s 4269 -W LATIN1 tl_2019_us_county.shp us_counties_2019_shp | psql -d analysis -U postgres

-- Listing 15-14: Checking the geom column's well-known text representation

SELECT ST_AsText(geom)
FROM us_counties_2019_shp
ORDER BY gid
LIMIT 1;

-- Listing 15-15: Finding the largest counties by area using ST_Area()

SELECT name,
       statefp AS st,
       round(
             ( ST_Area(geom::geography) / 2589988.110336 )::numeric, 2
            )  AS square_miles
FROM us_counties_2019_shp
ORDER BY square_miles DESC
LIMIT 5;

-- Listing 15-16: Using ST_Within() to find the county belonging to a pair of coordinates

SELECT sh.name,
       c.state_name
FROM us_counties_2019_shp sh JOIN us_counties_pop_est_2019 c
    ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE ST_Within(
         'SRID=4269;POINT(-118.3419063 34.0977076)'::geometry, geom
);

-- Listing 15-17: Using ST_DWithin() to count people near Lincoln, Nebraska

SELECT sum(c.pop_est_2019) AS pop_est_2019
FROM us_counties_2019_shp sh JOIN us_counties_pop_est_2019 c
    ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE ST_DWithin(sh.geom::geography, 
          ST_GeogFromText('SRID=4269;POINT(-96.699656 40.811567)'),
          80467);
          
-- Note: You can speed up the above query by creating a functional index
-- that covers the casting of the geom column to a geography type.
CREATE INDEX us_counties_2019_shp_geog_idx ON us_counties_2019_shp USING GIST (CAST(geom AS geography));

-- Listing 15-18: Displaying counties near Lincoln, Nebraska

SELECT sh.name,
       c.state_name,
       c.pop_est_2019,
       ST_Transform(sh.geom, 4326) AS geom
FROM us_counties_2019_shp sh JOIN us_counties_pop_est_2019 c
    ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE ST_DWithin(sh.geom::geography, 
          ST_GeogFromText('SRID=4269;POINT(-96.699656 40.811567)'),
          80467);


-- SPATIAL JOINS
-- SANTA FE WATER AND ROAD DATA
-- http://www.santafenm.gov/santa_fe_river

-- Census 2019 Tiger/Line roads, water
-- https://www.census.gov/geo/maps-data/data/tiger-line.html
-- https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2019&layergroup=Roads
-- https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2019&layergroup=Water

-- RTTYP - Route Type Code Description
-- https://www.census.gov/geo/reference/rttyp.html
-- C County
-- I Interstate
-- M Common Name
-- O Other
-- S State recognized
-- U U.S.

-- MTFCC MAF/TIGER feature class code
-- https://www.census.gov/geo/reference/mtfcc.html
-- Here, H3010: A natural flowing waterway


-- Import (for use on command line if on macOS or Linux; see Chapter 18)
shp2pgsql -I -s 4269 -W LATIN1 tl_2019_35049_linearwater.shp santafe_linearwater_2019 | psql -d analysis -U postgres
shp2pgsql -I -s 4269 -W LATIN1 tl_2019_35049_roads.shp santafe_roads_2019 | psql -d analysis -U postgres

-- Listing 15-19: Using ST_GeometryType() to determine geometry

SELECT ST_GeometryType(geom)
FROM santafe_linearwater_2019
LIMIT 1;

SELECT ST_GeometryType(geom)
FROM santafe_roads_2019
LIMIT 1;

-- Listing 15-20: Spatial join with ST_Intersects() to find roads crossing the Santa Fe river

SELECT water.fullname AS waterway,
       roads.rttyp,
       roads.fullname AS road
FROM santafe_linearwater_2019 water JOIN santafe_roads_2019 roads
    ON ST_Intersects(water.geom, roads.geom)
WHERE water.fullname = 'Santa Fe Riv' 
      AND roads.fullname IS NOT NULL
ORDER BY roads.fullname;

-- Listing 15-21: Using ST_Intersection() to show where roads cross the river

SELECT water.fullname AS waterway,
       roads.rttyp,
       roads.fullname AS road,
       ST_AsText(ST_Intersection(water.geom, roads.geom))
FROM santafe_linearwater_2019 water JOIN santafe_roads_2019 roads
    ON ST_Intersects(water.geom, roads.geom)
WHERE water.fullname = 'Santa Fe Riv'
      AND roads.fullname IS NOT NULL
ORDER BY roads.fullname;

