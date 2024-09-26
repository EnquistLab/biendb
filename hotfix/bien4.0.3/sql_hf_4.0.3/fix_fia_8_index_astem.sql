--
-- Restores all indexes on astem_dev
--

SET search_path TO :sch;

-- 
-- Drop all indexes and constraints, just in case
-- 

-- Drop PK
-- Must drop constraints first, if any
ALTER TABLE astem_dev DROP CONSTRAINT IF EXISTS astem_pkey;
ALTER TABLE astem_dev DROP CONSTRAINT IF EXISTS astem_dev_pkey;
ALTER TABLE astem_dev DROP CONSTRAINT IF EXISTS astem_dev_dev_pkey;
DROP INDEX IF EXISTS astem_pkey;
DROP INDEX IF EXISTS astem_dev_dev_pkey;
DROP INDEX IF EXISTS astem_dev_pkey;

-- Drop remaining indexes
DROP INDEX IF EXISTS astem_dev_pkey;
DROP INDEX IF EXISTS astem_dev_taxonobservation_id_idx;
DROP INDEX IF EXISTS astem_dev_plot_metadata_id_idx;
DROP INDEX IF EXISTS astem_dev_datasource_id_idx;
DROP INDEX IF EXISTS astem_dev_datasource_idx;
DROP INDEX IF EXISTS astem_dev_dataset_idx;
DROP INDEX IF EXISTS astem_dev_fk_gnrs_id_idx;
DROP INDEX IF EXISTS astem_dev_country_idx;
DROP INDEX IF EXISTS astem_dev_country_state_province_idx;
DROP INDEX IF EXISTS astem_dev_country_state_province_county_idx;
DROP INDEX IF EXISTS astem_dev_lat_long_not_null_idx;
DROP INDEX IF EXISTS astem_dev_fk_centroid_id_idx;
DROP INDEX IF EXISTS astem_dev_is_in_country_idx;
DROP INDEX IF EXISTS astem_dev_is_in_state_province_idx;
DROP INDEX IF EXISTS astem_dev_is_in_county_idx;
DROP INDEX IF EXISTS astem_dev_is_geovalid_idx;
DROP INDEX IF EXISTS astem_dev_is_new_world_idx;
DROP INDEX IF EXISTS astem_dev_plot_name_idx;
DROP INDEX IF EXISTS astem_dev_plot_name_subplot_idx;
DROP INDEX IF EXISTS astem_dev_is_location_cultivated_idx;
DROP INDEX IF EXISTS astem_dev_event_date_idx;
DROP INDEX IF EXISTS astem_dev_event_date_accuracy_idx;
DROP INDEX IF EXISTS astem_dev_elevation_m_idx;
DROP INDEX IF EXISTS astem_dev_plot_area_ha_idx;
DROP INDEX IF EXISTS astem_dev_sampling_protocol_idx;
DROP INDEX IF EXISTS astem_dev_vegetation_verbatim_idx;
DROP INDEX IF EXISTS astem_dev_community_concept_name_idx;
DROP INDEX IF EXISTS astem_dev_catalog_number_idx;
DROP INDEX IF EXISTS astem_dev_recorded_by_idx;
DROP INDEX IF EXISTS astem_dev_record_number_idx;
DROP INDEX IF EXISTS astem_dev_date_collected_idx;
DROP INDEX IF EXISTS astem_dev_date_collected_accuracy_idx;
DROP INDEX IF EXISTS astem_dev_identified_by_idx;
DROP INDEX IF EXISTS astem_dev_bien_taxonomy_id_idx;
DROP INDEX IF EXISTS astem_dev_taxon_id_idx;
DROP INDEX IF EXISTS astem_dev_family_taxon_id_idx;
DROP INDEX IF EXISTS astem_dev_genus_taxon_id_idx;
DROP INDEX IF EXISTS astem_dev_species_taxon_id_idx;
DROP INDEX IF EXISTS astem_dev_verbatim_scientific_name_idx;
DROP INDEX IF EXISTS astem_dev_fk_tnrs_id_idx;
DROP INDEX IF EXISTS astem_dev_family_matched_idx;
DROP INDEX IF EXISTS astem_dev_name_matched_idx;
DROP INDEX IF EXISTS astem_dev_matched_taxonomic_status_idx;
DROP INDEX IF EXISTS astem_dev_match_summary_idx;
DROP INDEX IF EXISTS astem_dev_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS astem_dev_higher_plant_group_idx;
DROP INDEX IF EXISTS astem_dev_scrubbed_family_idx;
DROP INDEX IF EXISTS astem_dev_scrubbed_genus_idx;
DROP INDEX IF EXISTS astem_dev_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS astem_dev_scrubbed_taxon_name_no_author_idx;
DROP INDEX IF EXISTS astem_dev_scrubbed_species_binomial_with_morphospecies_idx;
DROP INDEX IF EXISTS astem_dev_growth_form_idx;
DROP INDEX IF EXISTS astem_dev_reproductive_condition_idx;
DROP INDEX IF EXISTS astem_dev_individual_id_idx;
DROP INDEX IF EXISTS astem_dev_cites_idx;
DROP INDEX IF EXISTS astem_dev_iucn_idx;
DROP INDEX IF EXISTS astem_dev_usda_federal_idx;
DROP INDEX IF EXISTS astem_dev_usda_state_idx;
DROP INDEX IF EXISTS astem_dev_is_embargoed_observation_idx;
DROP INDEX IF EXISTS astem_dev_nsr_id_idx;
DROP INDEX IF EXISTS astem_dev_native_status_idx;
DROP INDEX IF EXISTS astem_dev_is_introduced_idx;
DROP INDEX IF EXISTS astem_dev_is_cultivated_in_region_idx;
DROP INDEX IF EXISTS astem_dev_is_cultivated_taxon_idx;
DROP INDEX IF EXISTS astem_dev_is_cultivated_observation_idx;
DROP INDEX IF EXISTS astem_dev_validated_species_idx;

