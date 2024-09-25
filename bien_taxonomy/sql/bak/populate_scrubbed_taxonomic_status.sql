-- ----------------------------------------------------------------
-- Populate taxonomic_status of scrubbed name
-- Note that this is NOT the same as taxonomic_status in vfoi,
-- which refers to the matched name.
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- Note that when matched name is a synonym, scrubbed
-- name is the accepted name and should be marked accordingly. 
-- In all other cases, scrubbed name is same as matched name
-- Also, taxonomic_status not populated for taxa not 
-- identified to species or below

-- Set taxonomic status='accepted' for taxa whose matched
-- name was accepted
UPDATE bien_taxonomy_dev AS a 
SET scrubbed_taxonomic_status='accepted'
FROM view_full_occurrence_individual_dev b
WHERE a.bien_taxonomy_id=b.bien_taxonomy_id
AND b.matched_taxonomic_status='accepted'
AND b.scrubbed_taxon_name_no_author IS NOT NULL
;

-- Matched synonyms which have been updated
UPDATE bien_taxonomy_dev AS a 
SET scrubbed_taxonomic_status='accepted'
FROM view_full_occurrence_individual_dev b
WHERE a.bien_taxonomy_id=b.bien_taxonomy_id
AND b.matched_taxonomic_status='synonym'
AND b.scrubbed_taxon_name_no_author=b.name_matched
AND (
b.scrubbed_author=b.name_matched_author OR 
( b.scrubbed_author IS NULL AND b.name_matched_author IS NULL )
);

-- Use matched name taxonomic status for any name not falling
-- into above category
UPDATE bien_taxonomy_dev AS a
SET scrubbed_taxonomic_status=b.matched_taxonomic_status
FROM view_full_occurrence_individual_dev b
WHERE a.bien_taxonomy_id=b.bien_taxonomy_id
AND a.scrubbed_taxonomic_status IS NULL
AND b.scrubbed_taxon_name_no_author IS NOT NULL
;

-- Add index on newly-populated column
-- DROP INDEX only needed for testing, harmless otherwise
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_taxonomic_status_idx;
CREATE INDEX bien_taxonomy_scrubbed_taxonomic_status_idx ON bien_taxonomy_dev(scrubbed_taxonomic_status);
