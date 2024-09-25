--
-- Drop all indexes on agg_traits
--

SET search_path TO :sch;

-- Drop PK
-- Must drop constraints first, if any
ALTER TABLE agg_traits DROP CONSTRAINT IF EXISTS agg_traits_pkey;
DROP INDEX IF EXISTS agg_traits_pkey;
ALTER TABLE agg_traits DROP CONSTRAINT IF EXISTS agg_traits_bak_pkey;
DROP INDEX IF EXISTS agg_traits_bak_pkey;

-- Drop remaining indexes
DROP INDEX IF EXISTS agg_traits_fk_gnrs_id_idx;
DROP INDEX IF EXISTS agg_traits_country_idx;
DROP INDEX IF EXISTS agg_traits_country_state_province_idx;
DROP INDEX IF EXISTS agg_traits_country_state_province_county_idx;
DROP INDEX IF EXISTS agg_traits_lat_long_not_null_idx;
DROP INDEX IF EXISTS agg_traits_fk_centroid_id_idx;
DROP INDEX IF EXISTS agg_traits_is_in_country_idx;
DROP INDEX IF EXISTS agg_traits_is_in_state_province_idx;
DROP INDEX IF EXISTS agg_traits_is_in_county_idx;
DROP INDEX IF EXISTS agg_traits_is_geovalid_idx;
DROP INDEX IF EXISTS agg_traits_is_new_world_idx;
DROP INDEX IF EXISTS agg_traits_visiting_date_idx;
DROP INDEX IF EXISTS agg_traits_visiting_date_accuracy_idx;
DROP INDEX IF EXISTS agg_traits_elevation_m_idx;
DROP INDEX IF EXISTS agg_traits_observation_date_idx;
DROP INDEX IF EXISTS agg_traits_observation_date_accuracy_idx;
DROP INDEX IF EXISTS agg_traits_bien_taxonomy_id_idx;
DROP INDEX IF EXISTS agg_traits_taxon_id_idx;
DROP INDEX IF EXISTS agg_traits_family_taxon_id_idx;
DROP INDEX IF EXISTS agg_traits_genus_taxon_id_idx;
DROP INDEX IF EXISTS agg_traits_species_taxon_id_idx;
DROP INDEX IF EXISTS agg_traits_verbatim_scientific_name_idx;
DROP INDEX IF EXISTS agg_traits_fk_tnrs_id_idx;
DROP INDEX IF EXISTS agg_traits_family_matched_idx;
DROP INDEX IF EXISTS agg_traits_name_matched_idx;
DROP INDEX IF EXISTS agg_traits_matched_taxonomic_status_idx;
DROP INDEX IF EXISTS agg_traits_match_summary_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS agg_traits_higher_plant_group_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_family_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_genus_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_taxon_name_no_author_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_with_morphospecies_idx;
DROP INDEX IF EXISTS agg_traits_is_embargoed_observation_idx;
DROP INDEX IF EXISTS agg_traits_nsr_id_idx;
DROP INDEX IF EXISTS agg_traits_native_status_idx;
DROP INDEX IF EXISTS agg_traits_is_introduced_idx;
DROP INDEX IF EXISTS agg_traits_is_cultivated_in_region_idx;
DROP INDEX IF EXISTS agg_traits_is_cultivated_taxon_idx;
DROP INDEX IF EXISTS agg_traits_is_cultivated_observation_idx;
DROP INDEX IF EXISTS agg_traits_authorship_idx;
DROP INDEX IF EXISTS agg_traits_method_idx;
DROP INDEX IF EXISTS agg_traits_project_pi_idx;
DROP INDEX IF EXISTS agg_traits_region_idx;
DROP INDEX IF EXISTS agg_traits_source_idx;
DROP INDEX IF EXISTS agg_traits_trait_name_idx;
DROP INDEX IF EXISTS agg_traits_unit_idx;
DROP INDEX IF EXISTS agg_traits_is_experiment_idx;
DROP INDEX IF EXISTS agg_traits_is_individual_trait_idx;
DROP INDEX IF EXISTS agg_traits_is_species_trait_idx;
DROP INDEX IF EXISTS agg_traits_is_trait_value_valid_idx;
DROP INDEX IF EXISTS agg_traits_taxonobservation_id_idx;
DROP INDEX IF EXISTS agg_traits_is_individual_measurement_idx;
DROP INDEX IF EXISTS agg_traits_is_centroid_idx;