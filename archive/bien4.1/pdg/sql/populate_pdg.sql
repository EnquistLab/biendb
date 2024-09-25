-- -----------------------------------------------------------
-- Populate table pdg with pdg validation input
-- Total hard-wired, for one-time use only
-- -----------------------------------------------------------

SET search_path TO :sch;

INSERT INTO pdg (
tbl_name,
tbl_id,
country,
state_province,
county,
latitude,
longitude
)
SELECT 
'agg_traits',
id,
country,
state_province,
county,
latitude,
longitude
FROM agg_traits
WHERE country IS NOT NULL
AND latitude IS NOT NULL
AND longitude IS NOT NULL
AND is_geovalid IS NULL
;

INSERT INTO pdg (
tbl_name,
tbl_id,
country,
state_province,
county,
latitude,
longitude,
geom
)
SELECT 
'view_full_occurrence_individual',
taxonobservation_id,
country,
state_province,
county,
latitude,
longitude,
geom
FROM view_full_occurrence_individual
WHERE country IS NOT NULL
AND latitude IS NOT NULL
AND longitude IS NOT NULL
AND is_geovalid IS NULL
AND geom IS NOT NULL
;


