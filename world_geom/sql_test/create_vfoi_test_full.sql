SET search_path to analytical_db_dev2, postgis;

DROP TABLE IF EXISTS vfoi_test_full;
CREATE TABLE vfoi_test_full (LIKE analytical_db.view_full_occurrence_individual INCLUDING INDEXES INCLUDING CONSTRAINTS);

INSERT INTO vfoi_test_full (
taxonobservation_id,
datasource,
dataset,
country_verbatim, 
state_province_verbatim, 
county_verbatim,
country, 
state_province, 
county,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
latitude,
longitude,
geom
)
SELECT 
taxonobservation_id,
datasource,
dataset,
country_verbatim, 
state_province_verbatim, 
county_verbatim,
country, 
state_province, 
county,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
latitude,
longitude,
geom
FROM analytical_db.view_full_occurrence_individual
;

ALTER TABLE vfoi_test_full DROP CONSTRAINT IF EXISTS  vfoi_test_full_pkey;
DROP INDEX IF EXISTS vfoi_test_full_bien_taxonomy_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_catalog_number_idx;
DROP INDEX IF EXISTS vfoi_test_full_cites_idx;
DROP INDEX IF EXISTS vfoi_test_full_country_idx;
DROP INDEX IF EXISTS vfoi_test_full_country_state_province_county_idx;
DROP INDEX IF EXISTS vfoi_test_full_country_state_province_idx;
DROP INDEX IF EXISTS vfoi_test_full_dataset_idx;
DROP INDEX IF EXISTS vfoi_test_full_datasource_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_datasource_idx;
DROP INDEX IF EXISTS vfoi_test_full_date_collected_accuracy_idx;
DROP INDEX IF EXISTS vfoi_test_full_date_collected_idx;
DROP INDEX IF EXISTS vfoi_test_full_elevation_m_idx;
DROP INDEX IF EXISTS vfoi_test_full_event_date_accuracy_idx;
DROP INDEX IF EXISTS vfoi_test_full_event_date_idx;
DROP INDEX IF EXISTS vfoi_test_full_family_matched_idx;
DROP INDEX IF EXISTS vfoi_test_full_family_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_fk_centroid_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_fk_gnrs_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_fk_tnrs_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_genus_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_georef_protocol_idx;
DROP INDEX IF EXISTS vfoi_test_full_growth_form_idx;
DROP INDEX IF EXISTS vfoi_test_full_higher_plant_group_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_cultivated_in_region_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_cultivated_observation_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_cultivated_taxon_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_embargoed_observation_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_geovalid_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_geovalid_idx1;
DROP INDEX IF EXISTS vfoi_test_full_is_geovalid_idx2;
DROP INDEX IF EXISTS vfoi_test_full_is_in_country_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_in_county_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_in_state_province_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_introduced_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_location_cultivated_idx;
DROP INDEX IF EXISTS vfoi_test_full_is_new_world_idx;
DROP INDEX IF EXISTS vfoi_test_full_iucn_idx;
DROP INDEX IF EXISTS vfoi_test_full_match_summary_idx;
DROP INDEX IF EXISTS vfoi_test_full_matched_taxonomic_status_idx;
DROP INDEX IF EXISTS vfoi_test_full_name_matched_idx;
DROP INDEX IF EXISTS vfoi_test_full_native_status_idx;
DROP INDEX IF EXISTS vfoi_test_full_nsr_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_observation_type_idx;
DROP INDEX IF EXISTS vfoi_test_full_plot_area_ha_idx;
DROP INDEX IF EXISTS vfoi_test_full_plot_metadata_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_plot_name_idx;
DROP INDEX IF EXISTS vfoi_test_full_plot_name_subplot_idx;
DROP INDEX IF EXISTS vfoi_test_full_sampling_protocol_idx;
DROP INDEX IF EXISTS vfoi_test_full_scrubbed_family_idx;
DROP INDEX IF EXISTS vfoi_test_full_scrubbed_genus_idx;
DROP INDEX IF EXISTS vfoi_test_full_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS vfoi_test_full_scrubbed_species_binomial_idx1;
DROP INDEX IF EXISTS vfoi_test_full_scrubbed_species_binomial_idx2;
DROP INDEX IF EXISTS vfoi_test_full_scrubbed_species_binomial_with_morphospecies_idx;
DROP INDEX IF EXISTS vfoi_test_full_scrubbed_taxon_name_no_author_idx;
DROP INDEX IF EXISTS vfoi_test_full_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS vfoi_test_full_species_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_taxon_id_idx;
DROP INDEX IF EXISTS vfoi_test_full_usda_federal_idx;
DROP INDEX IF EXISTS vfoi_test_full_usda_state_idx;
DROP INDEX IF EXISTS vfoi_test_full_verbatim_scientific_name_idx;
ALTER TABLE vfoi_test_full DROP CONSTRAINT IF EXISTS  enforce_dimensions_geom;
ALTER TABLE vfoi_test_full DROP CONSTRAINT IF EXISTS  enforce_geometrytype_geom;
ALTER TABLE vfoi_test_full DROP CONSTRAINT IF EXISTS  enforce_srid_geom;

ALTER TABLE vfoi_test_full RENAME COLUMN is_in_country TO is_in_country_orig;
ALTER TABLE vfoi_test_full RENAME COLUMN is_in_state_province TO is_in_state_province_orig;
ALTER TABLE vfoi_test_full RENAME COLUMN is_in_county TO is_in_county_orig;
ALTER TABLE vfoi_test_full RENAME COLUMN is_geovalid TO is_geovalid_orig;

ALTER TABLE vfoi_test_full
ADD COLUMN is_in_country smallint  DEFAULT NULL,
ADD COLUMN is_in_state_province smallint DEFAULT NULL,
ADD COLUMN is_in_county smallint  DEFAULT NULL,
ADD COLUMN is_geovalid smallint  DEFAULT NULL
;
