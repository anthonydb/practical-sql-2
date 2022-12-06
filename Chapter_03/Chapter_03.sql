---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------

-- 코드 3-1: teachers 테이블의 모든 행과 열 조회하기

SELECT * FROM teachers;

-- Note that this standard SQL shorthand also works:

TABLE teachers;

-- 코드 3-2: 열의 하위 집합 쿼리하기

SELECT last_name, first_name, salary FROM teachers;

-- 코드 3-3: ORDER BY로 열 정렬하기

SELECT first_name, last_name, salary
FROM teachers
ORDER BY salary DESC;

-- 열 이름 대신 숫자도 입력할 수 있습니다. 정렬 기준으로 삼을 열을 지정할 때
-- 이름 대신 SELECT 절에서 해당 열이 반환되는 위치를 넣으면 됩니다.

SELECT first_name, last_name, salary
FROM teachers
ORDER BY 3 DESC;

-- 코드 3-4: ORDER BY를 사용해서 여러 열 정렬하기

SELECT last_name, school, hire_date
FROM teachers
ORDER BY school ASC, hire_date DESC;

-- 코드 3-5: school 열에서 별개의 값을 쿼리하기

SELECT DISTINCT school
FROM teachers
ORDER BY school;

-- 코드 3-6: school과 salary 열의 고유한 데이터 쌍 쿼리하기

SELECT DISTINCT school, salary
FROM teachers
ORDER BY school, salary;

-- 코드 3-7: WHERE를 사용하여 행 필터링하기

SELECT last_name, school, hire_date
FROM teachers
WHERE school = 'Myers Middle School';

-- WHERE와 비교 연산자 사용하기

-- Janet 이름을 가진 선생님 찾기
SELECT first_name, last_name, school
FROM teachers
WHERE first_name = 'Janet';

-- F.D. Roosevelt HS를 제외한 모든 학교 이름 출력하기
SELECT school
FROM teachers
WHERE school <> 'F.D. Roosevelt HS';

-- 2000년 1월 1일 이전에 고용된 선생님 출력하기
SELECT first_name, last_name, hire_date
FROM teachers
WHERE hire_date < '2000-01-01';

-- 연봉이 $43,500 이상인 선생님 찾기
SELECT first_name, last_name, salary
FROM teachers
WHERE salary >= 43500;

-- 연봉이 $40,000~$65,000인 선생님 찾기
SELECT first_name, last_name, school, salary
FROM teachers
WHERE salary BETWEEN 40000 AND 65000;

SELECT first_name, last_name, school, salary
FROM teachers
WHERE salary >= 40000 AND salary <= 65000;

-- 코드 3-8: LIKE와 ILIKE로 필터링하기

SELECT first_name
FROM teachers
WHERE first_name LIKE 'sam%';

SELECT first_name
FROM teachers
WHERE first_name ILIKE 'sam%';

-- 코드 3-9: AND와 OR를 사용해 조건 결합하기

SELECT *
FROM teachers
WHERE school = 'Myers Middle School'
      AND salary < 40000;

SELECT *
FROM teachers
WHERE last_name = 'Cole'
      OR last_name = 'Bush';

SELECT *
FROM teachers
WHERE school = 'F.D. Roosevelt HS'
      AND (salary < 38000 OR salary > 40000);

-- 괄호를 생략할 경우 결과가 어떻게 변화하는지 확인하세요.
-- AND 연산자를 OR 보다 먼저 평가합니다.

SELECT *
FROM teachers
WHERE school = 'F.D. Roosevelt HS'
      AND salary < 38000 OR salary > 40000;

-- 코드 3-10: WHERE과 ORDER BY를 포함한 SELECT 문

SELECT first_name, last_name, school, hire_date, salary
FROM teachers
WHERE school LIKE '%Roos%'
ORDER BY hire_date DESC;
