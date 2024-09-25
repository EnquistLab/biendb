SET search_path TO analytical_db_dev2, postgis;

-- 
-- Country
-- 

-- is_in_country=1
SELECT poi.country AS point_country, pol.country AS polygon_county, 
poi.is_in_country AS is_in_country_orig, poi.is_geovalid AS is_geovalid_orig,
'Point in declared country' AS result
FROM vfoi_test poi  JOIN world_geom pol
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.country=pol.country
;

-- is_in_country=0
SELECT poi.country AS point_country, pol.country AS polygon_county, 
poi.is_in_country AS is_in_country_orig, poi.is_geovalid AS is_geovalid_orig,
'Point NOT in declared country' AS result
FROM vfoi_test poi  JOIN world_geom pol
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.country<>pol.country
;

-- 
-- State/Province
-- 

-- is_in_state_province=1
SELECT poi.country AS point_country, poi.state_province,
pol.country AS polygon_county, pol.state_province,
poi.is_in_state_province AS is_in_sp_orig, poi.is_geovalid AS is_geovalid_orig,
'Point in declared state_province' AS result
FROM vfoi_test poi  JOIN world_geom pol
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.country=pol.country
AND poi.state_province=pol.state_province
;

-- is_in_state_province=0
SELECT poi.country AS point_country, poi.state_province,
pol.country AS polygon_county, pol.state_province,
poi.is_in_state_province AS is_in_sp_orig, poi.is_geovalid AS is_geovalid_orig,
'Point NOT in declared state_province' AS result
FROM vfoi_test poi  JOIN world_geom pol
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.country=pol.country
AND poi.state_province<>pol.state_province
;

-- is_in_state_province=NULL
SELECT taxonobservation_id AS point_id, poi.country AS point_country, poi.state_province_verbatim, poi.state_province,
pol.country AS polygon_country, pol.state_province, poi.is_geovalid AS is_geovalid_orig,
'Declared state_province not resolved' AS result
FROM vfoi_test poi  JOIN world_geom pol
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.country=pol.country
AND poi.state_province IS NULL
AND poi.state_province_verbatim IS NOT NULL AND TRIM(poi.state_province_verbatim)<>''
;

-- 
-- County/Parish
-- 

-- is_in_county=1
SELECT poi.country AS point_country, poi.state_province, poi.county,
pol.county AS polygon_county, poi.is_in_county AS is_in_county_orig, poi.is_geovalid AS is_geovalid_orig,
'Point in declared county/parish' AS result
FROM vfoi_test poi  JOIN world_geom pol
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.country=pol.country
AND poi.state_province=pol.state_province
AND poi.county=pol.county
;

-- is_in_county=0
SELECT poi.country AS point_country, poi.state_province, poi.county,
pol.county AS polygon_county, poi.is_in_county AS is_in_county_orig, poi.is_geovalid AS is_geovalid_orig,
'Point NOT in declared county/parish' AS result
FROM vfoi_test poi  JOIN world_geom pol
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.country=pol.country
AND poi.state_province=pol.state_province
AND poi.county<>pol.county
;
