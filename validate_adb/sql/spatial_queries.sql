-- ------------------------------------------------------------
-- Verifies that geospatial queries are working
-- ------------------------------------------------------------

SET search_path TO :sch, postgis;

-- Check point in Costa Rica
SELECT EXISTS (
SELECT name_0 AS country
FROM world_geom
WHERE ST_Contains(
geom, ST_GeometryFromText('POINT(-85.296013 10.454120)', 4326)  
)
AND name_0='Costa Rica'
LIMIT 1
) AS a;

