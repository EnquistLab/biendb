-- 
-- Transfer plot datasource info back to vfoi
-- 

BEGIN;

SET search_path TO public_vegbien_dev;

LOCK TABLE view_full_occurrence_individual_temp IN SHARE MODE;

-- Should be able to use UPDATE instead of CREATE TABLE AS
-- because nearly all indices have been removed
UPDATE vfoi_test AS a
SET 
dataset=b.dataset,
dataowner=b.primary_dataowner
FROM (
SELECT
datasource,
plot_name,
dataset,
primary_dataowner
FROM plot_provenance
) AS b
WHERE a.datasource=b.datasource
AND a.plot_name=b.plot_name
AND a.observation_type='plot'
;

COMMIT;