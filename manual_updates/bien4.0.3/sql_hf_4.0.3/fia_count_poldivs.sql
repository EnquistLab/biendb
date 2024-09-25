-- ----------------------------------------------------------------------
-- Create temporary table for inspecting political divisions associated
-- with FIA plots. For information only, not part of hotfix.
-- ----------------------------------------------------------------------


SET search_path TO analytical_db;

DROP TABLE IF EXISTS fia_poldivs;
CREATE TABLE fia_poldivs AS
SELECT country, state_province, county, count(*) AS obs
FROM view_full_occurrence_individual
WHERE observation_type='plot'
AND datasource='FIA'
GROUP BY country, state_province, county
ORDER BY country, state_province, county
;

--
-- Check verbatim political divisions where country, state or country are null
-- 

SELECT country_verbatim, state_province_verbatim, county_verbatim,
country, state_province
FROM view_full_occurrence_individual
WHERE observation_type='plot'
AND datasource='FIA'
AND county IS NULL
LIMIT 12
;

SELECT country_verbatim, state_province_verbatim, county_verbatim,
country
FROM view_full_occurrence_individual
WHERE observation_type='plot'
AND datasource='FIA'
AND state_province IS NULL
LIMIT 12
;

SELECT country_verbatim, state_province_verbatim, county_verbatim
FROM view_full_occurrence_individual
WHERE observation_type='plot'
AND datasource='FIA'
AND country IS NULL
LIMIT 12
;