-- 
-- Create indexes and constraints
-- 

-- Create primary key
ALTER TABLE  astem_dev ADD PRIMARY KEY (analytical_stem_id);

-- Simple indexes
CREATE INDEX astem_dev_taxonobservation_id_idx ON astem_dev (taxonobservation_id);
CREATE INDEX astem_dev_plot_metadata_id_idx ON astem_dev (plot_metadata_id);
CREATE INDEX astem_dev_datasource_id_idx ON astem_dev (datasource_id);
CREATE INDEX astem_dev_datasource_idx ON astem_dev (datasource);
CREATE INDEX astem_dev_dataset_idx ON astem_dev (dataset);
CREATE INDEX astem_dev_fk_gnrs_id_idx ON astem_dev (fk_gnrs_id);
CREATE INDEX astem_dev_country_idx ON astem_dev (country);
CREATE INDEX astem_dev_country_state_province_idx ON astem_dev (country,state_province) WHERE state_province IS NOT NULL;
CREATE INDEX astem_dev_country_state_province_county_idx ON astem_dev (country,state_province,county) WHERE county IS NOT NULL;
CREATE INDEX astem_dev_lat_long_not_null_idx ON astem_dev (is_geovalid) WHERE latitude IS NOT NULL AND longitude IS NOT NULL;  -- indexed column not important
CREATE INDEX astem_dev_is_in_country_idx ON astem_dev (is_in_country);
CREATE INDEX astem_dev_is_in_state_province_idx ON astem_dev (is_in_state_province);
CREATE INDEX astem_dev_is_in_county_idx ON astem_dev (is_in_county);
CREATE INDEX astem_dev_is_geovalid_idx ON astem_dev (is_geovalid);
CREATE INDEX astem_dev_is_new_world_idx ON astem_dev (is_new_world);
CREATE INDEX astem_dev_plot_name_idx ON astem_dev (plot_name);
CREATE INDEX astem_dev_plot_name_subplot_idx ON astem_dev (plot_name,subplot);
CREATE INDEX astem_dev_event_date_idx ON astem_dev (event_date);
CREATE INDEX astem_dev_event_date_accuracy_idx ON astem_dev (event_date_accuracy);
CREATE INDEX astem_dev_elevation_m_idx ON astem_dev (elevation_m);
CREATE INDEX astem_dev_plot_area_ha_idx ON astem_dev (plot_area_ha);
CREATE INDEX astem_dev_sampling_protocol_idx ON astem_dev (sampling_protocol);
CREATE INDEX astem_dev_vegetation_verbatim_idx ON astem_dev (vegetation_verbatim);
CREATE INDEX astem_dev_community_concept_name_idx ON astem_dev (community_concept_name);
CREATE INDEX astem_dev_date_collected_idx ON astem_dev (date_collected);
CREATE INDEX astem_dev_date_collected_accuracy_idx ON astem_dev (date_collected_accuracy);
CREATE INDEX astem_dev_bien_taxonomy_id_idx ON astem_dev (bien_taxonomy_id);
CREATE INDEX astem_dev_taxon_id_idx ON astem_dev (taxon_id);
CREATE INDEX astem_dev_family_taxon_id_idx ON astem_dev (family_taxon_id);
CREATE INDEX astem_dev_genus_taxon_id_idx ON astem_dev (genus_taxon_id);
CREATE INDEX astem_dev_species_taxon_id_idx ON astem_dev (species_taxon_id);
CREATE INDEX astem_dev_fk_tnrs_id_idx ON astem_dev (fk_tnrs_id);
CREATE INDEX astem_dev_family_matched_idx ON astem_dev (family_matched);
CREATE INDEX astem_dev_name_matched_idx ON astem_dev (name_matched);
CREATE INDEX astem_dev_matched_taxonomic_status_idx ON astem_dev (matched_taxonomic_status);
CREATE INDEX astem_dev_match_summary_idx ON astem_dev (match_summary);
CREATE INDEX astem_dev_scrubbed_taxonomic_status_idx ON astem_dev (scrubbed_taxonomic_status);
CREATE INDEX astem_dev_higher_plant_group_idx ON astem_dev (higher_plant_group);
CREATE INDEX astem_dev_scrubbed_family_idx ON astem_dev (scrubbed_family);
CREATE INDEX astem_dev_scrubbed_genus_idx ON astem_dev (scrubbed_genus);
CREATE INDEX astem_dev_scrubbed_species_binomial_idx ON astem_dev (scrubbed_species_binomial);
CREATE INDEX astem_dev_scrubbed_taxon_name_no_author_idx ON astem_dev (scrubbed_taxon_name_no_author);
CREATE INDEX astem_dev_scrubbed_species_binomial_with_morphospecies_idx ON astem_dev (scrubbed_species_binomial_with_morphospecies);
CREATE INDEX astem_dev_growth_form_idx ON astem_dev (growth_form);
CREATE INDEX astem_dev_individual_id_idx ON astem_dev (individual_id);
CREATE INDEX astem_dev_is_embargoed_observation_idx ON astem_dev (is_embargoed_observation);
CREATE INDEX astem_dev_nsr_id_idx ON astem_dev (nsr_id);
CREATE INDEX astem_dev_native_status_idx ON astem_dev (native_status);
CREATE INDEX astem_dev_is_introduced_idx ON astem_dev (is_introduced);
CREATE INDEX astem_dev_is_cultivated_in_region_idx ON astem_dev (is_cultivated_in_region);
CREATE INDEX astem_dev_is_cultivated_taxon_idx ON astem_dev (is_cultivated_taxon);
CREATE INDEX astem_dev_is_cultivated_observation_idx ON astem_dev (is_cultivated_observation);

-- Compound indexes for frequent queries
-- REVISE THIS INDEX AFTER SCHEMA UPDATE! Last line should read:
-- AND (is_introduced=0 OR is_introduced IS NULL)
CREATE INDEX astem_dev_validated_species_idx ON astem_dev USING btree (scrubbed_species_binomial) 
WHERE (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) 
AND higher_plant_group IS NOT NULL
AND (is_geovalid = 1 OR is_geovalid IS NULL)
AND (latitude IS NOT NULL AND longitude IS NOT NULL)
AND (is_introduced=0 OR is_introduced IS NULL)
;

