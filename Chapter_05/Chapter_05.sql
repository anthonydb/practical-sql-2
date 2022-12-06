---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------

-- 코드 5-1: COPY를 사용하여 데이터 가져오기
-- 문법 설명을 위한 뼈대입니다. 실행하면 오류가 발생합니다.

COPY table_name
FROM 'C:\YourDirectory\your_file.csv'
WITH (FORMAT CSV, HEADER);


-- 코드 5-2: 10년 주기 카운티 인구조사 추정치 테이블 생성 CREATE TABLE 문
-- 추정치의 데이터 사전: https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2019/co-est2019-alldata.pdf
-- 추가 열의 데이터 사전: http://www.census.gov/prod/cen2010/doc/pl94-171.pdf
-- 참고: 열에 따라 자기 설명적인 이름을 가진 열이 있습니다.

CREATE TABLE us_counties_pop_est_2019 (
    state_fips text,                         -- 주 미국 연방 정보 처리 표준(FIPS) 코드
    county_fips text,                        -- 카운티 미국 연방 정보 처리 표준(FIPS) 코드
    region smallint,                         -- 구역
    state_name text,                         -- 주 이름	
    county_name text,                        -- 카운티 이름
    area_land bigint,                        -- 토지 면적 (제곱미터)
    area_water bigint,                       -- 수면 면적 (제곱미터)
    internal_point_lat numeric(10,7),        -- 위도
    internal_point_lon numeric(10,7),        -- 경도
    pop_est_2018 integer,                    -- 2018년 7월 1일 기준 인구 추정치
    pop_est_2019 integer,                    -- 2019년 7월 1일 기준 인구 추정치
    births_2019 integer,                     -- 2018년 7월 1일부터 2019년 6월 30일 사이 출생자 수
    deaths_2019 integer,                     -- 2018년 7월 1일부터 2019년 6월 30일 사이 사망자 수
    international_migr_2019 integer,         -- 2018년 7월 1일부터 2019년 6월 30일 사이 순 국제 이주자 수
    domestic_migr_2019 integer,              -- 2018년 7월 1일부터 2019년 6월 30일 사이 순 지역 이주자 수
    residual_2019 integer,                   -- 일관성을 위해 추정치를 조정하는 데 사용되는 숫자
    CONSTRAINT counties_2019_key PRIMARY KEY (state_fips, county_fips)	
);

SELECT * FROM us_counties_pop_est_2019;

-- 코드 5-3: COPY를 이용한 인구조사 데이터 가져오기
-- 이 코드를 실행하다가 불러오기 오류가 발생할 시 1장을 따라 코드를 다운받으세요.
-- 윈도우 사용자의 경우 29페이지의 노트를 참고하세요.

COPY us_counties_pop_est_2019
FROM 'C:\YourDirectory\us_counties_pop_est_2019.csv'
WITH (FORMAT CSV, HEADER);

-- 데이터 확인하기

SELECT * FROM us_counties_pop_est_2019;

SELECT county_name, state_name, area_land
FROM us_counties_pop_est_2019
ORDER BY area_land DESC
LIMIT 3;

SELECT county_name, state_name, internal_point_lat, internal_point_lon
FROM us_counties_pop_est_2019
ORDER BY internal_point_lon DESC
LIMIT 5;


-- 코드 5-4: 관리자 급여를 추적하기 위한 테이블 만들기

CREATE TABLE supervisor_salaries (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    town text,
    county text,
    supervisor text,
    start_date text,
    salary numeric(10,2),
    benefits numeric(10,2)
);

-- 코드 5-5: CSV에서 세 개의 테이블 열로 급여 데이터 가져오기

COPY supervisor_salaries (town, supervisor, salary)
FROM 'C:\YourDirectory\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- 데이터 확인하기
SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;


-- 코드 5-6: WHERE로 행 하위 집합 가져오기

DELETE FROM supervisor_salaries;

COPY supervisor_salaries (town, supervisor, salary)
FROM 'C:\YourDirectory\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER)
WHERE town = 'New Brillig';

SELECT * FROM supervisor_salaries;


-- 코드 5-7: 가져오는 동안 임시 테이블을 사용하여 열에 기본값 추가하기

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

-- 데이터 확인하기
SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;


-- 코드 5-8: COPY로 전체 테이블 내보내기

COPY us_counties_pop_est_2019
TO 'C:\YourDirectory\us_counties_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');


-- 코드 5-9: Exporting selected columns from a table with COPY

COPY us_counties_pop_est_2019 
    (county_name, internal_point_lat, internal_point_lon)
TO 'C:\YourDirectory\us_counties_latlon_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- 코드 5-10: COPY를 이용한 쿼리 결과 내보내기

COPY (
    SELECT county_name, state_name
    FROM us_counties_pop_est_2019
    WHERE county_name ILIKE '%mill%'
     )
TO 'C:\YourDirectory\us_counties_mill_export.csv'
WITH (FORMAT CSV, HEADER);
