-- ------------------------------------------------------------
-- Check for non-plant scrubbed families
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT NOT EXISTS (
SELECT scrubbed_family 
FROM bien_taxonomy 
WHERE NOT scrubbed_family ILIKE '%aceae%' 
AND scrubbed_family IS NOT NULL 
AND LOWER(scrubbed_family)<>'incertae sedis'
) AS no_bad_families;
