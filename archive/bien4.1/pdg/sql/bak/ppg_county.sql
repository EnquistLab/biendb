-- ------------------------------------------------------------------
-- Perform point-in-polygon check that geocoordinates fall within  
-- declared county
--  
-- Results in flag with three values:
-- 	1		Point is in polygon
-- 	0		Point not in polygon
--	NULL	Point not evaluated (no matching political division in
-- 			reference table
--  
-- Notes: 
-- 	1. Parameter :subset_where allows processing by subsets. Bes sure 
--	   to include "AND " at the start. If subsetting not needed, pass 
--	   parameter as empty string (""). 
-- 	2. Flag field should be integer data with default NULL
-- 	3. Political division fields should allow NULLs only (no empty 
-- 	   strings)
-- 	4. All where conditions and join columns MUST be indexed
-- ------------------------------------------------------------------
 
-- note addition of spatial schema to search_path
SET search_path TO :sch, postgis;

-- Set all records with matching political divisions as 'not in'
UPDATE :target_tbl AS poi
SET is_in_county=0
FROM :ref_tbl AS pol
WHERE :subset_where
poi.country=pol.country
AND poi.state_province=pol.state_province
AND poi.county=pol.county
;

-- Flag matching records where point is in
UPDATE :target_tbl AS poi
SET is_in_county=1
FROM :ref_tbl AS pol
WHERE :subset_where
poi.country=pol.country
AND poi.state_province=pol.state_province
AND poi.county=pol.county
AND (ST_Within(poi.geom, pol.geom))
;
