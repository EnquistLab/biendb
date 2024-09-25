-- -------------------------------------------------------------
-- Transfer locality validation results to main cultobs table
-- -------------------------------------------------------------

SET search_path TO :sch;

BEGIN;

--
-- Add indexes needed for joins and where clauses
--

ALTER TABLE cultobs_herb_min_dist DROP CONSTRAINT IF EXISTS cultobs_herb_min_dist_pkey;
ALTER TABLE cultobs_herb_min_dist ADD PRIMARY KEY (cultobs_id);

ALTER TABLE cultobs_descriptions DROP CONSTRAINT IF EXISTS cultobs_descriptions_pkey;
ALTER TABLE cultobs_descriptions ADD PRIMARY KEY (cultobs_id);

DROP INDEX IF EXISTS cultobs_descriptions_is_cultivated_observation_idx;
CREATE INDEX cultobs_descriptions_is_cultivated_observation_idx ON cultobs_descriptions (is_cultivated_observation);

-- 
-- Update using CREATE TABLE AS method due to size of table
--

-- Rename table
DROP TABLE IF EXISTS cultobs_temp;
ALTER TABLE cultobs RENAME TO cultobs_temp;

-- Insert into new index-free table
CREATE TABLE cultobs AS
SELECT
a.cultobs_id,
a.tbl_name,
a.tbl_id,
a.description,
a.country,
a.state_province,
a.latitude,
a.longitude,
CASE
WHEN b.is_cultivated_observation=1 OR c.is_cultivated_observation=1 THEN 1
ELSE a.is_cultivated_observation
END
AS is_cultivated_observation,
CASE
WHEN b.is_cultivated_observation=1 AND c.is_cultivated_observation=1 THEN 
'Proximity to herbarium | Keywords in locality'
WHEN b.is_cultivated_observation=1 AND (c.is_cultivated_observation=0 OR c.is_cultivated_observation IS NULL) THEN 'Keywords in locality'
WHEN c.is_cultivated_observation=1 AND (b.is_cultivated_observation=0 OR b.is_cultivated_observation IS NULL) THEN 'Proximity to herbarium'
ELSE NULL
END
AS is_cultivated_observation_basis,
CASE
WHEN b.cultobs_id IS NULL THEN 0
ELSE 1
END
AS loc_done,
CASE
WHEN c.cultobs_id IS NULL THEN 0
ELSE 1
END
AS herb_done
FROM cultobs_temp a LEFT JOIN cultobs_descriptions b
ON a.cultobs_id=b.cultobs_id
LEFT JOIN cultobs_herb_min_dist c
ON a.cultobs_id=c.cultobs_id
;