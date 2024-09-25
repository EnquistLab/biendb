-- 
-- Create table bien_summary
--

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS bien_summary_public;
CREATE TABLE bien_summary_public (
bien_summary_public_id BIGSERIAL PRIMARY KEY,
db_version TEXT NOT NULL,
summary_timestamp date NOT NULL,
obs_count INTEGER DEFAULT NULL,
obs_geovalid_count INTEGER DEFAULT NULL,
specimen_count INTEGER DEFAULT NULL, 
plot_obs_count INTEGER DEFAULT NULL,
plot_count INTEGER DEFAULT NULL,
species_count INTEGER DEFAULT NULL
); 

