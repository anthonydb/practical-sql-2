---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------

-- VIEWS

-- 코드 17-1: 2019년도 네바다주의 카운티 목록을 뷰로 만들기

CREATE OR REPLACE VIEW nevada_counties_pop_2019 AS
    SELECT county_name,
           state_fips,
           county_fips,
           pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE state_name = 'Nevada';

-- 코드 17-2: nevada_counties_pop_2010 뷰 쿼리하기

SELECT *
FROM nevada_counties_pop_2019
ORDER BY county_fips
LIMIT 5;

-- 코드 17-3: 미국 카운티의 인구 변화율을 보여 주는 뷰 생성

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
        AND c2019.county_fips = c2010.county_fips;

-- 코드 17-4: county_pop_change_2019_2010 뷰에서 열 선택하기

SELECT county_name,
       state_name,
       pop_2019,
       pct_change_2019_2010
FROM county_pop_change_2019_2010
WHERE state_name = 'Nevada'
ORDER BY county_fips
LIMIT 5;

-- 코드 17-5: 구체화된 뷰 생성하기

DROP VIEW nevada_counties_pop_2019;

CREATE MATERIALIZED VIEW nevada_counties_pop_2019 AS
    SELECT county_name,
           state_fips,
           county_fips,
           pop_est_2019
    FROM us_counties_pop_est_2019
    WHERE state_name = 'Nevada';

-- 코드 17-6: 구체화된 뷰 새로고침하기

REFRESH MATERIALIZED VIEW nevada_counties_pop_2019;

-- OREFRESH MATERIALIZED VIEW CONCURRENTLY를 사용하면 새로고침 중에 뷰에 대해 실행되는 SELECT 문을 잠그지 않도록 할 수 있습니다. 자세한 내용은 https://www.postgresql.org/docs/current/sql-refreshmaterializedview.html에서 확인하세요.

CREATE UNIQUE INDEX nevada_counties_pop_2019_fips_idx ON nevada_counties_pop_2019 (state_fips, county_fips);
REFRESH MATERIALIZED VIEW CONCURRENTLY nevada_counties_pop_2019;

-- 구체화된 뷰를 삭제하려면 아래 명령어를 사용하세요
-- DROP MATERIALIZED VIEW nevada_counties_pop_2019;

-- 코드 17-7: employees 테이블에 뷰 만들기

-- employees 테이블 확인
SELECT * FROM employees ORDER BY emp_id;

-- 뷰 만들기
CREATE OR REPLACE VIEW employees_tax_dept WITH (security_barrier) AS
     SELECT emp_id,
            first_name,
            last_name,
            dept_id
     FROM employees
     WHERE dept_id = 1
     WITH LOCAL CHECK OPTION;

SELECT * FROM employees_tax_dept ORDER BY emp_id;

-- 코드 17-8: employees_tax_dept 뷰를 통해 성공한 추가와 실패한 추가

INSERT INTO employees_tax_dept (emp_id, first_name, last_name, dept_id)
VALUES (5, 'Suzanne', 'Legere', 1);

INSERT INTO employees_tax_dept (emp_id, first_name, last_name, dept_id)
VALUES (6, 'Jamil', 'White', 2);

SELECT * FROM employees_tax_dept ORDER BY emp_id;

SELECT * FROM employees ORDER BY emp_id;

-- 코드 17-9: employees_tax_dept 뷰를 통한 데이터 수정

UPDATE employees_tax_dept
SET last_name = 'Le Gere'
WHERE emp_id = 5;

SELECT * FROM employees_tax_dept ORDER BY emp_id;

-- 보너스: 해당 뷰에는 salary 열이 없어 아래 명령어는 실패합니다.
UPDATE employees_tax_dept
SET salary = 100000
WHERE emp_id = 5;

-- 코드 17-10: employees_tax_dept 뷰로 행 삭제하기

DELETE FROM employees_tax_dept
WHERE emp_id = 5;


-- 함수와 프로시저
-- https://www.postgresql.org/docs/current/sql-createfunction.html
-- https://www.postgresql.org/docs/current/sql-createprocedure.html
-- https://www.postgresql.org/docs/current/plpgsql.html

