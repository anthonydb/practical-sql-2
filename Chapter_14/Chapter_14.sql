---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------


-- 자주 사용하는 문자열 함수
-- 참고: https://www.postgresql.org/docs/current/functions-string.html

-- 형식 지정
SELECT upper('Neal7');
SELECT lower('Randy');
SELECT initcap('at the end of the day');
-- Note initcap's imperfect for acronyms
SELECT initcap('Practical SQL');

-- 정보 찾기
SELECT char_length(' Pat ');
SELECT length(' Pat ');
SELECT position(', ' in 'Tan, Bella');

-- 문자 삭제
SELECT trim('s' from 'socks');
SELECT trim(trailing 's' from 'socks');
SELECT trim(' Pat ');
SELECT char_length(trim(' Pat ')); -- note the length change
SELECT ltrim('socks', 's');
SELECT rtrim('socks', 's');

-- 문자 추출 및 변경
SELECT left('703-555-1212', 3);
SELECT right('703-555-1212', 8);
SELECT replace('bat', 'b', 'c');


-- 표 14-2: 정규식 표기법을 사용한 예시들

-- 임의의 문자를 한 번 이상
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '.+');
-- 한 자리 또는 두 자리 숫자 뒤에 공백과 논캡쳐링 그룹에서 a.m. 또는 p.m.
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '\d{1,2} (?:a.m.|p.m.)');
-- 시작 부분에 하나 이상의 단어 문자
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '^\w+');
-- 끝에 임의의 문자가 오는 하나 이상의 단어 문자
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '\w+.$');
-- May 또는 June이라는 단어 중 하나
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from 'May|June');
-- 네 자리 수
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from '\d{4}');
-- May 뒤에 공백, 숫자, 쉼표, 공백, 네 자리 숫자
SELECT substring('The game starts at 7 p.m. on May 2, 2024.' from 'May \d, \d{4}');

-- 코드 14-1: WHERE 절에서 정규식 사용하기

SELECT county_name
FROM us_counties_pop_est_2019
WHERE county_name ~* '(lade|lare)'
ORDER BY county_name;

SELECT county_name
FROM us_counties_pop_est_2019
WHERE county_name ~* 'ash' AND county_name !~ 'Wash'
ORDER BY county_name;

-- 코드 14-2: 텍스트를 바꾸고 분할하는 정규식 함수

SELECT regexp_replace('05/12/2024', '\d{4}', '2023');

SELECT regexp_split_to_table('Four,score,and,seven,years,ago', ',');

SELECT regexp_split_to_array('Phil Mike Tony Steve', ' ');

-- 코드 14-3: 배열 길이 찾기

SELECT array_length(regexp_split_to_array('Phil Mike Tony Steve', ' '), 1);


-- 정규식을 활용해 텍스트를 데이터로 바꾸기

-- 코드 14-5: Ccrime_reports 테이블 생성하고 가져오기
-- https://sheriff.loudoun.gov/dailycrime

CREATE TABLE crime_reports (
    crime_id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    case_number text,
    date_1 timestamptz,  -- PostgreSQL에서만 사용할 수 있는 시간대가 적용된 타임스탬프 명칭입니다
    date_2 timestamptz,  -- PostgreSQL에서만 사용할 수 있는 시간대가 적용된 타임스탬프 명칭입니다
    street text,
    city text,
    crime_type text,
    description text,
    original_text text NOT NULL
);

COPY crime_reports (original_text)
FROM 'C:\YourDirectory\crime_reports.csv'
WITH (FORMAT CSV, HEADER OFF, QUOTE '"');

SELECT original_text FROM crime_reports;

-- 코드 14-6: regexp_match()를 사용하여 첫 번째로 범죄가 발생한 날짜 찾기
SELECT crime_id,
       regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports
ORDER BY crime_id;

-- 코드 14-7: g 플래그와 함께 regexp_matches() 함수 사용하기
SELECT crime_id,
       regexp_matches(original_text, '\d{1,2}\/\d{1,2}\/\d{2}', 'g')
