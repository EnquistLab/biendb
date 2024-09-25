-- See: https://gis.stackexchange.com/questions/210387/querying-points-inside-and-outside-of-polygons/210389

SET search_path TO analytical_db,postgis;


-- Test of known valid coordinate; returns 1 row
SELECT poi.taxonobservation_id, poi.country, poi.state_province, poi.county, poi.latitude, poi.longitude
FROM world_geom pol JOIN view_full_occurrence_individual poi
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.taxonobservation_id=100634100
;

-- Test of known valid coordinate; returns nothing
SELECT poi.taxonobservation_id, poi.country, poi.state_province, poi.county, poi.latitude, poi.longitude
FROM world_geom pol JOIN view_full_occurrence_individual poi
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.taxonobservation_id=32633123
;

--
-- Is NOT in
-- 

-- Test of known valid coordinate; returns nothing
SELECT poi.taxonobservation_id, poi.country, poi.state_province, poi.county, poi.latitude, poi.longitude
FROM world_geom pol RIGHT JOIN view_full_occurrence_individual poi
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.taxonobservation_id=100634100
AND pol.ogc_fid IS NULL;

-- Test of known valid coordinate; returns 1 row
SELECT poi.taxonobservation_id, poi.country, poi.state_province, poi.county, poi.latitude, poi.longitude
FROM world_geom pol RIGHT JOIN view_full_occurrence_individual poi
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.taxonobservation_id=32633123
AND pol.ogc_fid IS NULL;
