-- 
-- Adds count of all unique species to table bien_summary
--

SET search_path TO :dev_schema;

UPDATE bien_summary 
SET species_count=(
SELECT COUNT(DISTINCT scrubbed_species_binomial) 
FROM bien_taxonomy
WHERE scrubbed_species_binomial IS NOT NULL
)
WHERE bien_summary_id=(
SELECT MAX(bien_summary_id) FROM bien_summary
)
;
