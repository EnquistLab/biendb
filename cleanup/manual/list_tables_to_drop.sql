-- --------------------------------------------------------------------- Generate list of tables to drop
-- 
-- If dump to filesystem, can be fed to READ statement to drop 
-- these tables
-- -------------------------------------------------------------------

-- Backup tables
select table_name 
from information_schema.tables
where table_schema='analytical_db_dev'
and (
table_name ilike '%_backup%' 
OR table_name ilike '%bak%'
) 
order by table_name
;

-- Temp tables
select table_name 
from information_schema.tables
where table_schema='analytical_db_dev'
and table_name ilike '%_temp%'
order by table_name
;


-- Staging tables
select table_name 
from information_schema.tables
where table_schema='analytical_db_dev'
and 
(
table_name ilike '%_staging%' or table_name ilike '%staging_%'
)
order by table_name
;

-- raw data
select table_name 
from information_schema.tables
where table_schema='analytical_db_dev'
and 
(
table_name ilike '%_raw%'
or table_name ilike '%_raw_%'
)
order by table_name
;

-- All combined. Comma allows easy search and replace to convert
-- to DROP TABLES statement
select table_name,','
from information_schema.tables
where table_schema='analytical_db_dev'
and (
(
table_name ilike '%_backup%' 
OR table_name ilike '%bak%'
) 
OR 
(table_name ilike '%_temp%')
OR 
(
table_name ilike '%_raw%'
or table_name ilike '%_raw_%'
)
OR
(
table_name ilike '%_staging%' or table_name ilike '%staging_%'
)
)
order by table_name
;

