-- 
-- Indexes the newly-populated geometry column
-- 

SET search_path TO :sch, postgis;

DROP INDEX IF EXISTS :idx_name;
CREATE INDEX :idx_name ON :tbl USING gist (geom);

