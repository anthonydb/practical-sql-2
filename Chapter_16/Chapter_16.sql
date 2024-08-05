---------------------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition
-- by Anthony DeBarros

-- Chapter 16 Code Examples
----------------------------------------------------------------------------

-- Listing 16-1: JSON with information about two films

[{
	"title": "The Incredibles",
	"year": 2004,
	"rating": {
		"MPAA": "PG"
	},
	"characters": [{
		"name": "Mr. Incredible",
		"actor": "Craig T. Nelson"
	}, {
		"name": "Elastigirl",
		"actor": "Holly Hunter"
	}, {
		"name": "Frozone",
		"actor": "Samuel L. Jackson"
	}],
	"genre": ["animation", "action", "sci-fi"]
}, {
	"title": "Cinema Paradiso",
	"year": 1988,
	"characters": [{
		"name": "Salvatore",
		"actor": "Salvatore Cascio"
	}, {
		"name": "Alfredo",
		"actor": "Philippe Noiret"
	}],
	"genre": ["romance", "drama"]
}]

-- Listing 16-2: Creating a table to hold JSON data and adding an index

CREATE TABLE films (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    film jsonb NOT NULL
);

COPY films (film)
FROM 'C:\YourDirectory\films.json';

CREATE INDEX idx_film ON films USING GIN (film);

SELECT * FROM films;


-- JSON AND JSONB EXTRACTION OPERATORS

-- Listing 16-3: Retrieving a JSON key value with field extraction operators 

-- Returns the key value as a JSON data type
SELECT id, film -> 'title' AS title
FROM films
ORDER BY id;

-- Returns the key value as text
SELECT id, film ->> 'title' AS title
FROM films
ORDER BY id;

-- Returns the entire array as a JSON data type
SELECT id, film -> 'genre' AS genre
FROM films
ORDER BY id;

-- Listing 16-4: Retrieving a JSON array value with element extraction operators 

-- Extracts first element of the JSON array
-- (array elements are indexed from zero, but negative integers count from the end).
SELECT id, film -> 'genre' -> 0 AS genres
FROM films
ORDER BY id;

SELECT id, film -> 'genre' -> -1 AS genres
FROM films
ORDER BY id;

SELECT id, film -> 'genre' -> 2 AS genres
FROM films
ORDER BY id;

-- Return the array element as text
SELECT id, film -> 'genre' ->> 0 AS genres
FROM films
ORDER BY id;

-- Listing 16-5: Retrieving a JSON key value with path extraction operators

-- Retrieve the film's MPAA rating.
SELECT id, film #> '{rating, MPAA}' AS mpaa_rating
FROM films
ORDER BY id;

-- Retrieve the name of the first character
SELECT id, film #> '{characters, 0, name}' AS name
FROM films
ORDER BY id;

-- Same as above but return it as text
SELECT id, film #>> '{characters, 0, name}' AS name
FROM films
ORDER BY id;


-- JSONB CONTAINMENT AND EXISTENCE OPERATORS

-- Listing 16-6: Demonstrating the @> containment operator

-- Does the film JSON value contain the following key/value pair?
SELECT id, film ->> 'title' AS title,
       film @> '{"title": "The Incredibles"}'::jsonb AS is_incredible
FROM films
ORDER BY id;

-- Listing 16-7: Using a containment operator in a WHERE clause

SELECT film ->> 'title' AS title,
       film ->> 'year' AS year
FROM films
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

-- Listing 16-8: Demonstrating the <@ containment operator

SELECT film ->> 'title' AS title,
       film ->> 'year' AS year
FROM films
WHERE '{"title": "The Incredibles"}'::jsonb <@ film; 

-- Listing 16-9: Demonstrating existence operators

-- Does the text string exist as a top-level key or array element within the JSON value?
SELECT film ->> 'title' AS title
FROM films
WHERE film ? 'rating';

-- Do any of the strings in the text array exist as top-level keys or array elements?
SELECT film ->> 'title' AS title,
       film ->> 'rating' AS rating,
       film ->> 'genre' AS genre
FROM films
WHERE film ?| '{rating, genre}';

-- Do all of the strings in the text array exist as top-level keys or array elements?
SELECT film ->> 'title' AS title,
       film ->> 'rating' AS rating,
       film ->> 'genre' AS genre
FROM films
WHERE film ?& '{rating, genre}';


-- ANALYZING EARTHQUAKE DATA

-- Listing 16-10: JSON with data on one earthquake

