---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------

-- 코드 10-1: FSIS의 육류, 가금류 및 계란 검사 디렉터리 가져오기
-- https://catalog.data.gov/dataset/fsis-meat-poultry-and-egg-inspection-directory-by-establishment-name

CREATE TABLE meat_poultry_egg_establishments (
    establishment_number text CONSTRAINT est_number_key PRIMARY KEY,
    company text,
    street text,
    city text,
    st text,
    zip text,
    phone text,
    grant_date date,
    activities text,
    dbas text
);

COPY meat_poultry_egg_establishments
FROM 'C:\YourDirectory\MPI_Directory_by_Establishment_Name.csv'
WITH (FORMAT CSV, HEADER);

CREATE INDEX company_idx ON meat_poultry_egg_establishments (company);

-- Count the rows imported:
SELECT count(*) FROM meat_poultry_egg_establishments;

-- 코드 10-2: 같은 주소를 가진 여러 회사 찾기
SELECT company,
       street,
       city,
       st,
       count(*) AS address_count
FROM meat_poultry_egg_establishments
GROUP BY company, street, city, st
HAVING count(*) > 1
ORDER BY company, street, city, st;

-- 코드 10-3: 주 그룹화하고 세기
SELECT st, 
       count(*) AS st_count
FROM meat_poultry_egg_establishments
GROUP BY st
ORDER BY st;

-- 코드 10-4: IS NULL을 사용하여 st 열에서 결측 값 찾기
SELECT establishment_number,
       company,
       city,
       st,
       zip
FROM meat_poultry_egg_establishments
WHERE st IS NULL;

-- 코드 10-5: GROUP BY와 count()를 사용하여 일관성 없는 회사 이름 찾아내기

SELECT company,
       count(*) AS company_count
FROM meat_poultry_egg_establishments
GROUP BY company
ORDER BY company ASC;

-- 코드 10-6: length()와 count()를 사용하여 zip 열 테스트해 보기

SELECT length(zip),
       count(*) AS length_count
FROM meat_poultry_egg_establishments
GROUP BY length(zip)
ORDER BY length(zip) ASC;

-- 코드 10-7: zip 열에서 짧은 값을 찾기 위해 length()로 필터링하기

SELECT st,
       count(*) AS st_count
FROM meat_poultry_egg_establishments
WHERE length(zip) < 5
GROUP BY st
ORDER BY st ASC;

-- 코드 10-8: 테이블 백업하기

CREATE TABLE meat_poultry_egg_establishments_backup AS
SELECT * FROM meat_poultry_egg_establishments;

-- 레코드 수 확인:
SELECT 
    (SELECT count(*) FROM meat_poultry_egg_establishments) AS original,
    (SELECT count(*) FROM meat_poultry_egg_establishments_backup) AS backup;

-- 코드 10-9: ALTER TABLE과 UPDATE로 st_copy 열 만들기 및 채우기

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN st_copy text;

UPDATE meat_poultry_egg_establishments
SET st_copy = st;

-- 코드 10-10: st 및 st_copy 열의 값 확인하기

SELECT st,
       st_copy
FROM meat_poultry_egg_establishments
WHERE st IS DISTINCT FROM st_copy
ORDER BY st;

-- 코드 10-11: 3개 시설에 대한 st 열 업데이트하기

UPDATE meat_poultry_egg_establishments
SET st = 'MN'
WHERE establishment_number = 'V18677A';

UPDATE meat_poultry_egg_establishments
SET st = 'AL'
WHERE establishment_number = 'M45319+P45319';

UPDATE meat_poultry_egg_establishments
SET st = 'WI'
WHERE establishment_number = 'M263A+P263A+V263A'
RETURNING establishment_number, company, city, st, zip;

-- 코드 10-12: 원래의 st 열 값 복원하기

-- 백업한 열 복원하기
UPDATE meat_poultry_egg_establishments
SET st = st_copy;

-- 백업한 테이블 복원하기
UPDATE meat_poultry_egg_establishments original
SET st = backup.st
FROM meat_poultry_egg_establishments_backup backup
WHERE original.establishment_number = backup.establishment_number; 