FROM crime_reports
ORDER BY crime_id;

-- 코드 14-8: regexp_match()를 사용하여 두 번째 날짜 찾기
-- 결과에는 하이픈(-)이 포함됨
SELECT crime_id,
       regexp_match(original_text, '-\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports
ORDER BY crime_id;

-- 코드 14-9: 캡처 그룹을 사용하여 날짜만 반환하기
-- 하이픈 지우기
SELECT crime_id,
       regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})')
FROM crime_reports
ORDER BY crime_id;

-- 코드 14-10: 사건 번호, 날짜, 범죄 유형, 도시 일치시키기

SELECT
    regexp_match(original_text, '(?:C0|SO)[0-9]+') AS case_number,
    regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,
    regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,
    regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n')
        AS city
FROM crime_reports
ORDER BY crime_id;

-- 보너스: 한 번에 모든 값 얻어오기

SELECT crime_id,
       regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,
       CASE WHEN EXISTS (SELECT regexp_matches(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})'))
            THEN regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})')
            ELSE NULL
            END AS date_2,
       regexp_match(original_text, '\/\d{2}\n(\d{4})') AS hour_1,
       CASE WHEN EXISTS (SELECT regexp_matches(original_text, '\/\d{2}\n\d{4}-(\d{4})'))
            THEN regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})')
            ELSE NULL
            END AS hour_2,
       regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))') AS street,
       regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city,
       regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,
       regexp_match(original_text, ':\s(.+)(?:C0|SO)') AS description,
       regexp_match(original_text, '(?:C0|SO)[0-9]+') AS case_number
FROM crime_reports
ORDER BY crime_id;

-- 코드 14-11: 배열 내에서 값 가져오기

SELECT
    crime_id,
    (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1]
        AS case_number
FROM crime_reports
ORDER BY crime_id;

-- 코드 14-12: crime_reports 테이블의 date_1 열 업데이트하기

UPDATE crime_reports
SET date_1 = 
(
    (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
        || ' ' ||
    (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
        ||' US/Eastern'
)::timestamptz
RETURNING crime_id, date_1, original_text;

-- 코드 14-13: 모든 crime_reports 열 업데이트하기

UPDATE crime_reports
SET date_1 = 
    (
      (regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
          || ' ' ||
      (regexp_match(original_text, '\/\d{2}\n(\d{4})'))[1] 
          ||' US/Eastern'
    )::timestamptz,
             
    date_2 = 
    CASE 
    -- if there is no second date but there is a second hour
        WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})') IS NULL)
                     AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
        THEN 
          ((regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1]
              || ' ' ||
          (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
              ||' US/Eastern'
          )::timestamptz 

    -- if there is both a second date and second hour
        WHEN (SELECT regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})') IS NOT NULL)
              AND (SELECT regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})') IS NOT NULL)
        THEN 
          ((regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{2})'))[1]
              || ' ' ||
          (regexp_match(original_text, '\/\d{2}\n\d{4}-(\d{4})'))[1] 
              ||' US/Eastern'
          )::timestamptz 
    END,
    street = (regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1],
    city = (regexp_match(original_text,
                           '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n'))[1],
    crime_type = (regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):'))[1],
    description = (regexp_match(original_text, ':\s(.+)(?:C0|SO)'))[1],
    case_number = (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1];

-- 코드 14-14: 선택된 범죄 데이터 보기

SELECT date_1,
       street,
       city,
       crime_type
FROM crime_reports
ORDER BY crime_id;


-- 텍스트 검색 데이터 타입

-- & (AND)
-- | (OR)
-- ! (NOT)

-- 노트: PostgreSQL과 함께 설치된 추가 검색 언어 구성을 보려면 SELECT cfgname FROM pg_ts_config; 쿼리를 실행하세요.
SELECT cfgname FROM pg_ts_config;


