-- ----------------------------------------------------------------
-- Generate text candidate PK in bien_taxonomy_dev 
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- ----------------------------------------------------------------
-- Generate index for joining back to original table
-- ----------------------------------------------------------------

-- Add temporary text candidate PK
ALTER TABLE bien_taxonomy_dev 
ADD COLUMN bien_taxonomy_id_txt text;

-- Populate by concatenating all taxonomic fields
UPDATE bien_taxonomy_dev
SET bien_taxonomy_id_txt=
CONCAT_WS('@',
COALESCE(higher_plant_group,''),
COALESCE(scrubbed_family,''), 
COALESCE(scrubbed_genus,''),
COALESCE(scrubbed_species_binomial,''), 
COALESCE(scrubbed_taxon_name_no_author,''),
COALESCE(scrubbed_author,''),
COALESCE(scrubbed_species_binomial_with_morphospecies,'')
);

-- Index it!
CREATE INDEX bien_taxonomy_bien_taxonomy_id_txt_idx ON bien_taxonomy_dev(bien_taxonomy_id_txt);

