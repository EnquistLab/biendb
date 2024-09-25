-- ----------------------------------------------------------------------
-- Manually import cds results produced using old schema to temp tables 
-- and transfer to new cds results tables
-- One-time operation only! All pipeline scripts updated to handle new
-- schema directly
-- Note:
-- 	* Must be logged in as superuser
-- 	* Final results tables cods_proximity and cods_keyword must exist
--	* After completion, resume pipeline at indexing of results tables 
-- ----------------------------------------------------------------------

\c vegbien
--set search_path to analytical_db_dev;  	-- Production
set search_path to analytical_db_test;		-- Test

-- 
-- Add simplified FK column to analytical tables
-- One time operation only! Added to pipeline, in future
-- will be done as part of cods_prepare step
-- 

ALTER TABLE view_full_occurrence_individual_dev
DROP COLUMN IF EXISTS latlong_text;
ALTER TABLE view_full_occurrence_individual_dev
ADD COLUMN latlong_text text DEFAULT NULL;

UPDATE view_full_occurrence_individual_dev
SET latlong_text=CONCAT_WS('@',
latitude::text,
longitude::text
)
WHERE is_geovalid=1
;

ALTER TABLE agg_traits
DROP COLUMN IF EXISTS latlong_text;
ALTER TABLE agg_traits
ADD COLUMN latlong_text text DEFAULT NULL;

UPDATE agg_traits
SET latlong_text=CONCAT_WS('@',
latitude::text,
longitude::text
)
WHERE is_geovalid=1
;

-- 
-- CREATE new-schema cods validation results tables
--

DROP TABLE IF EXISTS cods_proximity;
CREATE TABLE cods_proximity (
id INTEGER NOT NULL PRIMARY KEY,
user_id text,
latitude double precision,
longitude double precision,
dist_min_km  double precision,
dist_threshold_km integer,
institution_code text,
institution_name text,
is_cultivated_observation smallint,
is_cultivated_observation_reason text
);

DROP TABLE IF EXISTS cods_keyword;
CREATE TABLE cods_keyword (
id INTEGER NOT NULL PRIMARY KEY,
user_id text,
description text,
is_cultivated_observation smallint,
is_cultivated_observation_reason text
);

-- 
-- Create old schema tables
--

DROP TABLE IF EXISTS cods_proximity_oldschema_temp;
CREATE TABLE cods_proximity_oldschema_temp (
cods_id INTEGER NOT NULL PRIMARY KEY,
user_id text,
country_state_latlong text,
country text,
state_province text,
latitude_verbatim text,
longitude_verbatim text,
latitude double precision,
longitude double precision,
dist_min_km  double precision,
dist_threshold_km integer,
institution_code text,
institution_name text,
is_cultivated_observation smallint,
is_cultivated_observation_reason text
);

DROP TABLE IF EXISTS cods_keyword_oldschema_temp;
CREATE TABLE cods_keyword_oldschema_temp (
cods_key_id INTEGER NOT NULL PRIMARY KEY,
user_id text,
tbl_name text,
tbl_id integer,
description text,
is_cultivated_observation smallint,
is_cultivated_observation_reason text
);

-- 
-- Change new table owners to bien
--

ALTER TABLE cods_proximity OWNER TO bien;
ALTER TABLE cods_keyword OWNER TO bien;
ALTER TABLE cods_proximity_oldschema_temp OWNER TO bien;
ALTER TABLE cods_keyword_oldschema_temp OWNER TO bien;

-- 
-- Import validation results to old schema tables
--

-- Production
-- \copy cods_proximity_oldschema_temp FROM '/home/boyle/bien/cods/data/acods_prox_submitted_cds_results.csv' DELIMITER ',' CSV HEADER 
-- \copy cods_keyword_oldschema_temp FROM '/home/boyle/bien/cods/data/cods_desc_submitted_cds_results.csv' DELIMITER ',' CSV HEADER 

-- Test
\copy cods_proximity_oldschema_temp FROM '/home/boyle/bien/cods/data/adb_test/bien_cods_prox_2021-02-10_cds_results.csv' DELIMITER ',' CSV HEADER 
\copy cods_keyword_oldschema_temp FROM '/home/boyle/bien/cods/data/adb_test/bien_cods_desc_2021-02-10_cds_results.csv' DELIMITER ',' CSV HEADER 

-- 
-- Insert validation results into new schema tables
--

INSERT INTO cods_proximity (
id,
user_id,
latitude,
longitude,
dist_min_km,
dist_threshold_km,
institution_code,
institution_name,
is_cultivated_observation,
is_cultivated_observation_reason
) 
SELECT
cods_id,
CONCAT_WS('@', 
split_part(country_state_latlong,'@',3),
split_part(country_state_latlong,'@',4)
),
latitude,
longitude,
dist_min_km,
dist_threshold_km,
institution_code,
institution_name,
is_cultivated_observation,
is_cultivated_observation_reason
FROM cods_proximity_oldschema_temp
;

INSERT INTO cods_keyword (
id,
user_id,
description,
is_cultivated_observation,
is_cultivated_observation_reason
) 
SELECT
cods_key_id,
user_id,
description,
is_cultivated_observation,
is_cultivated_observation_reason
FROM cods_keyword_oldschema_temp
;
