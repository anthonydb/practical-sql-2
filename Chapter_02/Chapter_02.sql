---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------

-- 코드 2-1: analysis 데이터베이스 생성

CREATE DATABASE analysis;

-- 코드 2-2: 6개의 열을 가진 teachers 테이블 생성

CREATE TABLE teachers (
    id bigserial,
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);

-- 아래 명령어는 테이블을 삭제합니다.
-- DROP TABLE teachers;

-- 코드 2-3 teachers 테이블에 데이터 삽입하기

INSERT INTO teachers (first_name, last_name, school, hire_date, salary)
VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
       ('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000),
       ('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500),
       ('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
       ('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500),
       ('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);
