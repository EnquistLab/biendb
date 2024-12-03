-- -----------------------------------------------------------------
-- Restores original index names after updated table 
-- "view_full_occurrence_individual_new" has been rename to
-- "view_full_occurrence_individual" by removing string "_new"
-- from all index names.
-- This is final step in moving updated duplicate table to production.
-- -----------------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

-- Original table
ALTER INDEX IF EXISTS vfoi_observation_type_idx RENAME TO vfoi_4_2_8_observation_type_idx;
ALTER INDEX IF EXISTS vfoi_plot_metadata_id_idx RENAME TO vfoi_4_2_8_plot_metadata_id_idx;
ALTER INDEX IF EXISTS vfoi_datasource_id_idx RENAME TO vfoi_4_2_8_datasource_id_idx;
ALTER INDEX IF EXISTS vfoi_datasource_idx RENAME TO vfoi_4_2_8_datasource_idx;
ALTER INDEX IF EXISTS vfoi_dataset_idx RENAME TO vfoi_4_2_8_dataset_idx;
ALTER INDEX IF EXISTS vfoi_fk_gnrs_id_idx RENAME TO vfoi_4_2_8_fk_gnrs_id_idx;
ALTER INDEX IF EXISTS vfoi_country_idx RENAME TO vfoi_4_2_8_country_idx;
ALTER INDEX IF EXISTS vfoi_country_state_province_idx RENAME TO vfoi_4_2_8_country_state_province_idx;
ALTER INDEX IF EXISTS vfoi_country_state_province_county_idx RENAME TO vfoi_4_2_8_country_state_province_county_idx;
ALTER INDEX IF EXISTS vfoi_lat_long_not_null_idx RENAME TO vfoi_4_2_8_lat_long_not_null_idx;
ALTER INDEX IF EXISTS vfoi_is_in_country_idx RENAME TO vfoi_4_2_8_is_in_country_idx;
ALTER INDEX IF EXISTS vfoi_is_in_state_province_idx RENAME TO vfoi_4_2_8_is_in_state_province_idx;
ALTER INDEX IF EXISTS vfoi_is_in_county_idx RENAME TO vfoi_4_2_8_is_in_county_idx;
ALTER INDEX IF EXISTS vfoi_is_geovalid_idx RENAME TO vfoi_4_2_8_is_geovalid_idx;
ALTER INDEX IF EXISTS vfoi_is_new_world_idx RENAME TO vfoi_4_2_8_is_new_world_idx;
ALTER INDEX IF EXISTS vfoi_plot_name_idx RENAME TO vfoi_4_2_8_plot_name_idx;
ALTER INDEX IF EXISTS vfoi_plot_name_subplot_idx RENAME TO vfoi_4_2_8_plot_name_subplot_idx;
ALTER INDEX IF EXISTS vfoi_event_date_idx RENAME TO vfoi_4_2_8_event_date_idx;
ALTER INDEX IF EXISTS vfoi_event_date_accuracy_idx RENAME TO vfoi_4_2_8_event_date_accuracy_idx;
ALTER INDEX IF EXISTS vfoi_elevation_m_idx RENAME TO vfoi_4_2_8_elevation_m_idx;
ALTER INDEX IF EXISTS vfoi_plot_area_ha_idx RENAME TO vfoi_4_2_8_plot_area_ha_idx;
ALTER INDEX IF EXISTS vfoi_sampling_protocol_idx RENAME TO vfoi_4_2_8_sampling_protocol_idx;
ALTER INDEX IF EXISTS vfoi_catalog_number_idx RENAME TO vfoi_4_2_8_catalog_number_idx;
ALTER INDEX IF EXISTS vfoi_date_collected_idx RENAME TO vfoi_4_2_8_date_collected_idx;
ALTER INDEX IF EXISTS vfoi_date_collected_accuracy_idx RENAME TO vfoi_4_2_8_date_collected_accuracy_idx;
ALTER INDEX IF EXISTS vfoi_bien_taxonomy_id_idx RENAME TO vfoi_4_2_8_bien_taxonomy_id_idx;
ALTER INDEX IF EXISTS vfoi_taxon_id_idx RENAME TO vfoi_4_2_8_taxon_id_idx;
ALTER INDEX IF EXISTS vfoi_family_taxon_id_idx RENAME TO vfoi_4_2_8_family_taxon_id_idx;
ALTER INDEX IF EXISTS vfoi_genus_taxon_id_idx RENAME TO vfoi_4_2_8_genus_taxon_id_idx;
ALTER INDEX IF EXISTS vfoi_species_taxon_id_idx RENAME TO vfoi_4_2_8_species_taxon_id_idx;
ALTER INDEX IF EXISTS vfoi_verbatim_scientific_name_idx RENAME TO vfoi_4_2_8_verbatim_scientific_name_idx;
ALTER INDEX IF EXISTS vfoi_fk_tnrs_id_idx RENAME TO vfoi_4_2_8_fk_tnrs_id_idx;
ALTER INDEX IF EXISTS vfoi_family_matched_idx RENAME TO vfoi_4_2_8_family_matched_idx;
ALTER INDEX IF EXISTS vfoi_name_matched_idx RENAME TO vfoi_4_2_8_name_matched_idx;
ALTER INDEX IF EXISTS vfoi_matched_taxonomic_status_idx RENAME TO vfoi_4_2_8_matched_taxonomic_status_idx;
ALTER INDEX IF EXISTS vfoi_match_summary_idx RENAME TO vfoi_4_2_8_match_summary_idx;
ALTER INDEX IF EXISTS vfoi_scrubbed_taxonomic_status_idx RENAME TO vfoi_4_2_8_scrubbed_taxonomic_status_idx;
ALTER INDEX IF EXISTS vfoi_higher_plant_group_idx RENAME TO vfoi_4_2_8_higher_plant_group_idx;
ALTER INDEX IF EXISTS vfoi_scrubbed_family_idx RENAME TO vfoi_4_2_8_scrubbed_family_idx;
ALTER INDEX IF EXISTS vfoi_scrubbed_genus_idx RENAME TO vfoi_4_2_8_scrubbed_genus_idx;
ALTER INDEX IF EXISTS vfoi_scrubbed_species_binomial_idx RENAME TO vfoi_4_2_8_scrubbed_species_binomial_idx;
ALTER INDEX IF EXISTS vfoi_scrubbed_taxon_name_no_author_idx RENAME TO vfoi_4_2_8_scrubbed_taxon_name_no_author_idx;
ALTER INDEX IF EXISTS vfoi_scrubbed_species_binomial_with_morphospecies_idx RENAME TO vfoi_4_2_8_scrubbed_species_binomial_with_morphospecies_idx;
ALTER INDEX IF EXISTS vfoi_growth_form_idx RENAME TO vfoi_4_2_8_growth_form_idx;
ALTER INDEX IF EXISTS vfoi_cites_idx RENAME TO vfoi_4_2_8_cites_idx;
ALTER INDEX IF EXISTS vfoi_iucn_idx RENAME TO vfoi_4_2_8_iucn_idx;
ALTER INDEX IF EXISTS vfoi_usda_federal_idx RENAME TO vfoi_4_2_8_usda_federal_idx;
ALTER INDEX IF EXISTS vfoi_usda_state_idx RENAME TO vfoi_4_2_8_usda_state_idx;
ALTER INDEX IF EXISTS vfoi_is_embargoed_observation_idx RENAME TO vfoi_4_2_8_is_embargoed_observation_idx;
ALTER INDEX IF EXISTS vfoi_native_status_idx RENAME TO vfoi_4_2_8_native_status_idx;
ALTER INDEX IF EXISTS vfoi_is_introduced_idx RENAME TO vfoi_4_2_8_is_introduced_idx;
ALTER INDEX IF EXISTS vfoi_is_cultivated_in_region_idx RENAME TO vfoi_4_2_8_is_cultivated_in_region_idx;
ALTER INDEX IF EXISTS vfoi_is_cultivated_taxon_idx RENAME TO vfoi_4_2_8_is_cultivated_taxon_idx;
ALTER INDEX IF EXISTS vfoi_is_cultivated_observation_idx RENAME TO vfoi_4_2_8_is_cultivated_observation_idx;
ALTER INDEX IF EXISTS vfoi_geom_not_null_idx RENAME TO vfoi_4_2_8_geom_not_null_idx;
ALTER INDEX IF EXISTS vfoi_georef_protocol_idx RENAME TO vfoi_4_2_8_georef_protocol_idx;
ALTER INDEX IF EXISTS vfoi_is_location_cultivated_idx RENAME TO vfoi_4_2_8_is_location_cultivated_idx;
ALTER INDEX IF EXISTS vfoi_gid_0_idx RENAME TO vfoi_4_2_8_gid_0_idx;
ALTER INDEX IF EXISTS vfoi_gid_1_idx RENAME TO vfoi_4_2_8_gid_1_idx;
ALTER INDEX IF EXISTS vfoi_gid_2_idx RENAME TO vfoi_4_2_8_gid_2_idx;
ALTER INDEX IF EXISTS vfoi_fk_cds_id_idx RENAME TO vfoi_4_2_8_fk_cds_id_idx;
ALTER INDEX IF EXISTS vfoi_is_centroid_idx RENAME TO vfoi_4_2_8_is_centroid_idx;
ALTER INDEX IF EXISTS vfoi_centroid_type_idx RENAME TO vfoi_4_2_8_centroid_type_idx;
ALTER INDEX IF EXISTS vfoi_is_invalid_latlong_idx RENAME TO vfoi_4_2_8_is_invalid_latlong_idx;
ALTER INDEX IF EXISTS vfoi_nsr_id_idx RENAME TO vfoi_4_2_8_nsr_id_idx;
ALTER INDEX IF EXISTS vfoi_cods_proximity_id_idx RENAME TO vfoi_4_2_8_cods_proximity_id_idx;
ALTER INDEX IF EXISTS vfoi_cods_keyword_id_idx RENAME TO vfoi_4_2_8_cods_keyword_id_idx;
ALTER INDEX IF EXISTS vfoi_latlong_verbatim_idx RENAME TO vfoi_4_2_8_latlong_verbatim_idx;
ALTER INDEX IF EXISTS vfoi_datasetkey_idx RENAME TO vfoi_4_2_8_datasetkey_idx;
ALTER INDEX IF EXISTS vfoi_bien_range_model_default_idx RENAME TO vfoi_4_2_8_bien_range_model_default_idx;
ALTER INDEX IF EXISTS vfoi_georeferenced_species_idx RENAME TO vfoi_4_2_8_georeferenced_species_idx;
ALTER INDEX IF EXISTS vfoi_gist_idx RENAME TO vfoi_4_2_8_gist_idx;

