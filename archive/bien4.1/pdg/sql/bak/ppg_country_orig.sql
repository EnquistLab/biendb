-- ------------------------------------------------------------------
-- Perform point-in-polygon check that geocoordinates fall within  
-- declared country
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
 
-- Temporarily increase working memory
-- Remember to reset after last query in series
SET work_mem = :'wm_mb';

-- note addition of spatial schema to search_path
SET search_path TO :sch, postgis;

-- Set all records with matching political divisions as 'not in'
UPDATE :target_tbl AS poi
SET is_in_country=0
FROM :ref_tbl AS pol
WHERE :subset_where
poi.country=pol.country
AND poi.geom IS NOT NULL AND pol.geom IS NOT NULL
;

-- Flag matching records where point is in
UPDATE :target_tbl AS poi
SET is_in_country=1
FROM :ref_tbl AS pol
WHERE :subset_where
poi.country=pol.country
AND (ST_Within(poi.geom, pol.geom))
AND poi.geom IS NOT NULL AND pol.geom IS NOT NULL
;
