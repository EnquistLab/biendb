-- -------------------------------------------------------------------
-- Move raw data tables to source-specific schemas
-- -------------------------------------------------------------------

--  
-- Drops raw data tables instead of moving to own schemas
-- 

SET search_path TO :sch;

DROP TABLE IF EXISTS ala_raw CASCADE;

DROP TABLE IF EXISTS chilesp_raw CASCADE;

DROP TABLE IF EXISTS dryflor_raw CASCADE;

DROP TABLE IF EXISTS gillespie_people_raw CASCADE;
DROP TABLE IF EXISTS gillespie_plot_data_raw CASCADE;
DROP TABLE IF EXISTS gillespie_plot_descriptions_raw CASCADE;

DROP TABLE IF EXISTS ntt_areas_raw CASCADE;
DROP TABLE IF EXISTS ntt_sources_areas_raw CASCADE;
DROP TABLE IF EXISTS ntt_sources_raw CASCADE;
DROP TABLE IF EXISTS ntt_species_areas_raw CASCADE;
DROP TABLE IF EXISTS ntt_species_raw CASCADE;

DROP TABLE IF EXISTS rainbio_raw CASCADE;

DROP TABLE IF EXISTS schep_plotdb_raw CASCADE;
DROP TABLE IF EXISTS schep_tree_db_raw CASCADE;