-- New table
ALTER INDEX IF EXISTS vfoi_new_observation_type_idx RENAME TO vfoi_observation_type_idx;
ALTER INDEX IF EXISTS vfoi_new_plot_metadata_id_idx RENAME TO vfoi_plot_metadata_id_idx;
ALTER INDEX IF EXISTS vfoi_new_datasource_id_idx RENAME TO vfoi_datasource_id_idx;
ALTER INDEX IF EXISTS vfoi_new_datasource_idx RENAME TO vfoi_datasource_idx;
ALTER INDEX IF EXISTS vfoi_new_dataset_idx RENAME TO vfoi_dataset_idx;
ALTER INDEX IF EXISTS vfoi_new_fk_gnrs_id_idx RENAME TO vfoi_fk_gnrs_id_idx;
ALTER INDEX IF EXISTS vfoi_new_country_idx RENAME TO vfoi_country_idx;
ALTER INDEX IF EXISTS vfoi_new_country_state_province_idx RENAME TO vfoi_country_state_province_idx;
ALTER INDEX IF EXISTS vfoi_new_country_state_province_county_idx RENAME TO vfoi_country_state_province_county_idx;
ALTER INDEX IF EXISTS vfoi_new_lat_long_not_null_idx RENAME TO vfoi_lat_long_not_null_idx;
ALTER INDEX IF EXISTS vfoi_new_is_in_country_idx RENAME TO vfoi_is_in_country_idx;
ALTER INDEX IF EXISTS vfoi_new_is_in_state_province_idx RENAME TO vfoi_is_in_state_province_idx;
ALTER INDEX IF EXISTS vfoi_new_is_in_county_idx RENAME TO vfoi_is_in_county_idx;
ALTER INDEX IF EXISTS vfoi_new_is_geovalid_idx RENAME TO vfoi_is_geovalid_idx;
ALTER INDEX IF EXISTS vfoi_new_is_new_world_idx RENAME TO vfoi_is_new_world_idx;
ALTER INDEX IF EXISTS vfoi_new_plot_name_idx RENAME TO vfoi_plot_name_idx;
ALTER INDEX IF EXISTS vfoi_new_plot_name_subplot_idx RENAME TO vfoi_plot_name_subplot_idx;
ALTER INDEX IF EXISTS vfoi_new_event_date_idx RENAME TO vfoi_event_date_idx;
ALTER INDEX IF EXISTS vfoi_new_event_date_accuracy_idx RENAME TO vfoi_event_date_accuracy_idx;
ALTER INDEX IF EXISTS vfoi_new_elevation_m_idx RENAME TO vfoi_elevation_m_idx;
ALTER INDEX IF EXISTS vfoi_new_plot_area_ha_idx RENAME TO vfoi_plot_area_ha_idx;
ALTER INDEX IF EXISTS vfoi_new_sampling_protocol_idx RENAME TO vfoi_sampling_protocol_idx;
ALTER INDEX IF EXISTS vfoi_new_catalog_number_idx RENAME TO vfoi_catalog_number_idx;
ALTER INDEX IF EXISTS vfoi_new_date_collected_idx RENAME TO vfoi_date_collected_idx;
ALTER INDEX IF EXISTS vfoi_new_date_collected_accuracy_idx RENAME TO vfoi_date_collected_accuracy_idx;
ALTER INDEX IF EXISTS vfoi_new_bien_taxonomy_id_idx RENAME TO vfoi_bien_taxonomy_id_idx;
ALTER INDEX IF EXISTS vfoi_new_taxon_id_idx RENAME TO vfoi_taxon_id_idx;
ALTER INDEX IF EXISTS vfoi_new_family_taxon_id_idx RENAME TO vfoi_family_taxon_id_idx;
ALTER INDEX IF EXISTS vfoi_new_genus_taxon_id_idx RENAME TO vfoi_genus_taxon_id_idx;
ALTER INDEX IF EXISTS vfoi_new_species_taxon_id_idx RENAME TO vfoi_species_taxon_id_idx;
ALTER INDEX IF EXISTS vfoi_new_verbatim_scientific_name_idx RENAME TO vfoi_verbatim_scientific_name_idx;
ALTER INDEX IF EXISTS vfoi_new_fk_tnrs_id_idx RENAME TO vfoi_fk_tnrs_id_idx;
ALTER INDEX IF EXISTS vfoi_new_family_matched_idx RENAME TO vfoi_family_matched_idx;
ALTER INDEX IF EXISTS vfoi_new_name_matched_idx RENAME TO vfoi_name_matched_idx;
ALTER INDEX IF EXISTS vfoi_new_matched_taxonomic_status_idx RENAME TO vfoi_matched_taxonomic_status_idx;
ALTER INDEX IF EXISTS vfoi_new_match_summary_idx RENAME TO vfoi_match_summary_idx;
ALTER INDEX IF EXISTS vfoi_new_scrubbed_taxonomic_status_idx RENAME TO vfoi_scrubbed_taxonomic_status_idx;
ALTER INDEX IF EXISTS vfoi_new_higher_plant_group_idx RENAME TO vfoi_higher_plant_group_idx;
ALTER INDEX IF EXISTS vfoi_new_scrubbed_family_idx RENAME TO vfoi_scrubbed_family_idx;
ALTER INDEX IF EXISTS vfoi_new_scrubbed_genus_idx RENAME TO vfoi_scrubbed_genus_idx;
ALTER INDEX IF EXISTS vfoi_new_scrubbed_species_binomial_idx RENAME TO vfoi_scrubbed_species_binomial_idx;
ALTER INDEX IF EXISTS vfoi_new_scrubbed_taxon_name_no_author_idx RENAME TO vfoi_scrubbed_taxon_name_no_author_idx;
ALTER INDEX IF EXISTS vfoi_new_scrubbed_species_binomial_with_morphospecies_idx RENAME TO vfoi_scrubbed_species_binomial_with_morphospecies_idx;
ALTER INDEX IF EXISTS vfoi_new_growth_form_idx RENAME TO vfoi_growth_form_idx;
ALTER INDEX IF EXISTS vfoi_new_cites_idx RENAME TO vfoi_cites_idx;
ALTER INDEX IF EXISTS vfoi_new_iucn_idx RENAME TO vfoi_iucn_idx;
ALTER INDEX IF EXISTS vfoi_new_usda_federal_idx RENAME TO vfoi_usda_federal_idx;
ALTER INDEX IF EXISTS vfoi_new_usda_state_idx RENAME TO vfoi_usda_state_idx;
ALTER INDEX IF EXISTS vfoi_new_is_embargoed_observation_idx RENAME TO vfoi_is_embargoed_observation_idx;
ALTER INDEX IF EXISTS vfoi_new_native_status_idx RENAME TO vfoi_native_status_idx;
ALTER INDEX IF EXISTS vfoi_new_is_introduced_idx RENAME TO vfoi_is_introduced_idx;
ALTER INDEX IF EXISTS vfoi_new_is_cultivated_in_region_idx RENAME TO vfoi_is_cultivated_in_region_idx;
ALTER INDEX IF EXISTS vfoi_new_is_cultivated_taxon_idx RENAME TO vfoi_is_cultivated_taxon_idx;
ALTER INDEX IF EXISTS vfoi_new_is_cultivated_observation_idx RENAME TO vfoi_is_cultivated_observation_idx;
ALTER INDEX IF EXISTS vfoi_new_geom_not_null_idx RENAME TO vfoi_geom_not_null_idx;
ALTER INDEX IF EXISTS vfoi_new_georef_protocol_idx RENAME TO vfoi_georef_protocol_idx;
ALTER INDEX IF EXISTS vfoi_new_is_location_cultivated_idx RENAME TO vfoi_is_location_cultivated_idx;
ALTER INDEX IF EXISTS vfoi_new_gid_0_idx RENAME TO vfoi_gid_0_idx;
ALTER INDEX IF EXISTS vfoi_new_gid_1_idx RENAME TO vfoi_gid_1_idx;
ALTER INDEX IF EXISTS vfoi_new_gid_2_idx RENAME TO vfoi_gid_2_idx;
ALTER INDEX IF EXISTS vfoi_new_fk_cds_id_idx RENAME TO vfoi_fk_cds_id_idx;
ALTER INDEX IF EXISTS vfoi_new_is_centroid_idx RENAME TO vfoi_is_centroid_idx;
ALTER INDEX IF EXISTS vfoi_new_centroid_type_idx RENAME TO vfoi_centroid_type_idx;
ALTER INDEX IF EXISTS vfoi_new_is_invalid_latlong_idx RENAME TO vfoi_is_invalid_latlong_idx;
ALTER INDEX IF EXISTS vfoi_new_nsr_id_idx RENAME TO vfoi_nsr_id_idx;
ALTER INDEX IF EXISTS vfoi_new_cods_proximity_id_idx RENAME TO vfoi_cods_proximity_id_idx;
ALTER INDEX IF EXISTS vfoi_new_cods_keyword_id_idx RENAME TO vfoi_cods_keyword_id_idx;
ALTER INDEX IF EXISTS vfoi_new_latlong_verbatim_idx RENAME TO vfoi_latlong_verbatim_idx;
ALTER INDEX IF EXISTS vfoi_new_datasetkey_idx RENAME TO vfoi_datasetkey_idx;
ALTER INDEX IF EXISTS vfoi_new_bien_range_model_default_idx RENAME TO vfoi_bien_range_model_default_idx;
ALTER INDEX IF EXISTS vfoi_new_georeferenced_species_idx RENAME TO vfoi_georeferenced_species_idx;
ALTER INDEX IF EXISTS vfoi_new_gist_idx RENAME TO vfoi_gist_idx;