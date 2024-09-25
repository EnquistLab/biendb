--
-- Restores all indexes on vfoi
-- 

SET search_path TO :sch;

-- Drop all the indexes, in case they already exist
-- DROP INDEX IF EXISTS vfoi_pkey;

-- Including name variants used in the past, just in case
ALTER TABLE view_full_occurrence_individual 
DROP CONSTRAINT IF EXISTS enforce_dimension_geom,
DROP CONSTRAINT IF EXISTS enforce_dimensions_geom,
DROP CONSTRAINT IF EXISTS vfoi_enforce_dimensions_geom,
DROP CONSTRAINT IF EXISTS enforce_geometrytype_geom,
DROP CONSTRAINT IF EXISTS vfoi_enforce_geometrytype_geom,
DROP CONSTRAINT IF EXISTS enforce_srid_geom,
DROP CONSTRAINT IF EXISTS vfoi_enforce_srid_geom;

DROP INDEX IF EXISTS vfoi_gist_idx;
DROP INDEX IF EXISTS vfoi_georeferenced_species_idx;
DROP INDEX IF EXISTS vfoi_bien_taxonomy_id_idx;
DROP INDEX IF EXISTS vfoi_cites_idx;
DROP INDEX IF EXISTS vfoi_country_idx;
DROP INDEX IF EXISTS vfoi_country_species_idx;
DROP INDEX IF EXISTS vfoi_county_idx;
DROP INDEX IF EXISTS vfoi_dataowner_idx;
DROP INDEX IF EXISTS vfoi_dataset_idx;
DROP INDEX IF EXISTS vfoi_datasource_id_idx;
DROP INDEX IF EXISTS vfoi_datasource_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_datasource_idx;
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

-- Create pkey
-- CREATE UNIQUE INDEX vfoi_pkey ON view_full_occurrence_individual USING btree (taxonobservation_id);

-- Enforce geometric constraints
ALTER TABLE view_full_occurrence_individual
	ADD CONSTRAINT vfoi_enforce_dimensions_geom CHECK ( public.st_ndims( geom ) = 2 );
ALTER TABLE view_full_occurrence_individual
	ADD CONSTRAINT vfoi_enforce_geometrytype_geom CHECK ( ( public.geometrytype(geom) = 'POINT'::text ) OR ( geom IS NULL ) );
ALTER TABLE view_full_occurrence_individual
   ADD CONSTRAINT vfoi_enforce_srid_geom CHECK ( public.st_srid( geom ) = 4326 );

-- Add remaining indexes
CREATE INDEX vfoi_gist_idx ON view_full_occurrence_individual USING gist (geom);
CREATE INDEX vfoi_georeferenced_species_idx ON view_full_occurrence_individual USING btree (scrubbed_species_binomial)
WHERE scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL;
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
