-- -------------------------------------------------------------
-- Flag as cultivated based proximity to herbarium or botanical
-- garden
-- -------------------------------------------------------------

SET search_path TO :sch;

-- Get all distances
TRUNCATE cultobs_herb_dist;		-- Clear the table for each iteration
INSERT INTO cultobs_herb_dist (
cultobs_id,
country,
herb_dist_km
)
SELECT 
cultobs_id, 
a.country,
public.geodistkm(a.latitude::numeric, a.longitude::numeric, b.lat::numeric, b.long::numeric)
FROM cultobs_sample a, cultobs_herbaria b
WHERE a.country=:'ctry' AND b.country=:'ctry'
AND a.done=0
;

-- 
-- Append minimum distance to min distance table
-- 
-- Use temp table to avoid calculations on main table
DROP TABLE IF EXISTS cultobs_herb_min_dist_temp;
CREATE TABLE cultobs_herb_min_dist_temp (LIKE cultobs_herb_min_dist);
INSERT INTO cultobs_herb_min_dist_temp (
cultobs_id, 
herb_min_dist_km,
is_cultivated_observation
)
SELECT 
cultobs_id,
MIN(herb_dist_km),
0
FROM cultobs_herb_dist
GROUP BY cultobs_id
;
UPDATE cultobs_herb_min_dist_temp
SET is_cultivated_observation=1
WHERE herb_min_dist_km<=:herb_min_dist
;

-- Append to main herb_dist table
INSERT INTO cultobs_herb_min_dist 
SELECT * FROM cultobs_herb_min_dist_temp;

-- Add PK to temp table to speed up next update
ALTER TABLE cultobs_herb_min_dist_temp ADD PRIMARY KEY (cultobs_id);

-- Update sample table by joining on temp table
-- Faster (few joins) than joining on main herb_dist table
UPDATE cultobs_sample a
SET done=1
FROM cultobs_herb_min_dist_temp b
WHERE a.cultobs_id=b.cultobs_id
AND a.done=0;
;

-- Drop the temp table
DROP TABLE cultobs_herb_min_dist_temp;


