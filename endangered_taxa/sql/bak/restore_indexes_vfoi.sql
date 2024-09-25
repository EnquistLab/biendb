-- -------------------------------------------------------------
-- Generate indexes present in original table vfoi
--
-- Note 1: does not include dependent table FKs. These are generated
--   later in production schema, after replacement of original table
--   by developement table
-- Note 2: must include schema for postgis functions st_ndims()
--   and geometrytype()
-- -------------------------------------------------------------

SET search_path TO public_vegbien_dev;

-- make taxonobservation_id the primary key
ALTER TABLE ONLY view_full_occurrence_individual_dev
ADD CONSTRAINT vfoi_pkey PRIMARY KEY (taxonobservation_id);
        
-- Add internal geometric constraints
ALTER TABLE view_full_occurrence_individual_dev
ADD CONSTRAINT vfoi_enforce_dims_geom CHECK ((public.st_ndims(geom) = 2)),
ADD CONSTRAINT vfoi_enforce_geotype_geom CHECK (((public.geometrytype(geom) = 'POINT'::text) OR (geom IS NULL)));

CREATE INDEX vfoi_gist_idx ON view_full_occurrence_individual_dev USING gist (geom);

-- Restore remaining indexes
    
CREATE INDEX vfoi_validated_species_idx ON view_full_occurrence_individual_dev USING btree (scrubbed_species_binomial) WHERE (((((is_cultivated = 0) OR (is_cultivated IS NULL)) AND (is_new_world = 1)) AND (higher_plant_group IS NOT NULL)) AND (((is_geovalid = 1) OR (is_geovalid = 1)) OR (is_geovalid IS NULL)));

CREATE INDEX vfoi_country_idx ON view_full_occurrence_individual_dev USING btree (country);

CREATE INDEX vfoi_state_province_idx ON view_full_occurrence_individual_dev USING btree (country, state_province)
WHERE state_province IS NOT NULL;

CREATE INDEX vfoi_county_idx ON view_full_occurrence_individual_dev USING btree (country, state_province, county)
WHERE county IS NOT NULL;

CREATE INDEX vfoi_country_species_idx ON view_full_occurrence_individual_dev USING btree (country, scrubbed_species_binomial);

CREATE INDEX vfoi_higher_plant_group_idx ON view_full_occurrence_individual_dev USING btree (higher_plant_group);

CREATE INDEX vfoi_is_cultivated_idx ON view_full_occurrence_individual_dev USING btree (is_cultivated);

CREATE INDEX vfoi_is_geovalid_idx ON view_full_occurrence_individual_dev USING btree (is_geovalid);

CREATE INDEX vfoi_is_new_world_idx ON view_full_occurrence_individual_dev USING btree (is_new_world);

CREATE INDEX vfoi_iscultivated_nsr_idx ON view_full_occurrence_individual_dev USING btree (is_cultivated_in_region);

CREATE INDEX vfoi_isintroduced ON view_full_occurrence_individual_dev USING btree (isintroduced);

CREATE INDEX vfoi_native_status_idx ON view_full_occurrence_individual_dev USING btree (native_status);

CREATE INDEX vfoi_taxonomic_status_idx ON view_full_occurrence_individual_dev USING btree (taxonomic_status);

CREATE INDEX vfoi_scrubbed_family_idx ON view_full_occurrence_individual_dev USING btree (scrubbed_family);

CREATE INDEX vfoi_scrubbed_genus_idx ON view_full_occurrence_individual_dev USING btree (scrubbed_genus);

CREATE INDEX vfoi_scrubbed_species_binomial_idx ON view_full_occurrence_individual_dev 
USING btree (scrubbed_species_binomial);

CREATE INDEX vfoi_plot_name_idx ON view_full_occurrence_individual_dev 
USING btree (plot_name);

CREATE INDEX vfoi_plot_area_idx ON view_full_occurrence_individual_dev 
USING btree (plot_area_ha);

CREATE INDEX vfoi_subplot_idx ON view_full_occurrence_individual_dev 
USING btree (subplot);

CREATE INDEX vfoi_observation_type_idx ON view_full_occurrence_individual_dev USING btree (observation_type);

CREATE INDEX vfoi_datasource_idx ON view_full_occurrence_individual_dev 
USING btree (datasource);

CREATE INDEX vfoi_dataset_idx ON view_full_occurrence_individual_dev 
USING btree (dataset);

CREATE INDEX vfoi_dataowner_idx ON view_full_occurrence_individual_dev 
USING btree (dataowner);

CREATE INDEX vfoi_cites_idx ON view_full_occurrence_individual_dev 
USING btree (cites);

-- FK indexes
CREATE INDEX vfoi_datasource_id_idx ON view_full_occurrence_individual_dev 
USING btree (datasource_id);

CREATE INDEX vfoi_plot_metadata_id_idx ON view_full_occurrence_individual_dev 
USING btree (plot_metadata_id);

CREATE INDEX vfoi_bien_taxonomy_id_idx ON view_full_occurrence_individual_dev 
USING btree (bien_taxonomy_id);

-- New indexes
CREATE INDEX vfoi_iucn_idx ON view_full_occurrence_individual_dev 
USING btree (iucn);

CREATE INDEX vfoi_usda_federal_idx ON view_full_occurrence_individual_dev 
USING btree (usda_federal);

CREATE INDEX vfoi_usda_state_idx ON view_full_occurrence_individual_dev 
USING btree (usda_state);

CREATE INDEX vfoi_is_embargoed_observation_idx ON view_full_occurrence_individual_dev 
USING btree (is_embargoed_observation);





