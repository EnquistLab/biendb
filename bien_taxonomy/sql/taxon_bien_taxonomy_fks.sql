-- ----------------------------------------------------------------
-- Populate FKs to table taxon in bien_taxonomy
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- Join by family + taxon
-- Safer if homonyms present
UPDATE bien_taxonomy a
SET
taxon_id=b.taxon_id,
family_taxon_id=b.family_taxon_id,
genus_taxon_id=b.genus_taxon_id,
species_taxon_id=b.species_taxon_id
FROM taxon b
WHERE a.scrubbed_family=b.family
AND a.scrubbed_taxon_name_no_author=b.taxon
AND a.scrubbed_taxonomic_status NOT IN (
'Rejected name','Invalid','Illegitimate',''
)
AND a.scrubbed_taxonomic_status IS NOT NULL
;

-- Join remainder by taxon only
UPDATE bien_taxonomy a
SET
taxon_id=b.taxon_id,
family_taxon_id=b.family_taxon_id,
genus_taxon_id=b.genus_taxon_id,
species_taxon_id=b.species_taxon_id
FROM taxon b
WHERE a.scrubbed_taxon_name_no_author=b.taxon
AND a.scrubbed_family is null
AND a.taxon_id is null
AND a.scrubbed_taxonomic_status NOT IN (
'Rejected name','Invalid','Illegitimate',''
)
AND a.scrubbed_taxonomic_status IS NOT NULL
;

