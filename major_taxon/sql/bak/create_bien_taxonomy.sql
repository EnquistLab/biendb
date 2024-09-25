-- ----------------------------------------------------------------
-- Creates table bien_taxonomy
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- Create table bien_taxonom, extracting all distinct
-- scrubbed taxa and morphospecies from tnrs table
DROP TABLE IF EXISTS bien_taxonomy;
CREATE TABLE bien_taxonomy (
bien_taxonomy_id bigserial primary key,
taxon_id bigint,
family_taxon_id bigint,
genus_taxon_id bigint,
species_taxon_id bigint,
higher_plant_group text,
taxon_rank text,
"order" text DEFAULT NULL,
superorder text DEFAULT NULL,
subclass text DEFAULT NULL,
"class" text DEFAULT NULL,
division text DEFAULT NULL,
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
trait_measurements integer default 0
);