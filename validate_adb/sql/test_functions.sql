-- ------------------------------------------------------------------
-- Queries of BIEN database to test extensions and functions
-- All should return 't' (TRUE)
-- ------------------------------------------------------------------

-- Adjust db name and schemas according to your installation
\c vegbien
SET SEARCH_PATH TO analytical_db, postgis;

--
-- PostGIS: simple spatial query
-- 
SELECT EXISTS (
SELECT poi.taxonobservation_id, poi.country, poi.state_province, poi.county, poi.latitude, poi.longitude
FROM world_geom pol JOIN view_full_occurrence_individual poi
ON (ST_Within(poi.geom, pol.geom))
WHERE poi.taxonobservation_id=100634100
) AS spatial_query_works
;

--
-- ilike & lower
-- 
SELECT NOT EXISTS (
SELECT scrubbed_family 
FROM bien_taxonomy 
WHERE NOT scrubbed_family ILIKE '%aceae%' 
AND scrubbed_family IS NOT NULL 
AND LOWER(scrubbed_family)<>'incertae sedis'
) AS ilike_works;

--
-- Regexes
-- 

SELECT EXISTS (
SELECT * FROM
(
SELECT trim(regexp_replace(
regexp_replace(
name_submitted,
fam,
'',
'i'
)
, '\s+', ' ', 'g')) AS taxon
FROM 
(
SELECT DISTINCT fam, CONCAT_WS(' ', fam, sp) AS name_submitted
FROM (
SELECT scrubbed_family AS fam, scrubbed_species_binomial AS sp
FROM view_full_occurrence_individual
WHERE scrubbed_family IS NOT NULL AND scrubbed_species_binomial IS NOT NULL
AND scrubbed_genus='Larrea'  
) a
) AS doubled_fam
) AS no_fam
WHERE taxon NOT LIKE '%aceae %'
) AS regex_works
;


--
-- string_agg
-- 
SELECT EXISTS (
SELECT 
proximate_provider_name,
string_agg(source_name, ', ') AS dataset
FROM datasource
WHERE proximate_provider_name NOT IN ('GBIF','VegBank','REMIB','TEAM','SALVIAS')
GROUP BY proximate_provider_name
LIMIT 12
) AS string_agg_works
;

