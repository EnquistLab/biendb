-- ----------------------------------------------------------------
-- Fixes badly formed records for hybrid genera
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

UPDATE bien_taxonomy_dev
SET scrubbed_genus=scrubbed_species_binomial
WHERE scrubbed_genus='x'
;

UPDATE bien_taxonomy_dev
SET scrubbed_species_binomial=scrubbed_taxon_name_no_author
WHERE scrubbed_species_binomial LIKE 'x %'
AND scrubbed_species_binomial NOT LIKE 'x % %'
AND scrubbed_taxon_name_no_author LIKE 'x % %'
;