-- 코드 17-11: percent_change() 함수 만들기
-- 함수 삭제하는 법: DROP FUNCTION percent_change(numeric,numeric,integer);

CREATE OR REPLACE FUNCTION
percent_change(new_value numeric,
               old_value numeric,
               decimal_places integer DEFAULT 1)
RETURNS numeric AS
'SELECT round(
       ((new_value - old_value) / old_value) * 100, decimal_places
);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

-- 코드 17-12: percent_change() 함수 테스트

SELECT percent_change(110, 108, 2);

-- 코드 17-13: 인구조사 데이터에서 percent_change() 사용하기

SELECT c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019 AS pop_2019,
       percent_change(c2019.pop_est_2019,
                      c2010.estimates_base_2010) AS pct_chg_func,
       round( (c2019.pop_est_2019::numeric - c2010.estimates_base_2010)
           / c2010.estimates_base_2010 * 100, 1 ) AS pct_chg_formula
FROM us_counties_pop_est_2019 AS c2019
    JOIN us_counties_pop_est_2010 AS c2010
ON c2019.state_fips = c2010.state_fips
    AND c2019.county_fips = c2010.county_fips
ORDER BY pct_chg_func DESC
LIMIT 5;

-- 코드 17-14: teachers 테이블에 열 추가하기

ALTER TABLE teachers ADD COLUMN personal_days integer;

SELECT first_name,
       last_name,
       hire_date,
       personal_days
FROM teachers;

-- 코드 17-15: update_personal_days() 함수 만들기

CREATE OR REPLACE PROCEDURE update_personal_days()
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
END;
$$
LANGUAGE plpgsql;

-- 프로시저 실행
CALL update_personal_days();

-- 코드 17-16: PL/Python 절차 언어 사용하기

CREATE EXTENSION plpython3u;

-- 코드 17-17: PL/Python을 사용해 trim_county() 함수 만들기

CREATE OR REPLACE FUNCTION trim_county(input_string text)
RETURNS text AS $$
    import re
    cleaned = re.sub(r' County', '', input_string)
    return cleaned
$$
LANGUAGE plpython3u;

-- 코드 17-18: trim_county() 함수 테스트

SELECT county_name,
       trim_county(county_name)
FROM us_counties_pop_est_2019
ORDER BY state_fips, county_fips
LIMIT 5;


-- 트리거

-- 코드 17-19: grades 테이블과 grades_history 테이블 생성

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

-- 코드 17-20: record_if_grade_changed() 함수 작성

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
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 코드 17-21: grades_update 트리거 생성

CREATE TRIGGER grades_update
  AFTER UPDATE
  ON grades
  FOR EACH ROW
  EXECUTE PROCEDURE record_if_grade_changed();

-- 코드 17-22: grades_update 트리거 테스트

-- 기존 기록은 없습니다
SELECT * FROM grades_history;

-- grades 확인
SELECT * FROM grades ORDER BY student_id, course_id;

-- grade 업데이트
UPDATE grades
SET grade = 'C'
WHERE student_id = 1 AND course_id = 1;

-- 기록 확인
SELECT student_id,
       change_time,
       course,
       old_grade,
       new_grade
FROM grades_history;

-- 코드 17-23: temperature_test 테이블 생성

CREATE TABLE temperature_test (
    station_name text,
    observation_date date,
    max_temp integer,
    min_temp integer,
    max_temp_group text,
PRIMARY KEY (station_name, observation_date)
);

-- 코드 17-24: classify_max_temp() 함수 만들기

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

-- 코드 17-25: temperature_insert 트리거 생성

CREATE TRIGGER temperature_insert
    BEFORE INSERT
    ON temperature_test
    FOR EACH ROW
    EXECUTE PROCEDURE classify_max_temp();

-- 코드 17-26: temperature_insert 트리거 테스트를 위한 행 삽입

INSERT INTO temperature_test
VALUES
    ('North Station', '1/19/2023', 10, -3),
    ('North Station', '3/20/2023', 28, 19),
    ('North Station', '5/2/2023', 65, 42),
    ('North Station', '8/9/2023', 93, 74),
    ('North Station', '12/14/2023', NULL, NULL);

SELECT * FROM temperature_test ORDER BY observation_date;
