-- ----------------------------------------------------------------
-- Loads table bien_taxonomy with all final scrubbed taxon names 
-- and morphospecies from TNRS results table
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

INSERT INTO bien_taxonomy (
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical,
scrubbed_author,
scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies
)
SELECT DISTINCT 
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical,
scrubbed_author,
scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies
FROM tnrs
WHERE scrubbed_species_binomial_with_morphospecies IS NOT NULL
AND scrubbed_species_binomial_with_morphospecies<>''
;

-- Add indexes on all currently-populated columns
CREATE INDEX bien_taxonomy_scrubbed_family_idx ON bien_taxonomy(scrubbed_family);
CREATE INDEX bien_taxonomy_scrubbed_genus_idx ON bien_taxonomy(scrubbed_genus);
CREATE INDEX bien_taxonomy_scrubbed_specific_epithet_idx ON bien_taxonomy(scrubbed_specific_epithet);
CREATE INDEX bien_taxonomy_scrubbed_species_binomial_idx ON bien_taxonomy(scrubbed_species_binomial);
CREATE INDEX bien_taxonomy_scrubbed_taxon_name_no_author_idx ON bien_taxonomy(scrubbed_taxon_name_no_author);
CREATE INDEX bien_taxonomy_scrubbed_author_idx ON bien_taxonomy(scrubbed_author);
CREATE INDEX bien_taxonomy_scrubbed_species_binomial_with_morphospecies_idx ON bien_taxonomy(scrubbed_species_binomial_with_morphospecies);

-- Adjust ownership and permissions
ALTER TABLE bien_taxonomy OWNER TO bien;
