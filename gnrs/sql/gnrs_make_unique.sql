-- ---------------------------------------------------------
-- Workaround for duplicate records in gnrs results table
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS gnrs_temp;

-- The following converts any empty strings or all-whitespace values in
-- the first eight column into NULLs
CREATE TABLE gnrs_temp AS 
SELECT DISTINCT
poldiv_full,
CASE WHEN TRIM(COALESCE(country_verbatim,''))='' THEN NULL ELSE country_verbatim END AS country_verbatim,
CASE WHEN TRIM(COALESCE(state_province_verbatim,''))='' THEN NULL ELSE state_province_verbatim END AS state_province_verbatim,
CASE WHEN TRIM(COALESCE(state_province_verbatim_alt,''))='' THEN NULL ELSE state_province_verbatim_alt END AS state_province_verbatim_alt,
CASE WHEN TRIM(COALESCE(county_parish_verbatim,''))='' THEN NULL ELSE county_parish_verbatim END AS county_parish_verbatim,
CASE WHEN TRIM(COALESCE(county_parish_verbatim_alt,''))='' THEN NULL ELSE county_parish_verbatim_alt END AS county_parish_verbatim_alt,
CASE WHEN TRIM(COALESCE(country,''))='' THEN NULL ELSE country END AS country,
CASE WHEN TRIM(COALESCE(state_province,''))='' THEN NULL ELSE state_province END AS state_province,
CASE WHEN TRIM(COALESCE(county_parish,''))='' THEN NULL ELSE county_parish END AS county_parish,
country_id,
state_province_id,
county_parish_id,
country_iso,
state_province_iso,
county_parish_iso,
geonameid,
gid_0,
gid_1,
gid_2,
match_method_country,
match_method_state_province,
match_method_county_parish,
match_score_country,
match_score_state_province,
match_score_county_parish,
overall_score,
poldiv_submitted,
poldiv_matched,
match_status,
id
FROM gnrs
;
	
DROP TABLE IF EXISTS gnrs;
ALTER TABLE gnrs_temp RENAME TO gnrs;
