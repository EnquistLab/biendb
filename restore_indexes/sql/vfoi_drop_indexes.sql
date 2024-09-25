--
-- Drop all indexes on vfoi_
-- 

SET search_path TO :sch, postgis;

-- Various ways PK might be referenced
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS vfoi_pkey;
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS view_full_occurrence_individual_pkey;
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS view_full_occurrence_individual_dev_pkey;
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS view_full_occurrence_individual_pkey;
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS view_full_occurrence_individual_dev_pkey;

DROP INDEX IF EXISTS vfoi_pkey;
DROP INDEX IF EXISTS view_full_occurrence_individual_pkey;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_pkey;
DROP INDEX IF EXISTS view_full_occurrence_individual_pkey;

-- Geometric constraints and indexes
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS enforce_dimensions_geom;
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS enforce_geometrytype_geom;
ALTER TABLE view_full_occurrence_individual DROP CONSTRAINT IF EXISTS enforce_srid_geom;
DROP INDEX IF EXISTS vfoi_georeferenced_species_idx;
DROP INDEX IF EXISTS vfoi_gist_idx;

-- The remaining indexes
DROP INDEX IF EXISTS vfoi_observation_type_idx;
DROP INDEX IF EXISTS vfoi_plot_metadata_id_idx;
DROP INDEX IF EXISTS vfoi_datasource_id_idx;
DROP INDEX IF EXISTS vfoi_datasource_idx;
DROP INDEX IF EXISTS vfoi_dataset_idx;
DROP INDEX IF EXISTS vfoi_fk_gnrs_id_idx;
DROP INDEX IF EXISTS vfoi_country_idx;
DROP INDEX IF EXISTS vfoi_country_state_province_idx;
DROP INDEX IF EXISTS vfoi_country_state_province_county_idx;
DROP INDEX IF EXISTS vfoi_lat_long_not_null_idx;
DROP INDEX IF EXISTS vfoi_fk_centroid_id_idx;
DROP INDEX IF EXISTS vfoi_is_in_country_idx;
DROP INDEX IF EXISTS vfoi_is_in_state_province_idx;
DROP INDEX IF EXISTS vfoi_is_in_county_idx;
DROP INDEX IF EXISTS vfoi_is_geovalid_idx;
DROP INDEX IF EXISTS vfoi_is_new_world_idx;
DROP INDEX IF EXISTS vfoi_plot_name_idx;
DROP INDEX IF EXISTS vfoi_plot_name_subplot_idx;
DROP INDEX IF EXISTS vfoi_is_location_cultivated_idx;
DROP INDEX IF EXISTS vfoi_event_date_idx;
DROP INDEX IF EXISTS vfoi_event_date_accuracy_idx;
DROP INDEX IF EXISTS vfoi_elevation_m_idx;
DROP INDEX IF EXISTS vfoi_plot_area_ha_idx;
DROP INDEX IF EXISTS vfoi_sampling_protocol_idx;
DROP INDEX IF EXISTS vfoi_vegetation_verbatim_idx;
DROP INDEX IF EXISTS vfoi_community_concept_name_idx;
DROP INDEX IF EXISTS vfoi_catalog_number_idx;
DROP INDEX IF EXISTS vfoi_recorded_by_idx;
DROP INDEX IF EXISTS vfoi_record_number_idx;
DROP INDEX IF EXISTS vfoi_date_collected_idx;
DROP INDEX IF EXISTS vfoi_date_collected_accuracy_idx;
DROP INDEX IF EXISTS vfoi_identified_by_idx;
DROP INDEX IF EXISTS vfoi_bien_taxonomy_id_idx;
DROP INDEX IF EXISTS vfoi_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_family_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_genus_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_species_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_verbatim_scientific_name_idx;
DROP INDEX IF EXISTS vfoi_fk_tnrs_id_idx;
DROP INDEX IF EXISTS vfoi_family_matched_idx;
DROP INDEX IF EXISTS vfoi_name_matched_idx;
DROP INDEX IF EXISTS vfoi_matched_taxonomic_status_idx;
DROP INDEX IF EXISTS vfoi_match_summary_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS vfoi_higher_plant_group_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_family_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_genus_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_taxon_name_no_author_idx;
DROP INDEX IF EXISTS vfoi_scrubbed_species_binomial_with_morphospecies_idx;
DROP INDEX IF EXISTS vfoi_growth_form_idx;
DROP INDEX IF EXISTS vfoi_reproductive_condition_idx;
DROP INDEX IF EXISTS vfoi_individual_id_idx;
DROP INDEX IF EXISTS vfoi_cites_idx;
DROP INDEX IF EXISTS vfoi_iucn_idx;
DROP INDEX IF EXISTS vfoi_usda_federal_idx;
DROP INDEX IF EXISTS vfoi_usda_state_idx;
DROP INDEX IF EXISTS vfoi_is_embargoed_observation_idx;
DROP INDEX IF EXISTS vfoi_nsr_id_idx;
DROP INDEX IF EXISTS vfoi_native_status_idx;
DROP INDEX IF EXISTS vfoi_is_introduced_idx;
DROP INDEX IF EXISTS vfoi_is_cultivated_in_region_idx;
DROP INDEX IF EXISTS vfoi_is_cultivated_taxon_idx;
DROP INDEX IF EXISTS vfoi_is_cultivated_observation_idx;
DROP INDEX IF EXISTS vfoi_geom_not_null_idx;
DROP INDEX IF EXISTS vfoi_validated_species_idx;
DROP INDEX IF EXISTS vfoi_georef_protocol_idx;
DROP INDEX IF EXISTS vfoi_is_location_cultivated_idx;
DROP INDEX IF EXISTS vfoi_bien_range_model_default_idx;
DROP INDEX IF EXISTS vfoi_is_centroid_idx;
DROP INDEX IF EXISTS vfoi_latlong_verbatim_idx;