-- 코드 10-13: company_standard 열 만들기 및 채우기

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN company_standard text;

UPDATE meat_poultry_egg_establishments
SET company_standard = company;

-- 코드 10-14: UPDATE 문을 사용하여 문자열과 일치하는 필드 값 수정하기

UPDATE meat_poultry_egg_establishments
SET company_standard = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%'
RETURNING company, company_standard;

-- 코드 10-15: zip_copy 열 생성 및 채우기

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN zip_copy text;

UPDATE meat_poultry_egg_establishments
SET zip_copy = zip;

-- 코드 10-16: 두 개의 선행 0이 누락된 zip 열의 코드 수정하기

UPDATE meat_poultry_egg_establishments
SET zip = '00' || zip
WHERE st IN('PR','VI') AND length(zip) = 3;

-- 코드 10-17: 한 개의 선행 0이 누락된 zip 열의 코드 수정하기

UPDATE meat_poultry_egg_establishments
SET zip = '0' || zip
WHERE st IN('CT','MA','ME','NH','NJ','RI','VT') AND length(zip) = 4;

-- 코드 10-18: state_regions 테이블 생성 및 채우기

CREATE TABLE state_regions (
    st text CONSTRAINT st_key PRIMARY KEY,
    region text NOT NULL
);

COPY state_regions
FROM 'C:\YourDirectory\state_regions.csv'
WITH (FORMAT CSV, HEADER);

-- 코드 10-19: inspection_deadline 열 추가 및 업데이트하기

ALTER TABLE meat_poultry_egg_establishments
    ADD COLUMN inspection_deadline timestamp with time zone;

UPDATE meat_poultry_egg_establishments establishments
SET inspection_deadline = '2022-12-01 00:00 EST'
WHERE EXISTS (SELECT state_regions.region
              FROM state_regions
              WHERE establishments.st = state_regions.st 
                    AND state_regions.region = 'New England');

-- 코드 10-20: 업데이트된 inspection_date 값 보기

SELECT st, inspection_deadline
FROM meat_poultry_egg_establishments
GROUP BY st, inspection_deadline
ORDER BY st;

-- 코드 10-21: 표현식과 일치하는 행 삭제하기

DELETE FROM meat_poultry_egg_establishments
WHERE st IN('AS','GU','MP','PR','VI');

-- 코드 10-22: DROP을 사용하여 테이블에서 열 제거하기

ALTER TABLE meat_poultry_egg_establishments DROP COLUMN zip_copy;

-- 코드 10-23: DROP을 사용하여 데이터베이스에서 테이블 제거하기

DROP TABLE meat_poultry_egg_establishments_backup;

-- 코드 10-24: 트랜잭션 블록 수행하기

-- 트랜잭션을 시작하고 업데이트하기
START TRANSACTION;

UPDATE meat_poultry_egg_establishments
SET company = 'AGRO Merchantss Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

-- 변경사항 확인하기
SELECT company
FROM meat_poultry_egg_establishments
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- 변경사항 무시하기
ROLLBACK;

-- 복구 내용 확인하기
SELECT company
FROM meat_poultry_egg_establishments
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- 변경 사항을 적용하려면 마지막에 COMMIT을 입력
START TRANSACTION;

UPDATE meat_poultry_egg_establishments
SET company = 'AGRO Merchants Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

COMMIT;

-- 코드 10-25: 새 열을 추가하고 채우면서 테이블 백업하기

CREATE TABLE meat_poultry_egg_establishments_backup AS
SELECT *,
       '2023-02-14 00:00 EST'::timestamp with time zone AS reviewed_date
FROM meat_poultry_egg_establishments;

-- 코드 10-26: ALTER TABLE을 사용하여 테이블 이름 바꾸기

ALTER TABLE meat_poultry_egg_establishments 
    RENAME TO meat_poultry_egg_establishments_temp;
ALTER TABLE meat_poultry_egg_establishments_backup 
    RENAME TO meat_poultry_egg_establishments;
ALTER TABLE meat_poultry_egg_establishments_temp 
    RENAME TO meat_poultry_egg_establishments_backup;