-- 코드 14-15: 텍스트를 tsvector 데이터로 변환하기

SELECT to_tsvector('english', 'I am walking across the sitting room to sit with you.');

-- 코드 14-16: 검색어를 tsquery 데이터로 변환하기

SELECT to_tsquery('english', 'walking & sitting');

-- 코드 14-17: tsquery로 tsvector 타입 쿼리하기

SELECT to_tsvector('english', 'I am walking across the sitting room') @@
       to_tsquery('english', 'walking & sitting');

SELECT to_tsvector('english', 'I am walking across the sitting room') @@ 
       to_tsquery('english', 'walking & running');

-- 코드 14-18: president_speeches 테이블 만들고 채우기

-- 출처:
-- https://archive.org/details/State-of-the-Union-Addresses-1945-2006
-- https://www.presidency.ucsb.edu/documents/presidential-documents-archive-guidebook/annual-messages-congress-the-state-the-union
-- https://www.eisenhower.archives.gov/all_about_ike/speeches.html

CREATE TABLE president_speeches (
    president text NOT NULL,
    title text NOT NULL,
    speech_date date NOT NULL,
    speech_text text NOT NULL,
    search_speech_text tsvector,
    CONSTRAINT speech_key PRIMARY KEY (president, speech_date)
);

COPY president_speeches (president, title, speech_date, speech_text)
FROM 'C:\YourDirectory\president_speeches.csv'
WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@');

SELECT * FROM president_speeches ORDER BY speech_date;

-- 코드 14-19: search_speech_text 열에서 연설을 tsvector 타입으로 변환하기

UPDATE president_speeches
SET search_speech_text = to_tsvector('english', speech_text);

-- 코드 14-20: 텍스트 검색을 위한 GIN 인덱스 생성하기

CREATE INDEX search_idx ON president_speeches USING gin(search_speech_text);

-- 코드 14-21: 베트남이라는 단어가 포함된 연설 찾기

SELECT president, speech_date
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'Vietnam')
ORDER BY speech_date;

-- 코드 14-22: ts_headline()으로 검색 결과 표시하기

SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('english', 'tax'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'tax')
ORDER BY speech_date;


-- 코드 14-23: transportation이라는 단어는 언급하지만 roads는 언급하지 않는 연설 찾기

SELECT president,
       speech_date,
       ts_headline(speech_text,
                   to_tsquery('english', 'transportation & !roads'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@
      to_tsquery('english', 'transportation & !roads')
ORDER BY speech_date;

-- 코드 14-24: defense가 military를 뒤따르는 연설 찾기

SELECT president,
       speech_date,
       ts_headline(speech_text, 
                   to_tsquery('english', 'military <-> defense'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=1')
FROM president_speeches
WHERE search_speech_text @@ 
      to_tsquery('english', 'military <-> defense')
ORDER BY speech_date;

-- 보너스: military와 defense 사이에 단어가 두 게 끼어있는 연설 찾기:
SELECT president,
       speech_date,
       ts_headline(speech_text, 
                   to_tsquery('english', 'military <2> defense'),
                   'StartSel = <,
                    StopSel = >,
                    MinWords=5,
                    MaxWords=7,
                    MaxFragments=2')
FROM president_speeches
WHERE search_speech_text @@ 
      to_tsquery('english', 'military <2> defense')
ORDER BY speech_date;

-- 코드 14-25: ts_rank()를 사용해서 scoring relavance

SELECT president,
       speech_date,
       ts_rank(search_speech_text,
               to_tsquery('english', 'war & security & threat & enemy'))
               AS score
FROM president_speeches
WHERE search_speech_text @@ 
      to_tsquery('english', 'war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5;

-- 코드 14-26: Normalizing ts_rank() by speech length

SELECT president,
       speech_date,
       ts_rank(search_speech_text,
               to_tsquery('english', 'war & security & threat & enemy'), 2)::numeric 
               AS score
FROM president_speeches
WHERE search_speech_text @@ 
      to_tsquery('english', 'war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5;


