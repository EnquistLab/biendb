-- --------------------------------------------------------------------
-- Remove pkey sequences to reduce clutter.
-- 
-- Auto-increments are unnecessary for data warehouse, where
-- new data added by rebuilding entire database. 
-- Only exception is bien_metadata: minor "in situ" database 
-- updates require insertion of new version records.
-- --------------------------------------------------------------------
SET search_path TO :sch;

DROP SEQUENCE IF EXISTS bien_summary_bien_summary_id_seq CASCADE;
DROP SEQUENCE IF EXISTS bien_taxonomy_bien_taxonomy_id_seq CASCADE;
DROP SEQUENCE IF EXISTS centroid_centroid_id_seq CASCADE;
DROP SEQUENCE IF EXISTS cultobs_cultobs_id_seq CASCADE;
DROP SEQUENCE IF EXISTS datasource_datasource_id_seq CASCADE;
DROP SEQUENCE IF EXISTS endangered_taxa_endangered_taxa_id_seq CASCADE;
DROP SEQUENCE IF EXISTS phylogeny_phylogeny_id_seq CASCADE;
DROP SEQUENCE IF EXISTS plot_metadata_plot_metadata_id_seq CASCADE;
DROP SEQUENCE IF EXISTS species_by_political_division_species_by_political_division_seq CASCADE;
DROP SEQUENCE IF EXISTS taxon_taxon_id_seq CASCADE;
DROP SEQUENCE IF EXISTS tnrs_tnrs_id_seq CASCADE;
DROP SEQUENCE IF EXISTS country_name_country_name_id_seq CASCADE;
DROP SEQUENCE IF EXISTS county_parish_name_county_parish_name_id_seq CASCADE;
DROP SEQUENCE IF EXISTS state_province_name_state_province_name_id_seq CASCADE;
DROP SEQUENCE IF EXISTS ranges_gid_seq CASCADE;
DROP SEQUENCE IF EXISTS species_id_seq CASCADE;
DROP SEQUENCE IF EXISTS tnrs_scrubbed_tnrs_scrubbed_id_seq CASCADE;
DROP SEQUENCE IF EXISTS tnrs_submitted_name_id_seq CASCADE;
DROP SEQUENCE IF EXISTS cods_desc_submitted_raw_id_seq CASCADE;
DROP SEQUENCE IF EXISTS datasource_staging_datasource_staging_id_seq CASCADE;
DROP SEQUENCE IF EXISTS endangered_taxa_by_source_endangered_taxa_by_source_id_seq CASCADE;
DROP SEQUENCE IF EXISTS gillespie_plot_data_raw_id_seq CASCADE;
DROP SEQUENCE IF EXISTS gnrs_submitted_id_seq CASCADE;
DROP SEQUENCE IF EXISTS nsr_submitted_user_id_seq CASCADE;
DROP SEQUENCE IF EXISTS cods_prox_submitted_id_seq CASCADE;
DROP SEQUENCE IF EXISTS cods_proximity_id_seq CASCADE;
DROP SEQUENCE IF EXISTS gnrs_id_seq CASCADE;
