---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------

-- 코드 6-1: SQL을 사용한 기본적인 덧셈, 뺄셈, 곱셈

SELECT 2 + 2;    -- addition
SELECT 9 - 1;    -- subtraction
SELECT 3 * 4;    -- multiplication

-- 코드 6-2: SQL을 사용한 정수 및 소수 나누기

SELECT 11 / 6;   -- integer division
SELECT 11 % 6;   -- modulo division
SELECT 11.0 / 6; -- decimal division
SELECT CAST(11 AS numeric(3,1)) / 6;

-- 코드 6-3: SQL을 사용한 지수, 근과 팩토리얼

SELECT 3 ^ 4;         -- exponentiation
SELECT |/ 10;         -- square root (operator)
SELECT sqrt(10);      -- square root (function)
SELECT ||/ 10;        -- cube root
SELECT factorial(4);  -- factorial (function)
SELECT 4 !;           -- factorial (operator; PostgreSQL 13 and earlier only)


-- 연산자 우선순위 확인

SELECT 7 + 8 * 9; 	-- answer: 79
SELECT (7 + 8) * 9;	-- answer: 135

SELECT 3 ^ 3 - 1;   -- answer: 26
SELECT 3 ^ (3 - 1); -- answer: 9

-- 코드 6-4: 별칭을 사용한 인구 추정 열 선택

SELECT county_name AS county,
       state_name AS state,
       pop_est_2019 AS pop,
       births_2019 AS births,
       deaths_2019 AS deaths,
       international_migr_2019 AS int_migr,
       domestic_migr_2019 AS dom_migr,
       residual_2019 AS residual
FROM us_counties_pop_est_2019;

-- 코드 6-5: us_counties_pop_est_2019의 두 열의 차 구하기

SELECT county_name AS county,
       state_name AS state,
       births_2019 AS births,
       deaths_2019 AS deaths,
       births_2019 - deaths_2019 AS natural_increase
FROM us_counties_pop_est_2019
ORDER BY state_name, county_name;

-- 코드 6-6: 인구조사 데이터 총합 확인

SELECT county_name AS county,
       state_name AS state,
       pop_est_2019 AS pop,
       pop_est_2018 + births_2019 - deaths_2019 + 
           international_migr_2019 + domestic_migr_2019 +
           residual_2019 AS components_total,
       pop_est_2019 - (pop_est_2018 + births_2019 - deaths_2019 + 
           international_migr_2019 + domestic_migr_2019 +
           residual_2019) AS difference
FROM us_counties_pop_est_2019
ORDER BY difference DESC;

-- 코드 6-7: 카운티에서 물이 차지하는 면적 비율 구하기

SELECT county_name AS county,
       state_name AS state,
       area_water::numeric / (area_land + area_water) * 100 AS pct_water
FROM us_counties_pop_est_2019
ORDER BY pct_water DESC;


-- 코드 6-8: 변화율 계산하기

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

SELECT department,
       spend_2019,
       spend_2022,
       round( (spend_2022 - spend_2019) /
                    spend_2019 * 100, 1) AS pct_change
FROM percent_change;

-- 코드 6-9: 집계 함수 sum(), avg() 사용하기

SELECT sum(pop_est_2019) AS county_sum,
       round(avg(pop_est_2019), 0) AS county_average
FROM us_counties_pop_est_2019;

-- 코드 6-10: SQL 백분위수 함수 테스트하기

CREATE TABLE percentile_test (
    numbers integer
);

INSERT INTO percentile_test (numbers) VALUES
    (1), (2), (3), (4), (5), (6);

SELECT
    percentile_cont(.5)
    WITHIN GROUP (ORDER BY numbers),
    percentile_disc(.5)
    WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;

-- 코드 6-11: sum(), avg(), percentile_cont() 집계 함수 사용하기

SELECT sum(pop_est_2019) AS county_sum,
       round(avg(pop_est_2019), 0) AS county_average,
       percentile_cont(.5)
       WITHIN GROUP (ORDER BY pop_est_2019) AS county_median
FROM us_counties_pop_est_2019;

-- 코드 6-12: percentile_cont()에 값 배열 전달하기

-- 사분위수
SELECT percentile_cont(ARRAY[.25,.5,.75])
       WITHIN GROUP (ORDER BY pop_est_2019) AS quartiles
FROM us_counties_pop_est_2019;

-- 오분위수
SELECT percentile_cont(ARRAY[.2,.4,.6,.8])
       WITHIN GROUP (ORDER BY pop_est_2019) AS quintiles
FROM us_counties_pop_est_2019;

-- 십분위수
SELECT percentile_cont(ARRAY[.1,.2,.3,.4,.5,.6,.7,.8,.9])
       WITHIN GROUP (ORDER BY pop_est_2019) AS deciles
FROM us_counties_pop_est_2019;

-- 코드 6-13: 배열을 행으로 변환하는 unnest()

SELECT unnest(
            percentile_cont(ARRAY[.25,.5,.75])
            WITHIN GROUP (ORDER BY pop_est_2019)
            ) AS quartiles
FROM us_counties_pop_est_2019;

-- 코드 6-14: mode()를 사용한 최빈값 찾기

SELECT mode() WITHIN GROUP (ORDER BY births_2019)
FROM us_counties_pop_est_2019;
