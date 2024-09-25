-- -----------------------------------------------------------------------
-- Listing information on tables and columns, in particular adding and 
-- querying comments
-- -----------------------------------------------------------------------



--
-- Simple listing of all tables, columns and their data types and 
-- null attributes in schema. 
-- Does not include columns comments.
--

SELECT table_name, column_name, data_type, is_nullable as can_be_null
FROM information_schema.columns
WHERE table_schema = 'analytical_db_dev'
ORDER BY table_name, column_name
;

-- 
-- Return table comments
--

-- specific table
SELECT description 
FROM pg_description
JOIN pg_class ON pg_description.objoid = pg_class.oid
JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
WHERE relname = 'agg_traits' AND nspname='analytical_db_dev'
;

-- specific table, works same as above
SELECT description
FROM   pg_description
WHERE  objoid = 'analytical_db_dev.agg_traits'::regclass;

-- All tables in schema
SELECT relname AS table, description 
FROM pg_description
RIGHT JOIN pg_class ON pg_description.objoid = pg_class.oid
RIGHT JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
WHERE relkind='r' AND nspname='analytical_db_dev'
AND objsubid=0
ORDER BY relname
;

-- Only tables with comment
SELECT relname, description 
FROM pg_description
RIGHT JOIN pg_class ON pg_description.objoid = pg_class.oid
RIGHT JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
WHERE relkind='r' AND nspname='analytical_db_dev'
;


-- 
-- Column comments
-- 

-- All tables in schema, comments only
SELECT relname AS table, description 
FROM pg_description
RIGHT JOIN pg_class ON pg_description.objoid = pg_class.oid
RIGHT JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
WHERE relkind='r' AND nspname='analytical_db_dev'
AND objsubid>0
ORDER BY relname
;

-- all columns
SELECT relname AS table, description 
FROM (
SELECT objoid, description
FROM pg_description
WHERE objsubid>0
) a
RIGHT JOIN pg_class ON a.objoid = pg_class.oid
RIGHT JOIN pg_namespace ON pg_class.relnamespace = pg_namespace.oid
WHERE relkind='r' AND nspname='analytical_db_dev'
ORDER BY relname
;


SELECT 
cols.column_name,
(
SELECT pg_catalog.col_description(c.oid, cols.ordinal_position::int)
FROM pg_catalog.pg_class c
WHERE c.oid = (SELECT cols.table_name::regclass::oid) 
AND c.relname = cols.table_name
) as column_comment
FROM information_schema.columns cols
WHERE cols.table_catalog = 'vegbien' 
AND cols.table_schema  = 'analytical_db_dev'
AND cols.table_name    = 'agg_traits'
;   

-- Show all non-null column comments in schema
SELECT * FROM (
SELECT
cols.table_name,
cols.column_name,
cols.data_type,
(
SELECT pg_catalog.col_description(c.oid, cols.ordinal_position::int)
FROM pg_catalog.pg_class c
WHERE c.oid = (SELECT cols.table_name::regclass::oid) 
AND c.relname = cols.table_name
) as column_comment
FROM information_schema.columns cols
WHERE cols.table_catalog = 'vegbien' 
AND cols.table_schema  = 'analytical_db_dev'
) AS a
WHERE column_comment IS NOT NULL
; 

-- Show all column attributes for all tables in schema
SELECT
cols.table_name,
cols.column_name,
cols.data_type,
cols.is_nullable as can_be_null,
(
SELECT pg_catalog.col_description(c.oid, cols.ordinal_position::int)
FROM pg_catalog.pg_class c
WHERE c.oid = (SELECT cols.table_name::regclass::oid) 
AND c.relname = cols.table_name
) as column_description
FROM information_schema.columns cols
WHERE cols.table_catalog = 'vegbien' 
AND cols.table_schema  = 'analytical_db_dev'
ORDER BY cols.table_name, cols.column_name
; 

-- Filter for a particular table:
SELECT
cols.table_name,
cols.column_name,
cols.data_type,
cols.is_nullable as can_be_null,
(
SELECT pg_catalog.col_description(c.oid, cols.ordinal_position::int)
FROM pg_catalog.pg_class c
WHERE c.oid = (SELECT cols.table_name::regclass::oid) 
AND c.relname = cols.table_name
) as column_description
FROM information_schema.columns cols
WHERE cols.table_catalog = 'vegbien' 
AND cols.table_schema  = 'analytical_db_dev'
AND cols.table_name    = 'agg_traits'
ORDER BY cols.table_name
; 



-- 
-- Add comment to table or column
-- 
SET search_path TO analytical_db_dev;

COMMENT ON TABLE agg_traits IS 'Trait measurement of a taxon, with associated references. May or may not have associated locality information';
COMMENT ON COLUMN agg_traits.id IS 'Artificial integer identifier (primary key)';