-- ---------------------------------------------------------
-- Populated table endangered_taxa
-- ---------------------------------------------------------

SET search_path TO public_vegbien_dev;

TRUNCATE endangered_taxa;
INSERT INTO endangered_taxa (
taxon_scrubbed_canonical,
taxon_rank
)
SELECT DISTINCT 
taxon_scrubbed_canonical,
taxon_rank
FROM endangered_taxa_by_source
;

CREATE INDEX ON endangered_taxa (taxon_scrubbed_canonical);
CREATE INDEX ON endangered_taxa_by_source (taxon_scrubbed_canonical);

UPDATE endangered_taxa a
SET
cites_status=b.cites_status
FROM endangered_taxa_by_source b
WHERE a.taxon_scrubbed_canonical=b.taxon_scrubbed_canonical
AND b.cites_status IS NOT NULL
;

UPDATE endangered_taxa a
SET
iucn_status=b.iucn_status
FROM endangered_taxa_by_source b
WHERE a.taxon_scrubbed_canonical=b.taxon_scrubbed_canonical
AND b.iucn_status IS NOT NULL
;

UPDATE endangered_taxa a
SET
usda_status_fed=b.usda_status_fed
FROM endangered_taxa_by_source b
WHERE a.taxon_scrubbed_canonical=b.taxon_scrubbed_canonical
AND b.usda_status_fed IS NOT NULL
;

UPDATE endangered_taxa a
SET
usda_status_state=b.usda_status_state
FROM endangered_taxa_by_source b
WHERE a.taxon_scrubbed_canonical=b.taxon_scrubbed_canonical
AND b.usda_status_state IS NOT NULL
;

CREATE INDEX ON endangered_taxa (taxon_rank);
CREATE INDEX ON endangered_taxa (cites_status);
CREATE INDEX ON endangered_taxa (iucn_status);
CREATE INDEX ON endangered_taxa (usda_status_fed);
CREATE INDEX ON endangered_taxa (usda_status_state);
CREATE INDEX ON endangered_taxa (endangered_taxa_id);