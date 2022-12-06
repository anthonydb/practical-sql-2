---------------------------------------------------------------------------
-- 실용 SQL
-- by Anthony DeBarros
----------------------------------------------------------------------------

-- VACUUM

-- 코드 19-1: Vaccum 테스트를 위한 테이블 생성

CREATE TABLE vacuum_test (
    integer_column integer
);

-- 코드 19-2: vacuum_test 테이블 크기 확인

SELECT pg_size_pretty(
           pg_total_relation_size('vacuum_test')
       );

-- 데이터베이스 용량 확인
SELECT pg_size_pretty(
           pg_database_size('analysis')
       );

-- 코드 19-3: vacuum_test 테이블에 행 50만 개 입력

INSERT INTO vacuum_test
SELECT * FROM generate_series(1,500000);

-- 데이터베이스 용량 확인
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- 코드 19-4: vacuum_test의 모든 행 업데이트

UPDATE vacuum_test
SET integer_column = integer_column + 1;

-- 데이터베이스 용량 확인 (35 MB)
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- 코드 19-5: vacuum_test의 autovacuum 통계 확인

SELECT relname,
       last_vacuum,
       last_autovacuum,
       vacuum_count,
       autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- 모든 열 확인
SELECT *
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- 코드 19-6: 수동으로 VACUUM 실행하기

VACUUM vacuum_test;

VACUUM; -- 데이터베이스 전체에 Vacuum 적용

VACUUM VERBOSE; -- 메시지 제공

-- 코드 19-7: VACUUM FULL로 디스크 용량 확보하기

VACUUM FULL vacuum_test;

-- 데이터베이스 용량 확인
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );
       
-- 서버 설정

-- 코드 19-8: postgresql.conf의 위치를 보여 주는 코드

SHOW config_file;

-- 코드 19-9: postgresql.conf 샘플 설정(책 확인)

-- 코드 19-10: 데이터 디렉터리 위치 확인

SHOW data_directory;

-- pg_ctl 설정 재로드하기
-- 맥/리눅스: pg_ctl reload -D '/path/to/data/directory/'
-- 윈도우: pg_ctl reload -D "C:\path\to\data\directory\"

-- pg_reload_conf()를 사용한 설정 재로드
-- SELECT pg_reload_conf(); 


-- 데이터베이스 백업과 복구

-- 코드 19-11: pg_dump로 analysis 데이터베이스 백업하기
pg_dump -d analysis -U [user_name] -Fc -v -f analysis_backup.dump

-- 테이블만 내보내기
pg_dump -t 'train_rides' -d analysis -U [user_name] -Fc -v -f train_backup.dump

-- 코드 19-12: pg_restore로 analysis 데이터베이스 복구하기

pg_restore -C -d postgres -U postgres analysis_backup.dump