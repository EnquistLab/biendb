-- ----------------------------------------------------------------
-- Creates table bien_taxonomy of all final scrubbed taxon names 
-- and morphospecies in view_full_occurrence_individual_dev
-- NOTE LIMIT; remove for production!
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- ----------------------------------------------------------------
-- Create table bien_taxonomy_dev
-- ----------------------------------------------------------------

-- Create table bien_taxonom, extracting all distinct
-- scrubbed taxa and morphospecies from tnrs table
DROP TABLE IF EXISTS bien_taxonomy;
CREATE TABLE bien_taxonomy (
bien_taxonomy_id bigserial primary key,
taxon_id text,
family_taxon_id text,
genus_taxon_id text,
species_taxon_id text,
higher_plant_group text,
"order" text DEFAULT NULL,
superorder text DEFAULT NULL,
subclass text DEFAULT NULL,
"class" text DEFAULT NULL,
division" text DEFAULT NULL,
scrubbed_taxonomic_status text,
scrubbed_family text,
scrubbed_genus text,
scrubbed_specific_epithet text,
scrubbed_species_binomial text,
scrubbed_taxon_name_no_author text,
scrubbed_taxon_canonical text,
scrubbed_author text,
scrubbed_taxon_name_with_author text,
scrubbed_species_binomial_with_morphospecies text,
observations integer default 0,
trait_measurements integer default 0,
);

INSERT INTO bien_taxonomy (
scrubbed_taxonomic_status,
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
scrubbed_taxonomic_status,
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
;

-- Add indexes on all currently-populated columns
CREATE INDEX bien_taxonomy_higher_plant_group_idx ON bien_taxonomy_dev(higher_plant_group);
CREATE INDEX bien_taxonomy_scrubbed_family_idx ON bien_taxonomy_dev(scrubbed_family);
CREATE INDEX bien_taxonomy_scrubbed_genus_idx ON bien_taxonomy_dev(scrubbed_genus);
CREATE INDEX bien_taxonomy_scrubbed_species_binomial_idx ON bien_taxonomy_dev(scrubbed_species_binomial);
CREATE INDEX bien_taxonomy_scrubbed_taxon_name_no_author_idx ON bien_taxonomy_dev(scrubbed_taxon_name_no_author);
CREATE INDEX bien_taxonomy_scrubbed_author_idx ON bien_taxonomy_dev(scrubbed_author);
CREATE INDEX bien_taxonomy_scrubbed_species_binomial_with_morphospecies_idx ON bien_taxonomy_dev(scrubbed_species_binomial_with_morphospecies);

-- Adjust ownership and permissions
ALTER TABLE bien_taxonomy_dev OWNER TO bien;
