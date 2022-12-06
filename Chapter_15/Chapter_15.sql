---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------


-- 코드 15-1: PostGIS 확장 사용

CREATE EXTENSION postgis;

SELECT postgis_full_version(); -- PostGIS 버전 확인

-- 코드 15-2: SRID 4326의 WKT 받아오기

SELECT srtext
FROM spatial_ref_sys
WHERE srid = 4326;

-- 코드 15-3: ST_GeomFromText() 함수로 공간 객체 만들기

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

-- 코드 15-4: ST_GeogFromText()로 공간 객체 생성

SELECT
ST_GeogFromText('SRID=4326;MULTIPOINT(-74.9 42.7, -75.1 42.7, -74.924 42.6)');

-- 코드 15-5: 점을 만드는 함수

SELECT ST_PointFromText('POINT(-74.9233606 42.699992)', 4326);

SELECT ST_MakePoint(-74.9233606, 42.699992);
SELECT ST_SetSRID(ST_MakePoint(-74.9233606, 42.699992), 4326);

-- 코드 15-6: 선을 만드는 함수

SELECT ST_LineFromText('LINESTRING(-105.90 35.67,-105.91 35.67)', 4326);
SELECT ST_MakeLine(ST_MakePoint(-74.9, 42.7), ST_MakePoint(-74.1, 42.4));

-- 코드 15-7: 폴리곤 객체를 만드는 함수들

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


-- 파머스마켓 데이터 분석하기
-- https://www.ams.usda.gov/local-food-directories/farmersmarkets


-- 코드 15-8: farmers_markets 테이블 생성 후 로드하기

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

SELECT count(*) FROM farmers_markets; -- 8,681개 행이 나와야 함

-- 코드 15-9: geography 열 생성 후 인덱스 부여
-- 함수도 있음. 참고: https://postgis.net/docs/AddGeometryColumn.html

-- 열 생성
ALTER TABLE farmers_markets ADD COLUMN geog_point geography(POINT,4326);

-- 열에 위도와 경도 채우기
UPDATE farmers_markets
SET geog_point = 
     ST_SetSRID(
               ST_MakePoint(longitude,latitude)::geography,4326
               );

-- GIST를 사용한 공간 데이터 추가
CREATE INDEX market_pts_idx ON farmers_markets USING GIST (geog_point);

-- geography 열 확인
SELECT longitude,
       latitude,
       geog_point,
       ST_AsEWKT(geog_point)
FROM farmers_markets
WHERE longitude IS NOT NULL
LIMIT 5;

-- 코드 15-10: ST_DWithin()를 사용한 10km 이내의 파머스마켓 찾기

SELECT market_name,
       city,
       st,
       geog_point
FROM farmers_markets
WHERE ST_DWithin(geog_point,
                 ST_GeogFromText('POINT(-93.6204386 41.5853202)'),
                 10000)
ORDER BY market_name;

-- 코드 15-11: ST_Distance()를 사용한 양키 스타디움과 시티 필드의 거리 구하기

SELECT ST_Distance(
                   ST_GeogFromText('POINT(-73.9283685 40.8296466)'),
                   ST_GeogFromText('POINT(-73.8480153 40.7570917)')
                   ) / 1000 AS mets_to_yanks;

-- 코드 15-12: farmers_markets의 각 행에 ST_Distance() 적용하기

SELECT market_name,
       city,
       round(
           (ST_Distance(geog_point,
                        ST_GeogFromText('POINT(-93.6204386 41.5853202)')
                        ) / 1000)::numeric, 2
            ) AS km_from_dt
FROM farmers_markets
WHERE ST_DWithin(geog_point,
                 ST_GeogFromText('POINT(-93.6204386 41.5853202)'),
                 10000)
ORDER BY km_from_dt ASC;

-- 코드 15-13: 최근접 이웃 검색에 <-> 거리 연산자 사용

SELECT market_name,
       city,
       st,
       round(
           (ST_Distance(geog_point,
                        ST_GeogFromText('POINT(-68.2041607 44.3876414)')
                        ) / 1000)::numeric, 2
            ) AS km_from_bh
FROM farmers_markets
ORDER BY geog_point <-> ST_GeogFromText('POINT(-68.2041607 44.3876414)')
LIMIT 3;

