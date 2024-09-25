--
-- Restores all indexes on vfoi
--

SET search_path TO :sch;

-- Drop all the indexes, in case they already exist
DROP INDEX IF EXISTS agg_traits_pkey;
DROP INDEX IF EXISTS agg_traits_authorship_idx;
DROP INDEX IF EXISTS agg_traits_country_idx;
DROP INDEX IF EXISTS agg_traits_family_matched_idx;
DROP INDEX IF EXISTS agg_traits_fk_tnrs_user_id_idx;
DROP INDEX IF EXISTS agg_traits_higher_plant_group_idx;
DROP INDEX IF EXISTS agg_traits_matched_taxonomic_status_idx;
DROP INDEX IF EXISTS agg_traits_method_idx;
DROP INDEX IF EXISTS agg_traits_name_matched_idx;
DROP INDEX IF EXISTS agg_traits_name_submitted_idx;
DROP INDEX IF EXISTS agg_traits_project_pi_idx;
DROP INDEX IF EXISTS agg_traits_region_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_family_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_genus_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_with_morphospecies_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_taxon_canonical_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_taxon_name_no_author_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS agg_traits_source_idx;
DROP INDEX IF EXISTS agg_traits_stateprovince_idx;
DROP INDEX IF EXISTS agg_traits_trait_name_idx;
DROP INDEX IF EXISTS agg_traits_unit_idx;
DROP INDEX IF EXISTS agg_traits_verbatim_family_idx;
DROP INDEX IF EXISTS agg_traits_verbatim_scientific_name_idx;

-- Create them all
CREATE UNIQUE INDEX agg_traits_pkey ON agg_traits USING btree (id);
CREATE INDEX agg_traits_authorship_idx ON agg_traits USING btree (authorship);
CREATE INDEX agg_traits_country_idx ON agg_traits USING btree (country);
CREATE INDEX agg_traits_family_matched_idx ON agg_traits USING btree (family_matched);
CREATE INDEX agg_traits_fk_tnrs_user_id_idx ON agg_traits USING btree (fk_tnrs_user_id);
CREATE INDEX agg_traits_higher_plant_group_idx ON agg_traits USING btree (higher_plant_group);
CREATE INDEX agg_traits_matched_taxonomic_status_idx ON agg_traits USING btree (matched_taxonomic_status);
CREATE INDEX agg_traits_method_idx ON agg_traits USING btree (method);
CREATE INDEX agg_traits_name_matched_idx ON agg_traits USING btree (name_matched);
CREATE INDEX agg_traits_name_submitted_idx ON agg_traits USING btree (name_submitted);
CREATE INDEX agg_traits_project_pi_idx ON agg_traits USING btree (project_pi);
CREATE INDEX agg_traits_region_idx ON agg_traits USING btree (region);
CREATE INDEX agg_traits_scrubbed_family_idx ON agg_traits USING btree (scrubbed_family);
CREATE INDEX agg_traits_scrubbed_genus_idx ON agg_traits USING btree (scrubbed_genus);
CREATE INDEX agg_traits_scrubbed_species_binomial_idx ON agg_traits USING btree (scrubbed_species_binomial);
CREATE INDEX agg_traits_scrubbed_species_binomial_with_morphospecies_idx ON agg_traits USING btree (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX agg_traits_scrubbed_taxon_canonical_idx ON agg_traits USING btree (scrubbed_taxon_canonical);
CREATE INDEX agg_traits_scrubbed_taxon_name_no_author_idx ON agg_traits USING btree (scrubbed_taxon_name_no_author);
CREATE INDEX agg_traits_scrubbed_taxonomic_status_idx ON agg_traits USING btree (scrubbed_taxonomic_status);
CREATE INDEX agg_traits_source_idx ON agg_traits USING btree (source);
CREATE INDEX agg_traits_stateprovince_idx ON agg_traits USING btree (stateprovince);
CREATE INDEX agg_traits_trait_name_idx ON agg_traits USING btree (trait_name);
CREATE INDEX agg_traits_unit_idx ON agg_traits USING btree (unit);
CREATE INDEX agg_traits_verbatim_family_idx ON agg_traits USING btree (verbatim_family);
CREATE INDEX agg_traits_verbatim_scientific_name_idx ON agg_traits USING btree (verbatim_scientific_name);
