-- -------------------------------------------------------------------
-- Move raw data tables to source-specific schemas
-- 'DROP SCHEMA' statements remove raw data from previous database
-- 

SET search_path TO :sch;

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


