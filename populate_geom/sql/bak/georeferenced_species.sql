-- ---------------------------------------------------------
-- Outputs list of distinct species where geocoordinates are
-- not null
-- ---------------------------------------------------------

SET search_path TO :dev_schema, postgis;

-- Make sure indexes are already present or this will be 
-- REALLY slow

SELECT DISTINCT
scrubbed_species_binomial
FROM view_full_occurrence_individual_dev
WHERE (scrubbed_species_binomial is not null 
and latitude is not null 
and longitude is not null)
ORDER BY scrubbed_species_binomial
;