{
	"type": "Feature",
	"properties": {
		"mag": 1.44,
		"place": "134 km W of Adak, Alaska",
		"time": 1612051063470,
		"updated": 1612139465880,
		"tz": null,
		"url": "https://earthquake.usgs.gov/earthquakes/eventpage/av91018173",
		"detail": "https://earthquake.usgs.gov/fdsnws/event/1/query?eventid=av91018173&format=geojson",
		"felt": null,
		"cdi": null,
		"mmi": null,
		"alert": null,
		"status": "reviewed",
		"tsunami": 0,
		"sig": 32,
		"net": "av",
		"code": "91018173",
		"ids": ",av91018173,",
		"sources": ",av,",
		"types": ",origin,phase-data,",
		"nst": 10,
		"dmin": null,
		"rms": 0.15,
		"gap": 174,
		"magType": "ml",
		"type": "earthquake",
		"title": "M 1.4 - 134 km W of Adak, Alaska"
	},
	"geometry": {
		"type": "Point",
		"coordinates": [-178.581, 51.8418333333333, 22.48]
	},
	"id": "av91018173"
}

-- Listing 16-11: Creating and loading an earthquakes table

CREATE TABLE earthquakes (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    earthquake jsonb NOT NULL
);

COPY earthquakes (earthquake)
FROM 'C:\YourDirectory\earthquakes.json';

CREATE INDEX idx_earthquakes ON earthquakes USING GIN (earthquake);

SELECT * FROM earthquakes;

-- Listing 16-12: Retrieving the earthquake time
-- Note that the time is stored in epoch format

SELECT id, earthquake #>> '{properties, time}' AS time 
FROM earthquakes
ORDER BY id LIMIT 5;

-- Listing 16-13: Converting the time value to a timestamp

