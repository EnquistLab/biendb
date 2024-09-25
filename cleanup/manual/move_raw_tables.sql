-- -------------------------------------------------------------------
-- Move raw data tables to source-specific schemas
-- -------------------------------------------------------------------

--  
-- Note lack of 'DROP SCHEMA' statements. Script will fail if any  
-- of these schemas already exist. This precaution avoids  
-- accidental deletion of raw data during development runs.
-- 

SET search_path TO :dev_sch;

CREATE SCHEMA ala;
ALTER TABLE ala_raw SET SCHEMA ala;

CREATE SCHEMA chilesp;
ALTER TABLE chilesp_raw SET SCHEMA chilesp;

CREATE SCHEMA dryflor;
ALTER TABLE dryflor_raw SET SCHEMA chilesp;

CREATE SCHEMA gillespie;
ALTER TABLE gillespie_people_raw SET SCHEMA gillespie;
ALTER TABLE gillespie_plot_data_raw SET SCHEMA gillespie;
ALTER TABLE gillespie_plot_descriptions_raw SET SCHEMA gillespie;

CREATE SCHEMA ntt;
ALTER TABLE ntt_areas_raw SET SCHEMA ntt;
ALTER TABLE ntt_sources_areas_raw SET SCHEMA ntt;
ALTER TABLE ntt_sources_raw SET SCHEMA ntt;
ALTER TABLE ntt_species_areas_raw SET SCHEMA ntt;
ALTER TABLE ntt_species_raw SET SCHEMA ntt;

CREATE SCHEMA rainbio;
ALTER TABLE rainbio_raw SET SCHEMA rainbio;

CREATE SCHEMA schep;
ALTER TABLE schep_plotdb_raw SET SCHEMA schep;
ALTER TABLE schep_tree_db_raw SET SCHEMA schep;

