SET search_path TO :sch, postgis;

--
-- Drop all indexes first, just in case
-- 

-- PK
ALTER TABLE vfoi_dev DROP CONSTRAINT IF EXISTS vfoi_dev_pkey;
DROP INDEX IF EXISTS vfoi_dev_pkey;

-- Geometric constraints and indexes
ALTER TABLE vfoi_dev DROP CONSTRAINT IF EXISTS enforce_dimensions_geom;
ALTER TABLE vfoi_dev DROP CONSTRAINT IF EXISTS enforce_geometrytype_geom;
ALTER TABLE vfoi_dev DROP CONSTRAINT IF EXISTS enforce_srid_geom;
DROP INDEX IF EXISTS vfoi_dev_georeferenced_species_idx;
DROP INDEX IF EXISTS vfoi_dev_gist_idx;

-- The remaining indexes
DROP INDEX IF EXISTS vfoi_dev_observation_type_idx;
DROP INDEX IF EXISTS vfoi_dev_plot_metadata_id_idx;
DROP INDEX IF EXISTS vfoi_dev_datasource_id_idx;
DROP INDEX IF EXISTS vfoi_dev_datasource_idx;
DROP INDEX IF EXISTS vfoi_dev_dataset_idx;
DROP INDEX IF EXISTS vfoi_dev_fk_gnrs_id_idx;
DROP INDEX IF EXISTS vfoi_dev_country_idx;
DROP INDEX IF EXISTS vfoi_dev_country_state_province_idx;
DROP INDEX IF EXISTS vfoi_dev_country_state_province_county_idx;
DROP INDEX IF EXISTS vfoi_dev_lat_long_not_null_idx;
DROP INDEX IF EXISTS vfoi_dev_fk_centroid_id_idx;
DROP INDEX IF EXISTS vfoi_dev_is_in_country_idx;
DROP INDEX IF EXISTS vfoi_dev_is_in_state_province_idx;
DROP INDEX IF EXISTS vfoi_dev_is_in_county_idx;
DROP INDEX IF EXISTS vfoi_dev_is_geovalid_idx;
DROP INDEX IF EXISTS vfoi_dev_is_new_world_idx;
DROP INDEX IF EXISTS vfoi_dev_plot_name_idx;
DROP INDEX IF EXISTS vfoi_dev_plot_name_subplot_idx;
DROP INDEX IF EXISTS vfoi_dev_is_location_cultivated_idx;
DROP INDEX IF EXISTS vfoi_dev_event_date_idx;
DROP INDEX IF EXISTS vfoi_dev_event_date_accuracy_idx;
DROP INDEX IF EXISTS vfoi_dev_elevation_m_idx;
DROP INDEX IF EXISTS vfoi_dev_plot_area_ha_idx;
DROP INDEX IF EXISTS vfoi_dev_sampling_protocol_idx;
DROP INDEX IF EXISTS vfoi_dev_vegetation_verbatim_idx;
DROP INDEX IF EXISTS vfoi_dev_community_concept_name_idx;
DROP INDEX IF EXISTS vfoi_dev_catalog_number_idx;
DROP INDEX IF EXISTS vfoi_dev_recorded_by_idx;
DROP INDEX IF EXISTS vfoi_dev_record_number_idx;
DROP INDEX IF EXISTS vfoi_dev_date_collected_idx;
DROP INDEX IF EXISTS vfoi_dev_date_collected_accuracy_idx;
DROP INDEX IF EXISTS vfoi_dev_identified_by_idx;
DROP INDEX IF EXISTS vfoi_dev_bien_taxonomy_id_idx;
DROP INDEX IF EXISTS vfoi_dev_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_dev_family_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_dev_genus_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_dev_species_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_dev_verbatim_scientific_name_idx;
DROP INDEX IF EXISTS vfoi_dev_fk_tnrs_id_idx;
DROP INDEX IF EXISTS vfoi_dev_family_matched_idx;
DROP INDEX IF EXISTS vfoi_dev_name_matched_idx;
DROP INDEX IF EXISTS vfoi_dev_matched_taxonomic_status_idx;
DROP INDEX IF EXISTS vfoi_dev_match_summary_idx;
DROP INDEX IF EXISTS vfoi_dev_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS vfoi_dev_higher_plant_group_idx;
DROP INDEX IF EXISTS vfoi_dev_scrubbed_family_idx;
DROP INDEX IF EXISTS vfoi_dev_scrubbed_genus_idx;
DROP INDEX IF EXISTS vfoi_dev_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS vfoi_dev_scrubbed_taxon_name_no_author_idx;
DROP INDEX IF EXISTS vfoi_dev_scrubbed_species_binomial_with_morphospecies_idx;
DROP INDEX IF EXISTS vfoi_dev_growth_form_idx;
DROP INDEX IF EXISTS vfoi_dev_reproductive_condition_idx;
DROP INDEX IF EXISTS vfoi_dev_individual_id_idx;
DROP INDEX IF EXISTS vfoi_dev_cites_idx;
DROP INDEX IF EXISTS vfoi_dev_iucn_idx;
DROP INDEX IF EXISTS vfoi_dev_usda_federal_idx;
DROP INDEX IF EXISTS vfoi_dev_usda_state_idx;
DROP INDEX IF EXISTS vfoi_dev_is_embargoed_observation_idx;
DROP INDEX IF EXISTS vfoi_dev_nsr_id_idx;
DROP INDEX IF EXISTS vfoi_dev_native_status_idx;
DROP INDEX IF EXISTS vfoi_dev_is_introduced_idx;
DROP INDEX IF EXISTS vfoi_dev_is_cultivated_in_region_idx;
DROP INDEX IF EXISTS vfoi_dev_is_cultivated_taxon_idx;
DROP INDEX IF EXISTS vfoi_dev_is_cultivated_observation_idx;
DROP INDEX IF EXISTS vfoi_dev_geom_not_null_idx;
DROP INDEX IF EXISTS vfoi_dev_validated_species_idx;
DROP INDEX IF EXISTS vfoi_dev_georef_protocol_idx;
DROP INDEX IF EXISTS vfoi_dev_is_location_cultivated_idx;

