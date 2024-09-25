-- 
-- Adds partial not-null index on latitude and longitude
-- 

SET search_path TO :sch;

-- Indexed column does not matter, it's all in the WHERE clause
DROP INDEX IF EXISTS :idx_name;
CREATE INDEX :idx_name ON :tbl USING btree (:col)
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
