-- ---------------------------------------------------------
-- Remove rank indicators from column scrubbed_taxon_canonical
-- for infraspecific taxa
-- only need to do var. and subsp. as no other rank indicators
-- in endangered species list
-- ---------------------------------------------------------

SET search_path TO public_vegbien_dev;

CREATE INDEX vfoi_is_infraspecific_idx ON view_full_occurrence_individual_dev (is_infraspecific);

UPDATE view_full_occurrence_individual_dev
SET scrubbed_taxon_canonical=REPLACE(scrubbed_taxon_canonical,' var. ',' ')
WHERE is_infraspecific=1
;

UPDATE view_full_occurrence_individual_dev
SET scrubbed_taxon_canonical=REPLACE(scrubbed_taxon_canonical,' subsp. ',' ')
WHERE is_infraspecific=1
;

DROP INDEX vfoi_is_infraspecific_idx;
