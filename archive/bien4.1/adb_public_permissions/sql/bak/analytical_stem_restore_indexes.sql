--
-- Restores all indexes on analytical_stem
--

SET search_path TO :sch;

-- Drop all the indexes, in case they already exist
DROP INDEX IF EXISTS analytical_stem_pkey;
DROP INDEX IF EXISTS analytical_stem_country_idx;
DROP INDEX IF EXISTS analytical_stem_county_idx;
DROP INDEX IF EXISTS analytical_stem_datasource_id_idx;
DROP INDEX IF EXISTS analytical_stem_datasource_idx;
DROP INDEX IF EXISTS analytical_stem_higher_plant_group_idx;
DROP INDEX IF EXISTS analytical_stem_is_cultivated_idx;
DROP INDEX IF EXISTS analytical_stem_is_geovalid_idx;
DROP INDEX IF EXISTS analytical_stem_is_new_world_idx;
DROP INDEX IF EXISTS analytical_stem_plot_area_idx;
DROP INDEX IF EXISTS analytical_stem_plot_metadata_id_idx;
DROP INDEX IF EXISTS analytical_stem_plot_name_idx;
DROP INDEX IF EXISTS analytical_stem_scrubbed_family_idx;
DROP INDEX IF EXISTS analytical_stem_scrubbed_genus_idx;
DROP INDEX IF EXISTS analytical_stem_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS analytical_stem_state_province_idx;
DROP INDEX IF EXISTS analytical_stem_subplot_idx;
DROP INDEX IF EXISTS analytical_stem_taxonobservation_id_fkey_idx;

-- Create them all
ALTER TABLE analytical_stem DROP COLUMN IF EXISTS analytical_stem_id;
ALTER TABLE analytical_stem ADD COLUMN analytical_stem_id BIGSERIAL PRIMARY KEY;
-- CREATE UNIQUE INDEX analytical_stem_pkey ON analytical_stem USING btree (analytical_stem_id);
CREATE INDEX analytical_stem_country_idx ON analytical_stem USING btree (country);
CREATE INDEX analytical_stem_county_idx ON analytical_stem USING btree (country, state_province, county) WHERE (county IS NOT NULL);
CREATE INDEX analytical_stem_datasource_id_idx ON analytical_stem USING btree (datasource_id);
CREATE INDEX analytical_stem_datasource_idx ON analytical_stem USING btree (datasource);
CREATE INDEX analytical_stem_higher_plant_group_idx ON analytical_stem USING btree (higher_plant_group);
CREATE INDEX analytical_stem_is_cultivated_idx ON analytical_stem USING btree (is_cultivated);
CREATE INDEX analytical_stem_is_geovalid_idx ON analytical_stem USING btree (is_geovalid);
CREATE INDEX analytical_stem_is_new_world_idx ON analytical_stem USING btree (is_new_world);
CREATE INDEX analytical_stem_plot_area_idx ON analytical_stem USING btree (plot_area_ha);
CREATE INDEX analytical_stem_plot_metadata_id_idx ON analytical_stem USING btree (plot_metadata_id);
CREATE INDEX analytical_stem_plot_name_idx ON analytical_stem USING btree (plot_name);
CREATE INDEX analytical_stem_scrubbed_family_idx ON analytical_stem USING btree (scrubbed_family);
CREATE INDEX analytical_stem_scrubbed_genus_idx ON analytical_stem USING btree (scrubbed_genus);
CREATE INDEX analytical_stem_scrubbed_species_binomial_idx ON analytical_stem USING btree (scrubbed_species_binomial);
CREATE INDEX analytical_stem_state_province_idx ON analytical_stem USING btree (country, state_province) WHERE (state_province IS NOT NULL);
CREATE INDEX analytical_stem_subplot_idx ON analytical_stem USING btree (subplot);
CREATE INDEX analytical_stem_taxonobservation_id_fkey_idx ON analytical_stem USING btree (taxonobservation_id);