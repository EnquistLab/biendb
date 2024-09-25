-- ---------------------------------------------------------
-- Extract CODS proximity data and make unique
-- ---------------------------------------------------------

SET search_path TO :sch;

INSERT INTO cods_prox_submitted (
latlong_text,
latitude,
longitude
)
SELECT 
latlong_text,
latitude,
longitude
FROM view_full_occurrence_individual_dev
WHERE is_geovalid=1
;
INSERT INTO cods_prox_submitted (
latlong_text,
latitude,
longitude
)
SELECT 
latlong_text,
latitude,
longitude
FROM agg_traits
WHERE is_geovalid=1
;

ALTER TABLE cods_prox_submitted RENAME TO cods_prox_submitted_temp;
CREATE TABLE cods_prox_submitted (LIKE cods_prox_submitted_temp INCLUDING ALL);
INSERT INTO cods_prox_submitted (
latlong_text,
latitude,
longitude
)
SELECT DISTINCT
latlong_text,
latitude,
longitude
FROM cods_prox_submitted_temp
;

DROP TABLE cods_prox_submitted_temp;

ALTER TABLE cods_prox_submitted
ADD COLUMN id SERIAL PRIMARY KEY
;