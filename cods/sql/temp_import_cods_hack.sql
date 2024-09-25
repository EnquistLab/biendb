-- ---------------------------------------------------------
-- Temporary hack to first part of cds_3_update.sh pipeline
-- Imports old schema CDS results and translates to new 
-- ---------------------------------------------------------

SET search_path TO :sch;

-- 
-- CREATE new-schema cods validation results tables
--

DROP TABLE IF EXISTS cods_proximity;
CREATE TABLE cods_proximity (
id SERIAL NOT NULL PRIMARY KEY,
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
\copy cods_proximity_oldschema_temp FROM '/home/boyle/bien/cods/data/cods_prox_submitted_cods_results.csv' DELIMITER ',' CSV HEADER 
\copy cods_keyword_oldschema_temp FROM '/home/boyle/bien/cods/data/cods_desc_submitted_cods_results.csv' DELIMITER ',' CSV HEADER 

-- Test
-- \copy cods_proximity_oldschema_temp FROM '/home/boyle/bien/cods/data/adb_test/bien_cods_prox_2021-02-10_cds_results.csv' DELIMITER ',' CSV HEADER 
-- \copy cods_keyword_oldschema_temp FROM '/home/boyle/bien/cods/data/adb_test/bien_cods_desc_2021-02-10_cds_results.csv' DELIMITER ',' CSV HEADER 

-- 
-- Insert validation results into new schema tables
--

INSERT INTO cods_proximity (
user_id,
latitude,
longitude,
dist_min_km,
dist_threshold_km,
is_cultivated_observation,
is_cultivated_observation_reason
) 
SELECT DISTINCT
CONCAT_WS('@', 
latitude::text,
longitude::text
),
latitude,
longitude,
dist_min_km,
dist_threshold_km,
is_cultivated_observation,
is_cultivated_observation_reason
FROM cods_proximity_oldschema_temp
;
DELETE FROM cods_proximity 
WHERE trim(user_id)='' OR user_id IS NULL
;

INSERT INTO cods_keyword (
id,
user_id,
description,
is_cultivated_observation,
is_cultivated_observation_reason
) 
SELECT DISTINCT
cods_key_id,
user_id,
description,
is_cultivated_observation,
is_cultivated_observation_reason
FROM cods_keyword_oldschema_temp
;