--
-- Create the indexes
-- 

-- PK
ALTER TABLE vfoi_dev ADD PRIMARY KEY (taxonobservation_id);

-- Simple indexes
CREATE INDEX vfoi_dev_observation_type_idx ON vfoi_dev (observation_type);
CREATE INDEX vfoi_dev_plot_metadata_id_idx ON vfoi_dev (plot_metadata_id);
CREATE INDEX vfoi_dev_datasource_id_idx ON vfoi_dev (datasource_id);
CREATE INDEX vfoi_dev_datasource_idx ON vfoi_dev (datasource);
CREATE INDEX vfoi_dev_dataset_idx ON vfoi_dev (dataset);
CREATE INDEX vfoi_dev_fk_gnrs_id_idx ON vfoi_dev (fk_gnrs_id);
CREATE INDEX vfoi_dev_country_idx ON vfoi_dev (country);
CREATE INDEX vfoi_dev_country_state_province_idx ON vfoi_dev (country,state_province) WHERE state_province IS NOT NULL;
CREATE INDEX vfoi_dev_country_state_province_county_idx ON vfoi_dev (country,state_province,county) WHERE county IS NOT NULL;
CREATE INDEX vfoi_dev_lat_long_not_null_idx ON vfoi_dev (is_geovalid) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;  -- indexed column not important
CREATE INDEX vfoi_dev_fk_centroid_id_idx ON vfoi_dev (fk_centroid_id);
CREATE INDEX vfoi_dev_is_in_country_idx ON vfoi_dev (is_in_country);
CREATE INDEX vfoi_dev_is_in_state_province_idx ON vfoi_dev (is_in_state_province);
CREATE INDEX vfoi_dev_is_in_county_idx ON vfoi_dev (is_in_county);
CREATE INDEX vfoi_dev_is_geovalid_idx ON vfoi_dev (is_geovalid);
CREATE INDEX vfoi_dev_is_new_world_idx ON vfoi_dev (is_new_world);
CREATE INDEX vfoi_dev_plot_name_idx ON vfoi_dev (plot_name);
CREATE INDEX vfoi_dev_plot_name_subplot_idx ON vfoi_dev (plot_name,subplot);
CREATE INDEX vfoi_dev_event_date_idx ON vfoi_dev (event_date);
CREATE INDEX vfoi_dev_event_date_accuracy_idx ON vfoi_dev (event_date_accuracy);
CREATE INDEX vfoi_dev_elevation_m_idx ON vfoi_dev (elevation_m);
CREATE INDEX vfoi_dev_plot_area_ha_idx ON vfoi_dev (plot_area_ha);
CREATE INDEX vfoi_dev_sampling_protocol_idx ON vfoi_dev (sampling_protocol);
CREATE INDEX vfoi_dev_catalog_number_idx ON vfoi_dev (catalog_number);
CREATE INDEX vfoi_dev_date_collected_idx ON vfoi_dev (date_collected);
CREATE INDEX vfoi_dev_date_collected_accuracy_idx ON vfoi_dev (date_collected_accuracy);
CREATE INDEX vfoi_dev_bien_taxonomy_id_idx ON vfoi_dev (bien_taxonomy_id);
CREATE INDEX vfoi_dev_taxon_id_idx ON vfoi_dev (taxon_id);
CREATE INDEX vfoi_dev_family_taxon_id_idx ON vfoi_dev (family_taxon_id);
CREATE INDEX vfoi_dev_genus_taxon_id_idx ON vfoi_dev (genus_taxon_id);
CREATE INDEX vfoi_dev_species_taxon_id_idx ON vfoi_dev (species_taxon_id);
CREATE INDEX vfoi_dev_verbatim_scientific_name_idx ON vfoi_dev (verbatim_scientific_name);
CREATE INDEX vfoi_dev_fk_tnrs_id_idx ON vfoi_dev (fk_tnrs_id);
CREATE INDEX vfoi_dev_family_matched_idx ON vfoi_dev (family_matched);
CREATE INDEX vfoi_dev_name_matched_idx ON vfoi_dev (name_matched);
CREATE INDEX vfoi_dev_matched_taxonomic_status_idx ON vfoi_dev (matched_taxonomic_status);
CREATE INDEX vfoi_dev_match_summary_idx ON vfoi_dev (match_summary);
CREATE INDEX vfoi_dev_scrubbed_taxonomic_status_idx ON vfoi_dev (scrubbed_taxonomic_status);
CREATE INDEX vfoi_dev_higher_plant_group_idx ON vfoi_dev (higher_plant_group);
CREATE INDEX vfoi_dev_scrubbed_family_idx ON vfoi_dev (scrubbed_family);
CREATE INDEX vfoi_dev_scrubbed_genus_idx ON vfoi_dev (scrubbed_genus);
CREATE INDEX vfoi_dev_scrubbed_species_binomial_idx ON vfoi_dev (scrubbed_species_binomial);
CREATE INDEX vfoi_dev_scrubbed_taxon_name_no_author_idx ON vfoi_dev (scrubbed_taxon_name_no_author);
CREATE INDEX vfoi_dev_scrubbed_species_binomial_with_morphospecies_idx ON vfoi_dev (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX vfoi_dev_growth_form_idx ON vfoi_dev (growth_form);
CREATE INDEX vfoi_dev_cites_idx ON vfoi_dev (cites);
CREATE INDEX vfoi_dev_iucn_idx ON vfoi_dev (iucn);
CREATE INDEX vfoi_dev_usda_federal_idx ON vfoi_dev (usda_federal);
CREATE INDEX vfoi_dev_usda_state_idx ON vfoi_dev (usda_state);
CREATE INDEX vfoi_dev_is_embargoed_observation_idx ON vfoi_dev (is_embargoed_observation);
CREATE INDEX vfoi_dev_nsr_id_idx ON vfoi_dev (nsr_id);
CREATE INDEX vfoi_dev_native_status_idx ON vfoi_dev (native_status);
CREATE INDEX vfoi_dev_is_introduced_idx ON vfoi_dev (is_introduced);
CREATE INDEX vfoi_dev_is_cultivated_in_region_idx ON vfoi_dev (is_cultivated_in_region);
CREATE INDEX vfoi_dev_is_cultivated_taxon_idx ON vfoi_dev (is_cultivated_taxon);
CREATE INDEX vfoi_dev_is_cultivated_observation_idx ON vfoi_dev (is_cultivated_observation);
CREATE INDEX vfoi_dev_geom_not_null_idx ON
vfoi_dev(is_geovalid)
WHERE geom IS NOT NULL; -- indexed column not important
CREATE INDEX vfoi_dev_georef_protocol_idx ON vfoi_dev (georef_protocol);
CREATE INDEX vfoi_dev_is_location_cultivated_idx ON vfoi_dev (is_location_cultivated);


-- Compound indexes for frequent queries
CREATE INDEX vfoi_dev_validated_species_idx ON vfoi_dev USING btree (scrubbed_species_binomial) 
WHERE (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) 
AND higher_plant_group IS NOT NULL
AND (is_geovalid = 1 OR is_geovalid IS NULL)
AND (latitude IS NOT NULL AND longitude IS NOT NULL)
AND (is_introduced=0 OR is_introduced IS NULL)
;

-- Restore geometric constraints
-- Geometry dimensions must be 2 (point)
ALTER TABLE vfoi_dev DROP CONSTRAINT IF EXISTS enforce_dimensions_geom;
ALTER TABLE vfoi_dev
   ADD CONSTRAINT enforce_dimensions_geom
   CHECK (ST_NDims(geom) = 2);
   
-- Geometry type is only point      
ALTER TABLE vfoi_dev DROP CONSTRAINT IF EXISTS enforce_geometrytype_geom;
ALTER TABLE vfoi_dev
   ADD CONSTRAINT enforce_geometrytype_geom
   CHECK (geometrytype(geom) = 'POINT'::text
     OR geom IS NULL);
     
-- Projection (SRID) is 4326 (WGS84)
ALTER TABLE vfoi_dev DROP CONSTRAINT IF EXISTS enforce_srid_geom;
ALTER TABLE vfoi_dev
   ADD CONSTRAINT enforce_srid_geom
   CHECK (ST_SRID(geom) = 4326);
   
-- Restore geometry indices
CREATE INDEX vfoi_dev_georeferenced_species_idx ON vfoi_dev USING btree (scrubbed_species_binomial)
WHERE scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL;

DROP INDEX IF EXISTS vfoi_dev_gist_idx;
CREATE INDEX vfoi_dev_gist_idx ON vfoi_dev USING gist (geom);


   

