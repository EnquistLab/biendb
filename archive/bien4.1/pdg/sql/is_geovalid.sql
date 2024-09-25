-- -----------------------------------------------------------------
-- Calculates overall is_geovalid flag based on individual political
-- division geovalidation flags
-- 
-- Results in flag with three values:
-- 	1		Point is geovalid (inside all declared political divisions)
-- 	0		Point is not geovalid (outside at least on pol. div.)
--	NULL	Point not evaluated (no matching political division in
-- 		reference table)
--  
-- Notes: 
-- 	1. Parameter :subset_where allows processing by subsets. Bes sure 
--	   to include "AND " at the start. If subsetting not needed, pass 
--	   parameter as empty string (""). 
-- 	2. Flag field should be integer data with default NULL
-- 	3. Political division fields should allow NULLs only (no empty 
-- 	   strings)
-- 	4. All where conditions and join columns MUST be indexed

-- -----------------------------------------------------------------

SET search_path TO :sch;

-- Set is_geovalid=1 if any of the three flags is non-null
UPDATE :target_tbl
SET is_geovalid=1
WHERE :subset_where
( 
is_in_country IS NOT NULL 
OR is_in_state_province IS NOT NULL
OR is_in_county IS NOT NULL
)
;

-- Set is_geovalid=0 if any of the three flags=0
UPDATE :target_tbl
SET is_geovalid=0
WHERE :subset_where
(
is_in_country=0 
OR is_in_state_province=0
OR is_in_county=0
)
;
