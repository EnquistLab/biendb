-- ----------------------------------------------------------------
-- Link bien_taxonomy to tnrs results table using temporary text
-- PK/FK. Then update integer FK in table tnrs.
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- ----------------------------------------------------------------
-- Generate index for joining back to original table
-- ----------------------------------------------------------------

-- Add temporary text candidate PK to taxonomy table
ALTER TABLE bien_taxonomy 
ADD COLUMN bien_taxonomy_id_txt text;

-- Populate by concatenating all taxonomic fields
UPDATE bien_taxonomy
SET bien_taxonomy_id_txt=
CONCAT_WS('@',
COALESCE(scrubbed_family,''), 
COALESCE(scrubbed_genus,''),
COALESCE(scrubbed_specific_epithet,''), 
COALESCE(scrubbed_species_binomial,''), 
COALESCE(scrubbed_taxon_name_no_author,''),
COALESCE(scrubbed_taxon_canonical,''), 
COALESCE(scrubbed_author,''),
COALESCE(scrubbed_taxon_name_with_author,''),
COALESCE(scrubbed_species_binomial_with_morphospecies,'')
);

-- Index it!
CREATE INDEX bien_taxonomy_bien_taxonomy_id_txt_idx ON bien_taxonomy(bien_taxonomy_id_txt);

-- Add temporary text FK to tnrs table
ALTER TABLE tnrs 
ADD COLUMN bien_taxonomy_id_txt text;

-- Populate by concatenating all taxonomic fields
UPDATE tnrs
SET bien_taxonomy_id_txt=
CONCAT_WS('@',
COALESCE(scrubbed_family,''), 
COALESCE(scrubbed_genus,''),
COALESCE(scrubbed_specific_epithet,''), 
COALESCE(scrubbed_species_binomial,''), 
COALESCE(scrubbed_taxon_name_no_author,''),
COALESCE(scrubbed_taxon_canonical,''), 
COALESCE(scrubbed_author,''),
COALESCE(scrubbed_taxon_name_with_author,''),
COALESCE(scrubbed_species_binomial_with_morphospecies,'')
);

-- Index it!
CREATE INDEX tnrs_bien_taxonomy_id_txt_idx ON tnrs(bien_taxonomy_id_txt);

-- Now update the integer FK
UPDATE tnrs a
SET bien_taxonomy_id=b.bien_taxonomy_id
FROM bien_taxonomy b
WHERE a.bien_taxonomy_id_txt=b.bien_taxonomy_id_txt
;

-- Populate FK columns in remaining tnrs table
UPDATE tnrs_scrubbed a
SET bien_taxonomy_id=b.bien_taxonomy_id
FROM tnrs b
WHERE a.name_id=b.name_id
;

-- Index the FKs
DROP INDEX IF EXISTS tnrs_scrubbed_bien_taxonomy_id_idx;
CREATE INDEX tnrs_scrubbed_bien_taxonomy_id_idx ON tnrs_scrubbed (bien_taxonomy_id);
DROP INDEX IF EXISTS tnrs_bien_taxonomy_id_idx;
CREATE INDEX tnrs_bien_taxonomy_id_idx ON tnrs (bien_taxonomy_id);

-- Drop the temporary PK/FK columns
-- ALTER TABLE bien_taxonomy DROP COLUMN bien_taxonomy_id_txt;
-- ALTER TABLE tnrs DROP COLUMN bien_taxonomy_id_txt;

-- Update taxonomic status
-- Kept as separate step to avoid inserting duplicate
-- records for same name due to different taxonomic status in 
-- different sources. Shouldn't happen but possible.
UPDATE bien_taxonomy a
SET scrubbed_taxonomic_status=b.scrubbed_taxonomic_status
FROM tnrs b
WHERE a.bien_taxonomy_id=b.bien_taxonomy_id
AND a.scrubbed_species_binomial_with_morphospecies is not null
;