--
-- Drop all indexes on vfoi
-- 

SET search_path TO :sch;

DROP INDEX IF EXISTS vfoi_pkey;
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
DROP INDEX IF EXISTS vfoi_geom_not_null_idx;

-- New columns:
DROP INDEX IF EXISTS vfoi_country_verbatim_idx;
DROP INDEX IF EXISTS vfoi_state_province_verbatim_idx;
DROP INDEX IF EXISTS vfoi_county_verbatim_idx;
DROP INDEX IF EXISTS vfoi_country_verbatim_is_null_idx;
DROP INDEX IF EXISTS vfoi_state_province_verbatim_is_null_idx;
DROP INDEX IF EXISTS vfoi_county_verbatim_is_null_idx;
DROP INDEX IF EXISTS vfoi_poldiv_full_idx;
DROP INDEX IF EXISTS vfoi_col_idx;
DROP INDEX IF EXISTS vfoi_col_idx;
DROP INDEX IF EXISTS vfoi_col_idx;
DROP INDEX IF EXISTS vfoi_col_idx;
DROP INDEX IF EXISTS vfoi_col_idx;
