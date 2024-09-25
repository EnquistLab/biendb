--
-- Restores all indexes on vfoi
--

SET search_path TO :sch;

-- Drop all the indexes, in case they already exist
DROP INDEX IF EXISTS bien_taxonomy_pkey;
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

-- Create them all
CREATE UNIQUE INDEX bien_taxonomy_pkey ON bien_taxonomy USING btree (bien_taxonomy_id);
CREATE INDEX bien_taxonomy_bien_taxonomy_id_txt_idx ON bien_taxonomy USING btree (bien_taxonomy_id_txt);
CREATE INDEX bien_taxonomy_class_idx ON bien_taxonomy USING btree (class);
CREATE INDEX bien_taxonomy_division_idx ON bien_taxonomy USING btree (division);
CREATE INDEX bien_taxonomy_higher_plant_group_idx ON bien_taxonomy USING btree (higher_plant_group);
CREATE INDEX bien_taxonomy_order_idx ON bien_taxonomy USING btree ("order");
CREATE INDEX bien_taxonomy_scrubbed_author_idx ON bien_taxonomy USING btree (scrubbed_author);
CREATE INDEX bien_taxonomy_scrubbed_family_idx ON bien_taxonomy USING btree (scrubbed_family);
CREATE INDEX bien_taxonomy_scrubbed_genus_idx ON bien_taxonomy USING btree (scrubbed_genus);
CREATE INDEX bien_taxonomy_scrubbed_species_binomial_idx ON bien_taxonomy USING btree (scrubbed_species_binomial);
CREATE INDEX bien_taxonomy_scrubbed_species_binomial_with_morphospecies_idx ON bien_taxonomy USING btree (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX bien_taxonomy_scrubbed_taxon_name_no_author_idx ON bien_taxonomy USING btree (scrubbed_taxon_name_no_author);
CREATE INDEX bien_taxonomy_scrubbed_taxonomic_status_idx ON bien_taxonomy USING btree (scrubbed_taxonomic_status);
CREATE INDEX bien_taxonomy_subclass_idx ON bien_taxonomy USING btree (subclass);
CREATE INDEX bien_taxonomy_superorder_idx ON bien_taxonomy USING btree (superorder);
