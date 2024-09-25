-- ------------------------------------------------------------------
-- Populate geometry column by batches
-- 
-- Parameter :batch_were must start with " AND ". Or set to "" to
-- process all records 
-- ------------------------------------------------------------------
 
-- note addition of spatial schema to search_path
SET search_path TO :sch, postgis;

UPDATE :tbl 
SET geom = ST_GeomFromText('POINT(' || longitude || ' ' || latitude || ')',:SRID) 
WHERE (latitude IS NOT NULL AND longitude IS NOT NULL) 
:batch_where;