-- ---------------------------------------------------------
-- Extract data to be sent to CULTOBS from table vfoi
-- ---------------------------------------------------------

SET search_path TO :sch;

-- 
-- Create indexes needed for this operation
-- 

-- Partial index on is_cultivated_observation, conditioned on
-- latitude and longitude. Covers all the bases in one index!
-- Indexing the column with fewest values should be more efficient
DROP INDEX IF EXISTS vfoi_is_cultivated_observation_isnull_valid_latlong_idx;
CREATE INDEX vfoi_is_cultivated_observation_isnull_valid_latlong_idx ON view_full_occurrence_individual_dev (is_cultivated_observation)
WHERE latitude>=-90 AND latitude<=90
AND longitude>=-180 AND longitude<=180
AND is_cultivated_observation IS NULL
;

-- 
-- 1:1 extract, just the columns needed for CULTOBS
-- 

INSERT INTO cultobs (
tbl_name,
tbl_id,
description,
country,
state_province,
latitude,
longitude,
is_cultivated_observation,
is_cultivated_observation_basis 
)
SELECT
CAST('view_full_occurrence_individual' AS text),
taxonobservation_id,
trim(concat_ws(' ', 
locality, occurrence_remarks, vegetation_verbatim
)),
country,
state_province,
latitude,
longitude,
is_cultivated_observation,
NULL 
FROM view_full_occurrence_individual_dev
WHERE latitude>=-90 AND latitude<=90
AND longitude>=-180 AND longitude<=180
AND is_cultivated_observation IS NULL 
;
