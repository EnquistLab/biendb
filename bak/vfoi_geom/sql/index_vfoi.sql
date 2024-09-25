-- 
-- Adds non-spatial indexes needed for updating geometry column 
-- in next step
-- 

SET search_path TO :dev_schema, postgis;

DROP INDEX IF EXISTS vfoi_georeferenced_species_idx;
CREATE INDEX vfoi_georeferenced_species_idx ON view_full_occurrence_individual_dev USING btree (scrubbed_species_binomial)
WHERE scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL;

-- Fix apostrophe in one taxon name that is throwing off the updates
-- Doubling up single quote seems to work
-- Need a more generic way to purge single quotes, but this will do for now
UPDATE view_full_occurrence_individual_dev
SET scrubbed_taxon_name_no_author='Ewartia sinclairii intergen hybrid sinclairii x Helichrysum bellidioides',
scrubbed_specific_epithet='sinclairii',
scrubbed_species_binomial_with_morphospecies='Ewartia sinclairii intergen hybrid sinclairii x Helichrysum bellidioides',
scrubbed_species_binomial='Ewartia sinclairii'
WHERE scrubbed_species_binomial='Ewartia ''sinclairii'
AND scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL
;
