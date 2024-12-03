-- -----------------------------------------------------------------
-- Restores original index names after updated table 
-- "agg_traits_new" has been rename to
-- "agg_traits" by removing string "_new"
-- from all index names.
-- This is final step in moving updated duplicate table to production.
-- -----------------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

-- Original table
ALTER INDEX IF EXISTS agg_traits_fk_gnrs_id_idx RENAME TO agg_traits_4_2_8_fk_gnrs_id_idx;
ALTER INDEX IF EXISTS agg_traits_country_idx RENAME TO agg_traits_4_2_8_country_idx;
ALTER INDEX IF EXISTS agg_traits_country_state_province_idx RENAME TO agg_traits_4_2_8_country_state_province_idx;
ALTER INDEX IF EXISTS agg_traits_country_state_province_county_idx RENAME TO agg_traits_4_2_8_country_state_province_county_idx;
ALTER INDEX IF EXISTS agg_traits_lat_long_not_null_idx RENAME TO agg_traits_4_2_8_lat_long_not_null_idx;
ALTER INDEX IF EXISTS agg_traits_is_in_country_idx RENAME TO agg_traits_4_2_8_is_in_country_idx;
ALTER INDEX IF EXISTS agg_traits_is_in_state_province_idx RENAME TO agg_traits_4_2_8_is_in_state_province_idx;
ALTER INDEX IF EXISTS agg_traits_is_in_county_idx RENAME TO agg_traits_4_2_8_is_in_county_idx;
ALTER INDEX IF EXISTS agg_traits_is_geovalid_idx RENAME TO agg_traits_4_2_8_is_geovalid_idx;
ALTER INDEX IF EXISTS agg_traits_is_new_world_idx RENAME TO agg_traits_4_2_8_is_new_world_idx;
ALTER INDEX IF EXISTS agg_traits_visiting_date_idx RENAME TO agg_traits_4_2_8_visiting_date_idx;
ALTER INDEX IF EXISTS agg_traits_visiting_date_accuracy_idx RENAME TO agg_traits_4_2_8_visiting_date_accuracy_idx;
ALTER INDEX IF EXISTS agg_traits_elevation_m_idx RENAME TO agg_traits_4_2_8_elevation_m_idx;
ALTER INDEX IF EXISTS agg_traits_observation_date_idx RENAME TO agg_traits_4_2_8_observation_date_idx;
ALTER INDEX IF EXISTS agg_traits_observation_date_accuracy_idx RENAME TO agg_traits_4_2_8_observation_date_accuracy_idx;
ALTER INDEX IF EXISTS agg_traits_bien_taxonomy_id_idx RENAME TO agg_traits_4_2_8_bien_taxonomy_id_idx;
ALTER INDEX IF EXISTS agg_traits_taxon_id_idx RENAME TO agg_traits_4_2_8_taxon_id_idx;
ALTER INDEX IF EXISTS agg_traits_family_taxon_id_idx RENAME TO agg_traits_4_2_8_family_taxon_id_idx;
ALTER INDEX IF EXISTS agg_traits_genus_taxon_id_idx RENAME TO agg_traits_4_2_8_genus_taxon_id_idx;
ALTER INDEX IF EXISTS agg_traits_species_taxon_id_idx RENAME TO agg_traits_4_2_8_species_taxon_id_idx;
ALTER INDEX IF EXISTS agg_traits_verbatim_scientific_name_idx RENAME TO agg_traits_4_2_8_verbatim_scientific_name_idx;
ALTER INDEX IF EXISTS agg_traits_fk_tnrs_id_idx RENAME TO agg_traits_4_2_8_fk_tnrs_id_idx;
ALTER INDEX IF EXISTS agg_traits_family_matched_idx RENAME TO agg_traits_4_2_8_family_matched_idx;
ALTER INDEX IF EXISTS agg_traits_name_matched_idx RENAME TO agg_traits_4_2_8_name_matched_idx;
ALTER INDEX IF EXISTS agg_traits_matched_taxonomic_status_idx RENAME TO agg_traits_4_2_8_matched_taxonomic_status_idx;
ALTER INDEX IF EXISTS agg_traits_match_summary_idx RENAME TO agg_traits_4_2_8_match_summary_idx;
ALTER INDEX IF EXISTS agg_traits_scrubbed_taxonomic_status_idx RENAME TO agg_traits_4_2_8_scrubbed_taxonomic_status_idx;
ALTER INDEX IF EXISTS agg_traits_higher_plant_group_idx RENAME TO agg_traits_4_2_8_higher_plant_group_idx;
ALTER INDEX IF EXISTS agg_traits_scrubbed_family_idx RENAME TO agg_traits_4_2_8_scrubbed_family_idx;
ALTER INDEX IF EXISTS agg_traits_scrubbed_genus_idx RENAME TO agg_traits_4_2_8_scrubbed_genus_idx;
ALTER INDEX IF EXISTS agg_traits_scrubbed_species_binomial_idx RENAME TO agg_traits_4_2_8_scrubbed_species_binomial_idx;
ALTER INDEX IF EXISTS agg_traits_scrubbed_taxon_name_no_author_idx RENAME TO agg_traits_4_2_8_scrubbed_taxon_name_no_author_idx;
ALTER INDEX IF EXISTS agg_traits_scrubbed_species_binomial_with_morphospecies_idx RENAME TO agg_traits_4_2_8_scrubbed_species_binomial_with_morphospecies_idx;
ALTER INDEX IF EXISTS agg_traits_is_embargoed_observation_idx RENAME TO agg_traits_4_2_8_is_embargoed_observation_idx;
ALTER INDEX IF EXISTS agg_traits_nsr_id_idx RENAME TO agg_traits_4_2_8_nsr_id_idx;
ALTER INDEX IF EXISTS agg_traits_native_status_idx RENAME TO agg_traits_4_2_8_native_status_idx;
ALTER INDEX IF EXISTS agg_traits_is_introduced_idx RENAME TO agg_traits_4_2_8_is_introduced_idx;
ALTER INDEX IF EXISTS agg_traits_is_cultivated_in_region_idx RENAME TO agg_traits_4_2_8_is_cultivated_in_region_idx;
ALTER INDEX IF EXISTS agg_traits_is_cultivated_taxon_idx RENAME TO agg_traits_4_2_8_is_cultivated_taxon_idx;
ALTER INDEX IF EXISTS agg_traits_is_cultivated_observation_idx RENAME TO agg_traits_4_2_8_is_cultivated_observation_idx;
ALTER INDEX IF EXISTS agg_traits_authorship_idx RENAME TO agg_traits_4_2_8_authorship_idx;
ALTER INDEX IF EXISTS agg_traits_method_idx RENAME TO agg_traits_4_2_8_method_idx;
ALTER INDEX IF EXISTS agg_traits_project_pi_idx RENAME TO agg_traits_4_2_8_project_pi_idx;
ALTER INDEX IF EXISTS agg_traits_region_idx RENAME TO agg_traits_4_2_8_region_idx;
ALTER INDEX IF EXISTS agg_traits_source_idx RENAME TO agg_traits_4_2_8_source_idx;
ALTER INDEX IF EXISTS agg_traits_trait_name_idx RENAME TO agg_traits_4_2_8_trait_name_idx;
ALTER INDEX IF EXISTS agg_traits_unit_idx RENAME TO agg_traits_4_2_8_unit_idx;
ALTER INDEX IF EXISTS agg_traits_is_experiment_idx RENAME TO agg_traits_4_2_8_is_experiment_idx;
ALTER INDEX IF EXISTS agg_traits_is_individual_trait_idx RENAME TO agg_traits_4_2_8_is_individual_trait_idx;
ALTER INDEX IF EXISTS agg_traits_is_species_trait_idx RENAME TO agg_traits_4_2_8_is_species_trait_idx;
ALTER INDEX IF EXISTS agg_traits_is_trait_value_valid_idx RENAME TO agg_traits_4_2_8_is_trait_value_valid_idx;
ALTER INDEX IF EXISTS agg_traits_taxonobservation_id_idx RENAME TO agg_traits_4_2_8_taxonobservation_id_idx;
ALTER INDEX IF EXISTS agg_traits_is_individual_measurement_idx RENAME TO agg_traits_4_2_8_is_individual_measurement_idx;
ALTER INDEX IF EXISTS agg_traits_gid_0_idx RENAME TO agg_traits_4_2_8_gid_0_idx;
ALTER INDEX IF EXISTS agg_traits_gid_1_idx RENAME TO agg_traits_4_2_8_gid_1_idx;
ALTER INDEX IF EXISTS agg_traits_gid_2_idx RENAME TO agg_traits_4_2_8_gid_2_idx;
ALTER INDEX IF EXISTS agg_traits_fk_cds_id_idx RENAME TO agg_traits_4_2_8_fk_cds_id_idx;
ALTER INDEX IF EXISTS agg_traits_is_centroid_idx RENAME TO agg_traits_4_2_8_is_centroid_idx;
ALTER INDEX IF EXISTS agg_traits_centroid_type_idx RENAME TO agg_traits_4_2_8_centroid_type_idx;
ALTER INDEX IF EXISTS agg_traits_is_invalid_latlong_idx RENAME TO agg_traits_4_2_8_is_invalid_latlong_idx;
ALTER INDEX IF EXISTS agg_traits_cods_proximity_id_idx RENAME TO agg_traits_4_2_8_cods_proximity_id_idx;
ALTER INDEX IF EXISTS agg_traits_cods_keyword_id_idx RENAME TO agg_traits_4_2_8_cods_keyword_id_idx;

