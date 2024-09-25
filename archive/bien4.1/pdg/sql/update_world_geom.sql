-- ---------------------------------------------------------
-- Update starndard political division columns 
-- with results of GNRS validations
-- ---------------------------------------------------------

SET search_path TO :sch;

UPDATE world_geom a
SET 
country=b.country,
state_province=b.state_province,
county=b.county_parish,
match_status=b.match_status
FROM world_geom_gnrs b
WHERE a.poldiv_full=b.poldiv_full
;