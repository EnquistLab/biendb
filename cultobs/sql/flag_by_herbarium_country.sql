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

-- Append minimum distance to min distance table
INSERT INTO cultobs_herb_min_dist (
cultobs_id, 
herb_min_dist_km
)
SELECT 
cultobs_id,
MIN(herb_dist_km)
FROM cultobs_herb_dist
GROUP BY cultobs_id
;

-- Update sample table
UPDATE cultobs_sample a
SET done=1
FROM cultobs_herb_min_dist b
WHERE a.cultobs_id=b.cultobs_id
AND a.done=0;
;