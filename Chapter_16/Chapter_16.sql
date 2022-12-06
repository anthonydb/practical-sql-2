---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------

-- 코드 16-1: 두 영화에 대한 정보가 담긴 JSON

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

-- 코드 16-2: JSON 데이터를 저장할 테이블 생성하고 인덱스 추가하기

CREATE TABLE films (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    film jsonb NOT NULL
);

COPY films (film)
FROM 'C:\YourDirectory\films.json';

CREATE INDEX idx_film ON films USING GIN (film);

SELECT * FROM films;


-- json 및 jsonb 추출 연산자 사용하기

-- 코드 16-3: 필드 추출 연산자로 JSON 키 값 검색하기

-- 키 값을 JSON 타입으로 반환하기
SELECT id, film -> 'title' AS title
FROM films
ORDER BY id;

-- 키 값을 텍스트로 반환하기
SELECT id, film ->> 'title' AS title
FROM films
ORDER BY id;

-- 전체 배열을 JSON 타입으로 반환하기
SELECT id, film -> 'genre' AS genre
FROM films
ORDER BY id;

-- 코드 16-4: 요소 추출 연산자로 JSON 배열 값 검색하기

-- JSON 배열의 첫 번째 값 추출하기
-- (배열 요소는 0부터 번호가 매겨지며 음수는 배열의 끝부터 세어나갑니다).
SELECT id, film -> 'genre' -> 0 AS genres
FROM films
ORDER BY id;

SELECT id, film -> 'genre' -> -1 AS genres
FROM films
ORDER BY id;

SELECT id, film -> 'genre' -> 2 AS genres
FROM films
ORDER BY id;

-- 배열 요소를 텍스트로 반환하기
SELECT id, film -> 'genre' ->> 0 AS genres
FROM films
ORDER BY id;

-- 코드 16-5: 경로 추출 연산자로 JSON 키 값 검색하기

-- 영화의 MPAA 등급 얻기.
SELECT id, film #> '{rating, MPAA}' AS mpaa_rating
FROM films
ORDER BY id;

-- 첫번째 캐릭터의 이름 얻기
SELECT id, film #> '{characters, 0, name}' AS name
FROM films
ORDER BY id;

-- 같은 값을 텍스트로 얻기
SELECT id, film #>> '{characters, 0, name}' AS name
FROM films
ORDER BY id;


-- jsonb 포함 및 존재 여부 확인 연산자

-- 코드 16-6: @> 포함 여부 확인 연산자 사용하기

-- 첫 번째 JSON 값에 두 번째 JSON 값이 포함되어 있는지 여부를 확인
SELECT id, film ->> 'title' AS title,
       film @> '{"title": "The Incredibles"}'::jsonb AS is_incredible
FROM films
ORDER BY id;

-- 코드 16-7: WHERE 절에서 포함 연산자 사용하기

SELECT film ->> 'title' AS title,
       film ->> 'year' AS year
FROM films
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

-- 코드 16-8: <@ 포함 여부 확인 연산자 사용하기

SELECT film ->> 'title' AS title,
       film ->> 'year' AS year
FROM films
WHERE '{"title": "The Incredibles"}'::jsonb <@ film; 

-- 코드 16-9: 존재 여부 확인 연산자 사용하기

-- 단일 키나 배열 요소의 존재를 확인
SELECT film ->> 'title' AS title
FROM films
WHERE film ? 'rating';

-- 최상위 키 중 하나가 존재하는지 확인
SELECT film ->> 'title' AS title,
       film ->> 'rating' AS rating,
       film ->> 'genre' AS genre
FROM films
WHERE film ?| '{rating, genre}';

-- 최상위 키가 모두 존재하는지 확인
SELECT film ->> 'title' AS title,
       film ->> 'rating' AS rating,
       film ->> 'genre' AS genre
FROM films
WHERE film ?& '{rating, genre}';


-- 지진 데이터 분석하기

-- 코드 16-10: 한 지진에 대한 데이터를 정리한 JSON

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

-- 코드 16-11: 지진 테이블 생성 및 로드

CREATE TABLE earthquakes (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    earthquake jsonb NOT NULL
);

COPY earthquakes (earthquake)
FROM 'C:\YourDirectory\earthquakes.json';

CREATE INDEX idx_earthquakes ON earthquakes USING GIN (earthquake);

SELECT * FROM earthquakes;

-- 코드 16-12: 지진 시간 검색하기 (시간은 에포크 단위로 저장)

SELECT id, earthquake #>> '{properties, time}' AS time 
FROM earthquakes
ORDER BY id LIMIT 5;

-- 코드 16-13: 시간 값을 타임스탬프로 변환하기