-- New table
ALTER INDEX IF EXISTS agg_traits_new_fk_gnrs_id_idx RENAME TO agg_traits_fk_gnrs_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_country_idx RENAME TO agg_traits_country_idx;
ALTER INDEX IF EXISTS agg_traits_new_country_state_province_idx RENAME TO agg_traits_country_state_province_idx;
ALTER INDEX IF EXISTS agg_traits_new_country_state_province_county_idx RENAME TO agg_traits_country_state_province_county_idx;
ALTER INDEX IF EXISTS agg_traits_new_lat_long_not_null_idx RENAME TO agg_traits_lat_long_not_null_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_in_country_idx RENAME TO agg_traits_is_in_country_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_in_state_province_idx RENAME TO agg_traits_is_in_state_province_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_in_county_idx RENAME TO agg_traits_is_in_county_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_geovalid_idx RENAME TO agg_traits_is_geovalid_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_new_world_idx RENAME TO agg_traits_is_new_world_idx;
ALTER INDEX IF EXISTS agg_traits_new_visiting_date_idx RENAME TO agg_traits_visiting_date_idx;
ALTER INDEX IF EXISTS agg_traits_new_visiting_date_accuracy_idx RENAME TO agg_traits_visiting_date_accuracy_idx;
ALTER INDEX IF EXISTS agg_traits_new_elevation_m_idx RENAME TO agg_traits_elevation_m_idx;
ALTER INDEX IF EXISTS agg_traits_new_observation_date_idx RENAME TO agg_traits_observation_date_idx;
ALTER INDEX IF EXISTS agg_traits_new_observation_date_accuracy_idx RENAME TO agg_traits_observation_date_accuracy_idx;
ALTER INDEX IF EXISTS agg_traits_new_bien_taxonomy_id_idx RENAME TO agg_traits_bien_taxonomy_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_taxon_id_idx RENAME TO agg_traits_taxon_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_family_taxon_id_idx RENAME TO agg_traits_family_taxon_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_genus_taxon_id_idx RENAME TO agg_traits_genus_taxon_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_species_taxon_id_idx RENAME TO agg_traits_species_taxon_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_verbatim_scientific_name_idx RENAME TO agg_traits_verbatim_scientific_name_idx;
ALTER INDEX IF EXISTS agg_traits_new_fk_tnrs_id_idx RENAME TO agg_traits_fk_tnrs_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_family_matched_idx RENAME TO agg_traits_family_matched_idx;
ALTER INDEX IF EXISTS agg_traits_new_name_matched_idx RENAME TO agg_traits_name_matched_idx;
ALTER INDEX IF EXISTS agg_traits_new_matched_taxonomic_status_idx RENAME TO agg_traits_matched_taxonomic_status_idx;
ALTER INDEX IF EXISTS agg_traits_new_match_summary_idx RENAME TO agg_traits_match_summary_idx;
ALTER INDEX IF EXISTS agg_traits_new_scrubbed_taxonomic_status_idx RENAME TO agg_traits_scrubbed_taxonomic_status_idx;
ALTER INDEX IF EXISTS agg_traits_new_higher_plant_group_idx RENAME TO agg_traits_higher_plant_group_idx;
ALTER INDEX IF EXISTS agg_traits_new_scrubbed_family_idx RENAME TO agg_traits_scrubbed_family_idx;
ALTER INDEX IF EXISTS agg_traits_new_scrubbed_genus_idx RENAME TO agg_traits_scrubbed_genus_idx;
ALTER INDEX IF EXISTS agg_traits_new_scrubbed_species_binomial_idx RENAME TO agg_traits_scrubbed_species_binomial_idx;
ALTER INDEX IF EXISTS agg_traits_new_scrubbed_taxon_name_no_author_idx RENAME TO agg_traits_scrubbed_taxon_name_no_author_idx;
ALTER INDEX IF EXISTS agg_traits_new_scrubbed_species_binomial_with_morphospecies_idx RENAME TO agg_traits_scrubbed_species_binomial_with_morphospecies_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_embargoed_observation_idx RENAME TO agg_traits_is_embargoed_observation_idx;
ALTER INDEX IF EXISTS agg_traits_new_nsr_id_idx RENAME TO agg_traits_nsr_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_native_status_idx RENAME TO agg_traits_native_status_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_introduced_idx RENAME TO agg_traits_is_introduced_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_cultivated_in_region_idx RENAME TO agg_traits_is_cultivated_in_region_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_cultivated_taxon_idx RENAME TO agg_traits_is_cultivated_taxon_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_cultivated_observation_idx RENAME TO agg_traits_is_cultivated_observation_idx;
ALTER INDEX IF EXISTS agg_traits_new_authorship_idx RENAME TO agg_traits_authorship_idx;
ALTER INDEX IF EXISTS agg_traits_new_method_idx RENAME TO agg_traits_method_idx;
ALTER INDEX IF EXISTS agg_traits_new_project_pi_idx RENAME TO agg_traits_project_pi_idx;
ALTER INDEX IF EXISTS agg_traits_new_region_idx RENAME TO agg_traits_region_idx;
ALTER INDEX IF EXISTS agg_traits_new_source_idx RENAME TO agg_traits_source_idx;
ALTER INDEX IF EXISTS agg_traits_new_trait_name_idx RENAME TO agg_traits_trait_name_idx;
ALTER INDEX IF EXISTS agg_traits_new_unit_idx RENAME TO agg_traits_unit_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_experiment_idx RENAME TO agg_traits_is_experiment_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_individual_trait_idx RENAME TO agg_traits_is_individual_trait_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_species_trait_idx RENAME TO agg_traits_is_species_trait_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_trait_value_valid_idx RENAME TO agg_traits_is_trait_value_valid_idx;
ALTER INDEX IF EXISTS agg_traits_new_taxonobservation_id_idx RENAME TO agg_traits_taxonobservation_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_individual_measurement_idx RENAME TO agg_traits_is_individual_measurement_idx;
ALTER INDEX IF EXISTS agg_traits_new_gid_0_idx RENAME TO agg_traits_gid_0_idx;
ALTER INDEX IF EXISTS agg_traits_new_gid_1_idx RENAME TO agg_traits_gid_1_idx;
ALTER INDEX IF EXISTS agg_traits_new_gid_2_idx RENAME TO agg_traits_gid_2_idx;
ALTER INDEX IF EXISTS agg_traits_new_fk_cds_id_idx RENAME TO agg_traits_fk_cds_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_centroid_idx RENAME TO agg_traits_is_centroid_idx;
ALTER INDEX IF EXISTS agg_traits_new_centroid_type_idx RENAME TO agg_traits_centroid_type_idx;
ALTER INDEX IF EXISTS agg_traits_new_is_invalid_latlong_idx RENAME TO agg_traits_is_invalid_latlong_idx;
ALTER INDEX IF EXISTS agg_traits_new_cods_proximity_id_idx RENAME TO agg_traits_cods_proximity_id_idx;
ALTER INDEX IF EXISTS agg_traits_new_cods_keyword_id_idx RENAME TO agg_traits_cods_keyword_id_idx;
