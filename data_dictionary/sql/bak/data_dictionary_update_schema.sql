-- !!!!!!!! UNDER CONSTRUCTION!!!!!

-- ---------------------------------------------------------------------
-- Transfer table and column comments from updated dictionary 
-- table to schema
-- ---------------------------------------------------------------------

SET search_path TO :sch;


SELECT 
pg_class.relname AS table_name,
pg_desc.description 
FROM 
(SELECT * FROM pg_description WHERE pg_description.objsubid = 0) AS pg_desc 
RIGHT JOIN pg_class 
ON pg_desc.objoid = pg_class.oid
RIGHT JOIN pg_namespace 
ON pg_class.relnamespace = pg_namespace.oid
WHERE pg_class.relkind = 'r'::"char"
AND pg_namespace.nspname = 'analytical_db_dev2'::name
;


SELECT 
pg_class.relname AS table_name,
pg_class.oid,
pg_desc.description 
FROM 
(SELECT * FROM pg_description WHERE pg_description.objsubid = 0) AS pg_desc 
RIGHT JOIN pg_class 
ON pg_desc.objoid = pg_class.oid
RIGHT JOIN pg_namespace 
ON pg_class.relnamespace = pg_namespace.oid
WHERE pg_class.relkind = 'r'::"char"
AND pg_namespace.nspname = 'analytical_db_dev2'::name
;


UPDATE pg_description a
SET description=b.description
FROM 