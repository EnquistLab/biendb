--
-- Drops all indexes on bien_taxonomy
--

SET search_path TO :sch;

-- Drop PK
-- Must drop constraints first, if any
ALTER TABLE bien_taxonomy DROP CONSTRAINT IF EXISTS bien_taxonomy_pkey;
DROP INDEX IF EXISTS bien_taxonomy_pkey;

-- Drop all the indexes, in case they already exist
DROP INDEX IF EXISTS bien_taxonomy_bien_taxonomy_id_txt_idx;
DROP INDEX IF EXISTS bien_taxonomy_class_idx;
DROP INDEX IF EXISTS bien_taxonomy_division_idx;
DROP INDEX IF EXISTS bien_taxonomy_higher_plant_group_idx;
DROP INDEX IF EXISTS bien_taxonomy_order_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_author_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_family_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_genus_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_species_binomial_with_morphospecies_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_taxon_name_no_author_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS bien_taxonomy_subclass_idx;
DROP INDEX IF EXISTS bien_taxonomy_superorder_idx;
DROP INDEX IF EXISTS bien_taxonomy_taxon_rank_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_specific_epithet_idx;