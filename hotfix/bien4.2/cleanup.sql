-- ---------------------------------------------------------------
-- Manual deletion or moving of tables after completion of most of
-- pipeline Step 3 (adb_private_3_update_metadata.sh)
--
-- Data dictionary built *after* running these commands
-- ---------------------------------------------------------------

set search_path to analytical_db_dev;

--
-- Remove staging tables
-- Left over after stopping for errors
--

DROP TABLE plot_metadata_staging;
DROP TABLE analytical_stem_staging;
DROP TABLE vfoi_staging;
DROP TABLE datasource_staging;
--
-- Remove obvious old backup tables
--

DROP TABLE agg_traits_nonuinque_bak;
DROP TABLE cods_keyword_oldschema_temp;
DROP TABLE cods_prox_submitted_uniq;
DROP TABLE cods_proximity_oldschema_temp;
DROP TABLE gnrs_nonuinque_bak;
DROP TABLE plot_metadata_bak;
DROP TABLE species_observation_counts_bak;
DROP TABLE vfoi_temp;
DROP TABLE view_full_occurrence_individual_dev_nonuinque_bak;

--
-- Drop temporary PKs and sequences
--

DROP SEQUENCE agg_traits_super_temporary_pk_seq CASCADE;
ALTER TABLE agg_traits
DROP COLUMN super_temporary_pk;
DROP SEQUENCE view_full_occurrence_individual_dev_super_temporary_pk_seq CASCADE;
ALTER TABLE view_full_occurrence_individual_dev
DROP COLUMN super_temporary_pk;

--
-- Drop other unneeded sequences
--

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
DROP SEQUENCE IF EXISTS cds_id_seq CASCADE;


--
-- Remove data dictionary tables (will rebuild later)
--

DROP TABLE dd_cols_prev;
DROP TABLE dd_tables_prev;
DROP TABLE dd_vals_prev;
DROP TABLE data_dictionary_columns;
DROP TABLE data_dictionary_tables;
DROP TABLE data_dictionary_values;


--
-- Drop remaining temp tables
--

DROP TABLE IF EXISTS 
endangered_taxa_verbatim,
endangered_taxa_by_state,
endangered_taxa_by_source,
plot_provenance,
proximate_providers,
us_states,
nsr_submitted,
vfoi_dup,
herbaria,
poldivs,
cds_submitted,
cods_desc_submitted,
cods_desc_submitted_raw,
cods_prox_submitted,
datasource_raw,
cds_submitted,
gnrs_submitted,
nsr_submitted,
nsr_submitted_raw,
plot_provenance,
proximate_providers
;


--
-- Move raw data tables to source-specific schemas
--

DROP SCHEMA IF EXISTS ala CASCADE;
CREATE SCHEMA ala;
ALTER TABLE ala_raw SET SCHEMA ala;

DROP SCHEMA IF EXISTS chilesp CASCADE;
CREATE SCHEMA chilesp;
ALTER TABLE chilesp_raw SET SCHEMA chilesp;

DROP SCHEMA IF EXISTS dryflor CASCADE;
CREATE SCHEMA dryflor;
ALTER TABLE dryflor_raw SET SCHEMA dryflor;

DROP SCHEMA IF EXISTS gillespie CASCADE;
CREATE SCHEMA gillespie;
ALTER TABLE gillespie_people_raw SET SCHEMA gillespie;
ALTER TABLE gillespie_plot_data_raw SET SCHEMA gillespie;
ALTER TABLE gillespie_plot_descriptions_raw SET SCHEMA gillespie;

DROP SCHEMA IF EXISTS ntt CASCADE;
CREATE SCHEMA ntt;
ALTER TABLE ntt_areas_raw SET SCHEMA ntt;
ALTER TABLE ntt_sources_areas_raw SET SCHEMA ntt;
ALTER TABLE ntt_sources_raw SET SCHEMA ntt;
ALTER TABLE ntt_species_areas_raw SET SCHEMA ntt;
ALTER TABLE ntt_species_raw SET SCHEMA ntt;

DROP SCHEMA IF EXISTS rainbio CASCADE;
CREATE SCHEMA rainbio;
ALTER TABLE rainbio_raw SET SCHEMA rainbio;

DROP SCHEMA IF EXISTS schep CASCADE;
CREATE SCHEMA schep;
ALTER TABLE schep_plotdb_raw SET SCHEMA schep;
ALTER TABLE schep_tree_db_raw SET SCHEMA schep;

DROP SCHEMA IF EXISTS "GBIF" CASCADE;
CREATE SCHEMA "GBIF";
ALTER TABLE gbif_occurrence_raw SET SCHEMA "GBIF";

DROP SCHEMA IF EXISTS "Cyrille_traits" CASCADE;
DROP SCHEMA IF EXISTS "traits" CASCADE;
CREATE SCHEMA "traits";
ALTER TABLE traits_raw SET SCHEMA "traits";

--
-- Rename the main tables
--

ALTER TABLE view_full_occurrence_individual_dev RENAME TO view_full_occurrence_individual;
ALTER TABLE analytical_stem_dev RENAME TO analytical_stem;

