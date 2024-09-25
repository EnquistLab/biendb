--
-- Restores all indexes on vfoi
-- 

-- --------------------------------------------------------------------
-- NOTE:
-- The following indexes and constraints should already be present 
-- as they were added in previous step (vfoi_geom):
-- vfoi_georeferenced_species_idx
-- vfoi_gist_idx
-- enforce_dimensions_geom
-- enforce_geometrytype_geom
-- enforce_srid_geom
-- --------------------------------------------------------------------

SET search_path TO :dev_schema;

-- Drop all the indexes, in case they already exist
-- DROP INDEX IF EXISTS vfoi_pkey;
DROP INDEX IF EXISTS vfoi_bien_taxonomy_id_idx;
DROP INDEX IF EXISTS vfoi_cites_idx;
DROP INDEX IF EXISTS vfoi_country_idx;
DROP INDEX IF EXISTS vfoi_country_species_idx;
DROP INDEX IF EXISTS vfoi_county_idx;
DROP INDEX IF EXISTS vfoi_dataowner_idx;
DROP INDEX IF EXISTS vfoi_dataset_idx;
DROP INDEX IF EXISTS vfoi_datasource_id_idx;
DROP INDEX IF EXISTS vfoi_datasource_idx;
DROP INDEX IF EXISTS vfoi_higher_plant_group_idx;
DROP INDEX IF EXISTS vfoi_is_cultivated_idx;
DROP INDEX IF EXISTS vfoi_is_embargoed_observation_idx;
DROP INDEX IF EXISTS vfoi_is_geovalid_idx;
DROP INDEX IF EXISTS vfoi_is_new_world_idx;
DROP INDEX IF EXISTS vfoi_iscultivated_nsr_idx;
DROP INDEX IF EXISTS vfoi_isintroduced;
DROP INDEX IF EXISTS vfoi_iucn_idx;
DROP INDEX IF EXISTS vfoi_native_status_idx;
DROP INDEX IF EXISTS vfoi_observation_type_idx;
DROP INDEX IF EXISTS vfoi_plot_area_idx;
DROP INDEX IF EXISTS vfoi_plot_metadata_id_idx;
DROP INDEX IF EXISTS vfoi_plot_name_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_family_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_genus_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS vfoi_state_province_idx;
DROP INDEX IF EXISTS vfoi_subplot_idx;
DROP INDEX IF EXISTS vfoi_matched_taxonomic_status_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS vfoi_usda_federal_idx;
DROP INDEX IF EXISTS vfoi_usda_state_idx;
DROP INDEX IF EXISTS vfoi_validated_nw_species_idx;
DROP INDEX IF EXISTS vfoi_is_geovalid_latlong_notnull_idx;

-- Create them all
-- CREATE UNIQUE INDEX vfoi_pkey ON view_full_occurrence_individual USING btree (taxonobservation_id);
CREATE INDEX vfoi_bien_taxonomy_id_idx ON view_full_occurrence_individual USING btree (bien_taxonomy_id);
CREATE INDEX vfoi_cites_idx ON view_full_occurrence_individual USING btree (cites);
CREATE INDEX vfoi_country_idx ON view_full_occurrence_individual USING btree (country);
CREATE INDEX vfoi_country_species_idx ON view_full_occurrence_individual USING btree (country, scrubbed_species_binomial);
CREATE INDEX vfoi_county_idx ON view_full_occurrence_individual USING btree (country, state_province, county) WHERE (county IS NOT NULL);
CREATE INDEX vfoi_dataowner_idx ON view_full_occurrence_individual USING btree (dataowner);
CREATE INDEX vfoi_dataset_idx ON view_full_occurrence_individual USING btree (dataset);
CREATE INDEX vfoi_datasource_id_idx ON view_full_occurrence_individual USING btree (datasource_id);
CREATE INDEX vfoi_datasource_idx ON view_full_occurrence_individual USING btree (datasource);
CREATE INDEX vfoi_higher_plant_group_idx ON view_full_occurrence_individual USING btree (higher_plant_group);
CREATE INDEX vfoi_is_cultivated_idx ON view_full_occurrence_individual USING btree (is_cultivated);
CREATE INDEX vfoi_is_embargoed_observation_idx ON view_full_occurrence_individual USING btree (is_embargoed_observation);
CREATE INDEX vfoi_is_geovalid_idx ON view_full_occurrence_individual USING btree (is_geovalid);
CREATE INDEX vfoi_is_new_world_idx ON view_full_occurrence_individual USING btree (is_new_world);
CREATE INDEX vfoi_iscultivated_nsr_idx ON view_full_occurrence_individual USING btree (is_cultivated_in_region);
CREATE INDEX vfoi_isintroduced ON view_full_occurrence_individual USING btree (isintroduced);
CREATE INDEX vfoi_iucn_idx ON view_full_occurrence_individual USING btree (iucn);
CREATE INDEX vfoi_native_status_idx ON view_full_occurrence_individual USING btree (native_status);
CREATE INDEX vfoi_observation_type_idx ON view_full_occurrence_individual USING btree (observation_type);
CREATE INDEX vfoi_plot_area_idx ON view_full_occurrence_individual USING btree (plot_area_ha);
CREATE INDEX vfoi_plot_metadata_id_idx ON view_full_occurrence_individual USING btree (plot_metadata_id);
CREATE INDEX vfoi_plot_name_idx ON view_full_occurrence_individual USING btree (plot_name);
CREATE INDEX vfoi_scrubbed_family_idx ON view_full_occurrence_individual USING btree (scrubbed_family);
CREATE INDEX vfoi_scrubbed_genus_idx ON view_full_occurrence_individual USING btree (scrubbed_genus);
CREATE INDEX vfoi_scrubbed_species_binomial_idx ON view_full_occurrence_individual USING btree (scrubbed_species_binomial);
CREATE INDEX vfoi_state_province_idx ON view_full_occurrence_individual USING btree (country, state_province) WHERE (state_province IS NOT NULL);
CREATE INDEX vfoi_subplot_idx ON view_full_occurrence_individual USING btree (subplot);
CREATE INDEX vfoi_matched_taxonomic_status_idx ON view_full_occurrence_individual USING btree (matched_taxonomic_status);
CREATE INDEX vfoi_scrubbed_taxonomic_status_idx ON view_full_occurrence_individual USING btree (scrubbed_taxonomic_status);
CREATE INDEX vfoi_usda_federal_idx ON view_full_occurrence_individual USING btree (usda_federal);
CREATE INDEX vfoi_usda_state_idx ON view_full_occurrence_individual USING btree (usda_state);
CREATE INDEX vfoi_validated_nw_species_idx ON view_full_occurrence_individual USING btree (scrubbed_species_binomial) 
WHERE (((((is_cultivated = 0) OR (is_cultivated IS NULL)) AND (is_new_world = 1)) 
AND (higher_plant_group IS NOT NULL)) AND (((is_geovalid = 1) OR (is_geovalid = 1)) OR (is_geovalid IS NULL)));
CREATE INDEX vfoi_is_geovalid_latlong_notnull_idx ON view_full_occurrence_individual(is_geovalid)
WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
