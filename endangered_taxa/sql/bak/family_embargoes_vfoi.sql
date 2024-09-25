-- ---------------------------------------------------------
-- Apply family_level taxon embargoes
-- ---------------------------------------------------------

SET search_path TO public_vegbien_dev;

CREATE INDEX vfoi_scrubbed_family_idx ON view_full_occurrence_individual_dev (scrubbed_family);

UPDATE view_full_occurrence_individual_dev a
SET 
cites=b.cites_status,
is_embargoed_observation=1
FROM endangered_taxa b
WHERE b.taxon_rank='family'
AND b.cites_status IS NOT NULL
AND a.scrubbed_family=b.taxon_scrubbed_canonical
;

-- Remove embargoes for abundance orchids and cacti
CREATE INDEX vfoi_scrubbed_species_binomial_idx ON view_full_occurrence_individual_dev (scrubbed_species_binomial);

UPDATE view_full_occurrence_individual_dev a
SET is_embargoed_observation=0
FROM public.bien_taxonomy b
WHERE b.scrubbed_family IN ('Orchidaceae','Cactaceae')
AND b.observations>=30
AND a.scrubbed_species_binomial=b.scrubbed_species_binomial
;

-- Drop index, no longer needed
DROP INDEX vfoi_scrubbed_species_binomial_idx;
DROP INDEX vfoi_scrubbed_family_idx;