-- SHAPEFILE 사용하기

-- 자료:
   -- TIGER/Line® Shapefiles and TIGER/Line® Files
   -- https://www.census.gov/geo/maps-data/data/tiger-line.html
   -- Cartographic Boundary Shapefiles - Counties
   -- https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html


-- 불러오기 명령어에 대한 설명은 18장 참고
shp2pgsql -I -s 4269 -W LATIN1 tl_2019_us_county.shp us_counties_2019_shp | psql -d analysis -U postgres

-- 코드 15-14: geom 열의 WKT 표현 살펴보기

SELECT ST_AsText(geom)
FROM us_counties_2019_shp
ORDER BY gid
LIMIT 1;

-- 코드 15-15: ST_Area()로 가장 큰 넓이를 가진 지역 찾기

SELECT name,
       statefp AS st,
       round(
             ( ST_Area(geom::geography) / 1000000 )::numeric, 2
            )  AS square_km
FROM us_counties_2019_shp
ORDER BY square_km DESC
LIMIT 5;

-- 코드 15-16: ST_Within()을 사용해 좌표를 포함하는 카운티 찾기

SELECT sh.name,
       c.state_name
FROM us_counties_2019_shp sh JOIN us_counties_pop_est_2019 c
    ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE ST_Within(
         'SRID=4269;POINT(-118.3419063 34.0977076)'::geometry, geom
);

-- 코드 15-17: ST_DWithin()을 사용하여 네브래스카주 링컨 근처에 있는 사람 수 계산

SELECT sum(c.pop_est_2019) AS pop_est_2019
FROM us_counties_2019_shp sh JOIN us_counties_pop_est_2019 c
    ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE ST_DWithin(sh.geom::geography, 
          ST_GeogFromText('SRID=4269;POINT(-96.699656 40.811567)'),
          80467);
          
-- 참고: geom 열을 geography 타입으로 변환하는 인덱스를 생성하면 위 쿼리를 더 빠르게 실행할 수 있습니다.
CREATE INDEX us_counties_2019_shp_geog_idx ON us_counties_2019_shp USING GIST (CAST(geom AS geography));

-- 코드 15-18: 네브래스카주 링컨 근처의 카운티 출력

SELECT sh.name,
       c.state_name,
       c.pop_est_2019,
       ST_Transform(sh.geom, 4326) AS geom
FROM us_counties_2019_shp sh JOIN us_counties_pop_est_2019 c
    ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE ST_DWithin(sh.geom::geography, 
          ST_GeogFromText('SRID=4269;POINT(-96.699656 40.811567)'),
          80467);


-- 공간 데이터 조인하기
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


-- 데이터 불러오기
shp2pgsql -I -s 4269 -W LATIN1 tl_2019_35049_linearwater.shp santafe_linearwater_2019 | psql -d analysis -U postgres
shp2pgsql -I -s 4269 -W LATIN1 tl_2019_35049_roads.shp santafe_roads_2019 | psql -d analysis -U postgres

-- 코드 15-19: ST_GeometryType()으로 기하 찾기

SELECT ST_GeometryType(geom)
FROM santafe_linearwater_2019
LIMIT 1;

SELECT ST_GeometryType(geom)
FROM santafe_roads_2019
LIMIT 1;

-- 코드 15-20: ST_Intersects() 공간 조인을 이용해 산타페 강을 지나는 도로 찾기

SELECT water.fullname AS waterway,
       roads.rttyp,
       roads.fullname AS road
FROM santafe_linearwater_2019 water JOIN santafe_roads_2019 roads
    ON ST_Intersects(water.geom, roads.geom)
WHERE water.fullname = 'Santa Fe Riv' 
      AND roads.fullname IS NOT NULL
ORDER BY roads.fullname;

-- 코드 15-21: ST_Intersects()를 사용해 교차 지점 찾기

SELECT water.fullname AS waterway,
       roads.rttyp,
       roads.fullname AS road,
       ST_AsText(ST_Intersection(water.geom, roads.geom))
FROM santafe_linearwater_2019 water JOIN santafe_roads_2019 roads
    ON ST_Intersects(water.geom, roads.geom)
WHERE water.fullname = 'Santa Fe Riv'
      AND roads.fullname IS NOT NULL
ORDER BY roads.fullname;

