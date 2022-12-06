---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------

-- 코드 4-1: 실전에서의 문자형 데이터 타입

CREATE TABLE char_data_types (
    char_column char(10),
    varchar_column varchar(10),
    text_column text
);

INSERT INTO char_data_types
VALUES
    ('abc', 'abc', 'abc'),
    ('defghi', 'defghi', 'defghi');

COPY char_data_types TO 'C:\YourDirectory\typetest.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');


-- 코드 4-2: 숫자 데이터 타입 활용하기

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

SELECT * FROM number_data_types;

-- 코드 4-3: 부동 소수점 열의 오류
-- 코드 4-2로 테이블이 생성되고 로드되었다고 가정하세요.

SELECT
    numeric_column * 10000000 AS fixed,
    real_column * 10000000 AS floating
FROM number_data_types
WHERE numeric_column = .7;

-- 코드 4-4: timestamp 타입과 interval 타입

CREATE TABLE date_time_types (
    timestamp_column timestamp with time zone,
    interval_column interval
);

INSERT INTO date_time_types
VALUES
    ('2022-12-31 01:00 EST','2 days'),
    ('2022-12-31 01:00 -8','1 month'),
    ('2022-12-31 01:00 Australia/Melbourne','1 century'),
    (now(),'1 week');

SELECT * FROM date_time_types;

-- 코드 4-5: interval 데이터 타입 사용하기
-- 코드 4-4를 실행 후 실행하세요

SELECT
    timestamp_column,
    interval_column,
    timestamp_column - interval_column AS new_date
FROM date_time_types;

-- 코드 4-6: CAST() 코드 3개

SELECT timestamp_column, CAST(timestamp_column AS varchar(10))
FROM date_time_types;

SELECT numeric_column,
       CAST(numeric_column AS integer),
       CAST(numeric_column AS text)
FROM number_data_types;

-- 작동하지 않는 코드입니다.
SELECT CAST(char_column AS integer) FROM char_data_types;

-- CAST를 이중 콜론(::)으로 대체한 코드입니다.
SELECT timestamp_column::varchar(10)
FROM date_time_types;