SELECT id, earthquake #>> '{properties, time}' as time,
       to_timestamp(
           (earthquake #>> '{properties, time}')::bigint / 1000
                   ) AS time_formatted
FROM earthquakes
ORDER BY id LIMIT 5;

-- 시간대 확인 후 설정하기
SHOW timezone;
SET timezone TO 'US/Eastern';
SET timezone TO 'UTC';

-- 코드 16-14: 지진 시각의 최솟값, 최댓값 찾기

SELECT min(to_timestamp(
           (earthquake #>> '{properties, time}')::bigint / 1000
                       )) AT TIME ZONE 'UTC' AS min_timestamp,
       max(to_timestamp(
           (earthquake #>> '{properties, time}')::bigint / 1000
                       )) AT TIME ZONE 'UTC' AS max_timestamp
FROM earthquakes;

-- 코드 16-15: 진도가 가장 큰 지진 5개 찾기

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

-- 코드 16-16: 가장 많이 신고된 지진 찾기
-- https://earthquake.usgs.gov/data/dyfi/

SELECT earthquake #>> '{properties, place}' AS place,
       to_timestamp((earthquake #>> '{properties, time}')::bigint / 1000)
           AT TIME ZONE 'UTC' AS time,
       (earthquake #>> '{properties, mag}')::numeric AS magnitude,
       (earthquake #>> '{properties, felt}')::integer AS felt
FROM earthquakes
ORDER BY (earthquake #>> '{properties, felt}')::integer DESC NULLS LAST
LIMIT 5;

-- 코드 16-17: 지진의 위치 데이터 추출하기

SELECT id,
       earthquake #>> '{geometry, coordinates}' AS coordinates,
       earthquake #>> '{geometry, coordinates, 0}' AS longitude,
       earthquake #>> '{geometry, coordinates, 1}' AS latitude
FROM earthquakes
ORDER BY id
LIMIT 5;

-- 코드 16-18: JSON 위치 데이터를 PostGIS geography로 변환하기
SELECT ST_SetSRID(
         ST_MakePoint(
            (earthquake #>> '{geometry, coordinates, 0}')::numeric,
            (earthquake #>> '{geometry, coordinates, 1}')::numeric
         ),
             4326)::geography AS earthquake_point
FROM earthquakes
ORDER BY id;

-- 코드 16-19: JSON 좌표를 PostGIS geography 열로 변환하기

-- geography 데이터 타입 열 추가
ALTER TABLE earthquakes ADD COLUMN earthquake_point geography(POINT, 4326);

-- earthquakes 테이블 업데이트
UPDATE earthquakes
SET earthquake_point = 
        ST_SetSRID(
            ST_MakePoint(
                (earthquake #>> '{geometry, coordinates, 0}')::numeric,
                (earthquake #>> '{geometry, coordinates, 1}')::numeric
             ),
                 4326)::geography;

CREATE INDEX quake_pt_idx ON earthquakes USING GIST (earthquake_point);

-- 코드 16-20: 오클라호마 털사의 80km 이내에서 발생한 지진 찾기

SELECT earthquake #>> '{properties, place}' AS place,
       to_timestamp((earthquake -> 'properties' ->> 'time')::bigint / 1000)
           AT TIME ZONE 'UTC' AS time,
       (earthquake #>> '{properties, mag}')::numeric AS magnitude,
       earthquake_point
FROM earthquakes
WHERE ST_DWithin(earthquake_point,
                 ST_GeogFromText('POINT(-95.989505 36.155007)'),
                 80000)
ORDER BY time;

-- JSON 생성 및 수정

-- 코드 16-21: to_json()을 사용하여 쿼리 결과를 JSON으로 변환

-- 테이블의 한 행 전체 변환
SELECT to_json(employees) AS json_rows
FROM employees;

-- 코드 16-22: JSON으로 변환할 열 지정하기
-- 키 이름을 f1, f2 형태로 반환
SELECT to_json(row(emp_id, last_name)) AS json_rows
FROM employees;

-- 코드 16-23: 하위 쿼리로 키 이름 생성하기
SELECT to_json(employees) AS json_rows
FROM (
    SELECT emp_id, last_name AS ln FROM employees
) AS employees;

-- 코드 16-24: 행을 집계해 JSON으로 변환
SELECT json_agg(to_json(employees)) AS json
FROM (
    SELECT emp_id, last_name AS ln FROM employees
) AS employees;

-- 코드 16-25: 문자열 연결 연산자로 최상위 키/값 쌍 추가하기

UPDATE films
SET film = film || '{"studio": "Pixar"}'::jsonb
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

UPDATE films
SET film = film || jsonb_build_object('studio', 'Pixar')
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

SELECT film FROM films -- check the updated data
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

-- 코드 16-26: jsonb_set()을 사용해 경로에 배열 값 추가하기

UPDATE films
SET film = jsonb_set(film,
                 '{genre}',
                  film #> '{genre}' || '["World War II"]',
                  true)
WHERE film @> '{"title": "Cinema Paradiso"}'::jsonb; 

SELECT film FROM films -- check the updated data
WHERE film @> '{"title": "Cinema Paradiso"}'::jsonb; 

-- 코드 16-27: JSON에서 값 삭제하기

-- The Incredibles에 추가한 studio 키와 그 값을 제거
UPDATE films
SET film = film - 'studio'
WHERE film @> '{"title": "The Incredibles"}'::jsonb; 

-- Cinema Paradiso의 장르 배열에서 세 번째 요소 제거
UPDATE films
SET film = film #- '{genre, 2}'
WHERE film @> '{"title": "Cinema Paradiso"}'::jsonb; 


-- JSON 처리 함수 사용하기

-- 코드 16-28: 배열의 길이 찾기

SELECT id,
       film ->> 'title' AS title,
       jsonb_array_length(film -> 'characters') AS num_characters
FROM films
ORDER BY id;

-- 코드 16-29: 배열 요소를 행으로 반환하기

SELECT id,
       jsonb_array_elements(film -> 'genre') AS genre_jsonb,
       jsonb_array_elements_text(film -> 'genre') AS genre_text
FROM films
ORDER BY id;

-- 코드 16-30: 배열의 각 항목에서 키 값 반환

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