SELECT id, earthquake #>> '{properties, time}' as time,
       to_timestamp(
           (earthquake #>> '{properties, time}')::bigint / 1000
                   ) AS time_formatted
FROM earthquakes
ORDER BY id LIMIT 5;

-- See and set time zone if desired
SHOW timezone;
SET timezone TO 'US/Eastern';
SET timezone TO 'UTC';

-- Listing 16-14: Finding the minimum and maximum earthquake times

SELECT min(to_timestamp(
           (earthquake #>> '{properties, time}')::bigint / 1000
                       )) AT TIME ZONE 'UTC' AS min_timestamp,
       max(to_timestamp(
           (earthquake #>> '{properties, time}')::bigint / 1000
                       )) AT TIME ZONE 'UTC' AS max_timestamp
FROM earthquakes;

-- Listing 16-15: Finding the five earthquakes with the largest magnitude

SELECT earthquake #>> '{properties, place}' AS place,
       to_timestamp((earthquake #>> '{properties, time}')::bigint / 1000)
           AT TIME ZONE 'UTC' AS time,
       (earthquake #>> '{properties, mag}')::numeric AS magnitude
FROM earthquakes
ORDER BY (earthquake #>> '{properties, mag}')::numeric DESC NULLS LAST
LIMIT 5;

-- Bonus: Instead of using a path extraction operator (#>>), you can also use field extraction:
SELECT earthquake -> 'properties' ->> 'place' AS place,
       to_timestamp((earthquake -> 'properties' ->> 'time')::bigint / 1000)
           AT TIME ZONE 'UTC' AS time,
       (earthquake #>> '{properties, mag}')::numeric AS magnitude
FROM earthquakes
ORDER BY (earthquake #>> '{properties, mag}')::numeric DESC NULLS LAST
LIMIT 5;

-- Listing 16-16: Finding earthquakes with the most Did You Feel It? reports
-- https://earthquake.usgs.gov/data/dyfi/

SELECT earthquake #>> '{properties, place}' AS place,
       to_timestamp((earthquake #>> '{properties, time}')::bigint / 1000)
           AT TIME ZONE 'UTC' AS time,
       (earthquake #>> '{properties, mag}')::numeric AS magnitude,
       (earthquake #>> '{properties, felt}')::integer AS felt
FROM earthquakes
ORDER BY (earthquake #>> '{properties, felt}')::integer DESC NULLS LAST
LIMIT 5;

-- Listing 16-17: Extracting the earthquake's location data

SELECT id,
       earthquake #>> '{geometry, coordinates}' AS coordinates,
       earthquake #>> '{geometry, coordinates, 0}' AS longitude,
       earthquake #>> '{geometry, coordinates, 1}' AS latitude
FROM earthquakes
ORDER BY id
LIMIT 5;

-- Listing 16-18: Converting JSON location data to PostGIS geography
SELECT ST_SetSRID(
         ST_MakePoint(
            (earthquake #>> '{geometry, coordinates, 0}')::numeric,
            (earthquake #>> '{geometry, coordinates, 1}')::numeric
         ),
             4326)::geography AS earthquake_point
FROM earthquakes
ORDER BY id;

-- Listing 16-19: Converting JSON coordinates to a PostGIS geography column 

-- Add a column of the geography data type 
ALTER TABLE earthquakes ADD COLUMN earthquake_point geography(POINT, 4326);

-- Update the earthquakes table with a Point
UPDATE earthquakes
SET earthquake_point = 
        ST_SetSRID(
            ST_MakePoint(
                (earthquake #>> '{geometry, coordinates, 0}')::numeric,
                (earthquake #>> '{geometry, coordinates, 1}')::numeric
             ),
                 4326)::geography;

CREATE INDEX quake_pt_idx ON earthquakes USING GIST (earthquake_point);

-- Listing 16-20: Finding earthquakes within 50 miles of downtown Tulsa, Oklahoma

SELECT earthquake #>> '{properties, place}' AS place,
       to_timestamp((earthquake -> 'properties' ->> 'time')::bigint / 1000)
           AT TIME ZONE 'UTC' AS time,
       (earthquake #>> '{properties, mag}')::numeric AS magnitude,
       earthquake_point
FROM earthquakes
WHERE ST_DWithin(earthquake_point,
                 ST_GeogFromText('POINT(-95.989505 36.155007)'),
                 80468)
ORDER BY time;

-- GENERATING AND MANIPULATING JSON

-- Listing 16-21: Turning query results into JSON with to_json()

-- Convert an entire row from the table
SELECT to_json(employees) AS json_rows
FROM employees;

-- Listing 16-22: Specifying columns to convert to JSON
-- Returns key names as f1, f2, etc.
SELECT to_json(row(emp_id, last_name)) AS json_rows
FROM employees;

-- Listing 16-23: Generating key names with a subquery
SELECT to_json(employees) AS json_rows
FROM (
    SELECT emp_id, last_name AS ln FROM employees
) AS employees;

-- Listing 16-24: Aggregating the rows and converting to JSON
SELECT json_agg(to_json(employees)) AS json
FROM (
    SELECT emp_id, last_name AS ln FROM employees
) AS employees;

-- Listing 16-25: Adding a top-level key/value pair via concatenation
-- Two examples

UPDATE films
SET film = film || '{"studio": "Pixar"}'::jsonb
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

UPDATE films
SET film = film || jsonb_build_object('studio', 'Pixar')
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

SELECT film FROM films -- check the updated data
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

-- Listing 16-26: Setting an array value at a path

UPDATE films
SET film = jsonb_set(film,
                 '{genre}',
                  film #> '{genre}' || '["World War II"]',
                  true)
WHERE film @> '{"title": "Cinema Paradiso"}'::jsonb; 

SELECT film FROM films -- check the updated data
WHERE film @> '{"title": "Cinema Paradiso"}'::jsonb; 

-- Listing 16-27: Deleting values from JSON

-- Removes the studio key/value pair from The Incredibles
UPDATE films
SET film = film - 'studio'
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

-- Removes the third element in the genre array of Cinema Paradiso
UPDATE films
SET film = film #- '{genre, 2}'
WHERE film @> '{"title": "Cinema Paradiso"}'::jsonb; 


-- JSON PROCESSING FUNCTIONS

-- Listing 16-28: Finding the length of an array

SELECT id,
       film ->> 'title' AS title,
       jsonb_array_length(film -> 'characters') AS num_characters
FROM films
ORDER BY id;

-- Listing 16-29: Returning array elements as rows

SELECT id,
       jsonb_array_elements(film -> 'genre') AS genre_jsonb,
       jsonb_array_elements_text(film -> 'genre') AS genre_text
FROM films
ORDER BY id;

-- Listing 16-30: Returning key values from each item in an array

SELECT id, 
       jsonb_array_elements(film -> 'characters')
FROM films
ORDER BY id;

WITH characters (id, json) AS (
    SELECT id,
           jsonb_array_elements(film -> 'characters')
    FROM films
)
SELECT id, 
       json ->> 'name' AS name,
       json ->> 'actor' AS actor
FROM characters
ORDER BY id;
