---------------------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data, 2nd Edition
-- by Anthony DeBarros

-- Chapter 19 Code Examples
----------------------------------------------------------------------------

-- VACUUM

-- Listing 19-1: Creating a table to test vacuuming

CREATE TABLE vacuum_test (
    integer_column integer
);

-- Listing 19-2: Determining the size of vacuum_test

SELECT pg_size_pretty(
           pg_total_relation_size('vacuum_test')
       );

-- optional: Determine database size   
SELECT pg_size_pretty(
           pg_database_size('analysis')
       );

-- Listing 19-3: Inserting 500,000 rows into vacuum_test

INSERT INTO vacuum_test
SELECT * FROM generate_series(1,500000);

-- Test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 19-4: Updating all rows in vacuum_test

UPDATE vacuum_test
SET integer_column = integer_column + 1;

-- Test its size again (35 MB)
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );

-- Listing 19-5: Viewing autovacuum statistics for vacuum_test

SELECT relname,
       last_vacuum,
       last_autovacuum,
       vacuum_count,
       autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- To see all columns available
SELECT *
FROM pg_stat_all_tables
WHERE relname = 'vacuum_test';

-- Listing 19-6: Running VACUUM manually

VACUUM vacuum_test;

VACUUM; -- vacuums the whole database

VACUUM VERBOSE; -- provides messages

-- Listing 19-7: Using VACUUM FULL to reclaim disk space

VACUUM FULL vacuum_test;

-- Test its size again
SELECT pg_size_pretty(
           pg_table_size('vacuum_test')
       );
       
-- SETTINGS

-- Listing 19-8: Showing the location of postgresql.conf

SHOW config_file;

-- Listing 19-9: Sample postgresql.conf settings (see book for listing)

-- Listing 19-10: Showing the location of the data directory

SHOW data_directory;

-- Reload settings using pg_ctl:
-- Mac and Linux: pg_ctl reload -D '/path/to/data/directory/'
-- Windows: pg_ctl reload -D "C:\path\to\data\directory\"

-- Reload settings using pg_reload_conf():
-- SELECT pg_reload_conf(); 


-- BACKUP AND RESTORE

-- Listing 19-11: Exporting the analysis database with pg_dump
pg_dump -d analysis -U [user_name] -Fc -v -f analysis_backup.dump

-- Export just a table
pg_dump -t 'train_rides' -d analysis -U [user_name] -Fc -v -f train_backup.dump

-- Listing 19-12: Restoring the analysis database with pg_restore

pg_restore -C -d postgres -U postgres analysis_backup.dump