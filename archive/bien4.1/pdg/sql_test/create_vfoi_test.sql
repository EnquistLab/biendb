SET search_path to analytical_db_dev2;

DROP TABLE IF EXISTS vfoi_test;
CREATE TABLE vfoi_test (LIKE analytical_db.view_full_occurrence_individual INCLUDING INDEXES INCLUDING CONSTRAINTS);

-- is_geovalid=1
INSERT INTO vfoi_test (
taxonobservation_id,
datasource,
dataset,
country_verbatim, 
state_province_verbatim, 
county_verbatim,
country,
state_province,
county,
is_new_world,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
latitude,
longitude,
geom
)
SELECT 
taxonobservation_id,
datasource,
dataset,
country_verbatim, 
state_province_verbatim, 
county_verbatim,
country,
state_province,
county,
is_new_world,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
latitude,
longitude,
geom
FROM analytical_db.view_full_occurrence_individual
WHERE is_geovalid=1
AND latitude IS NOT NULL AND longitude IS NOT NULL
AND country IS NOT NULL
LIMIT 1000
;

-- is_geovalid=0
INSERT INTO vfoi_test (
taxonobservation_id,
datasource,
dataset,
country_verbatim, 
state_province_verbatim, 
county_verbatim,
country,
state_province,
county,
is_new_world,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
latitude,
longitude,
geom
)
SELECT 
taxonobservation_id,
datasource,
dataset,
country_verbatim, 
state_province_verbatim, 
county_verbatim,
country,
state_province,
county,
is_new_world,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
latitude,
longitude,
geom
FROM analytical_db.view_full_occurrence_individual
WHERE is_geovalid=0
AND latitude IS NOT NULL AND longitude IS NOT NULL
AND country IS NOT NULL
LIMIT 1000
;

-- is_geovalid IS NULL
INSERT INTO vfoi_test (
taxonobservation_id,
datasource,
dataset,
country_verbatim, 
state_province_verbatim, 
county_verbatim,
country,
state_province,
county,
is_new_world,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
latitude,
longitude,
geom
)
SELECT 
taxonobservation_id,
datasource,
dataset,
country_verbatim, 
state_province_verbatim, 
county_verbatim,
country,
state_province,
county,
is_new_world,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
latitude,
longitude,
geom
FROM analytical_db.view_full_occurrence_individual
WHERE is_geovalid IS NULL
AND latitude IS NOT NULL AND longitude IS NOT NULL
AND country IS NOT NULL
LIMIT 1000
;

ALTER TABLE vfoi_test
ADD COLUMN test_desc text DEFAULT NULL,
ADD COLUMN test_ii_country text DEFAULT NULL,
ADD COLUMN test_ii_sp text DEFAULT NULL,
ADD COLUMN test_ii_county text DEFAULT NULL,
ADD COLUMN test_is_geovalid text DEFAULT NULL
;

