-- 
-- Adds count of all unique species to table bien_summary_public
--

SET search_path TO :dev_schema;

UPDATE bien_summary_public 
SET species_count=(
SELECT COUNT(DISTINCT scrubbed_species_binomial) 
FROM bien_taxonomy
WHERE scrubbed_species_binomial IS NOT NULL
AND observations>0
)
WHERE bien_summary_public_id=(
SELECT MAX(bien_summary_public_id) FROM bien_summary_public
)
;
