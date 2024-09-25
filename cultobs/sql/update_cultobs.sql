-- -------------------------------------------------------------
-- Transfer locality and herbarium validation results to 
-- main table
-- -------------------------------------------------------------

SET search_path TO :sch;


--
-- Drop all indexes on cultobs expect PK, update will be faster
-- 

DROP INDEX IF EXISTS cultobs_description_notnull_idx;
DROP INDEX IF EXISTS cultobs_latitude_idx;
DROP INDEX IF EXISTS cultobs_longitude_idx;
DROP INDEX IF EXISTS cultobs_tbl_name_idx;
DROP INDEX IF EXISTS cultobs_tbl_id_idx;

--
-- Add indexes to other tables needed for joins and where clauses
--

ALTER TABLE cultobs_herb_min_dist DROP CONSTRAINT IF EXISTS cultobs_herb_min_dist_pkey;
ALTER TABLE cultobs_herb_min_dist ADD PRIMARY KEY (cultobs_id);

ALTER TABLE cultobs_descriptions DROP CONSTRAINT IF EXISTS cultobs_descriptions_pkey;
ALTER TABLE cultobs_descriptions ADD PRIMARY KEY (cultobs_id);

DROP INDEX IF EXISTS cultobs_descriptions_is_cultivated_observation_idx;
CREATE INDEX cultobs_descriptions_is_cultivated_observation_idx ON cultobs_descriptions (is_cultivated_observation);


-- herbarium distance
UPDATE cultobs a
SET
is_cultivated_observation=
CASE
WHEN b.herb_min_dist_km<=:herb_min_dist THEN 1
ELSE 0
END,
is_cultivated_observation_basis=
CASE
WHEN b.herb_min_dist_km<=:herb_min_dist THEN 'Proximity to herbarium'
ELSE NULL
END,
herb_done=1
FROM cultobs_herb_min_dist b
WHERE a.cultobs_id=b.cultobs_id
;

-- Locality keywords
UPDATE cultobs a
SET
is_cultivated_observation=
CASE
WHEN b.is_cultivated_observation=1 THEN 1
ELSE a.is_cultivated_observation
END,
is_cultivated_observation_basis=
CASE
WHEN b.is_cultivated_observation=1 THEN 
TRIM(CONCAT_WS(' ',a.is_cultivated_observation_basis, 'Keywords in locality'))
ELSE a.is_cultivated_observation_basis
END,
loc_done=1
FROM cultobs_descriptions b
WHERE a.cultobs_id=b.cultobs_id
;

-- 
-- Add indexes to cultobs needed for updating original tables
-- 

DROP INDEX IF EXISTS cultobs_tbl_name_idx;
CREATE INDEX cultobs_tbl_name_idx ON cultobs (tbl_name);
DROP INDEX IF EXISTS cultobs_tbl_id_idx;
CREATE INDEX cultobs_tbl_id_idx ON cultobs (tbl_id);
