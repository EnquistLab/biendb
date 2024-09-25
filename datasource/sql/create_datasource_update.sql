-- 
-- Create table datasource
--

SET search_path TO :dev_schema;

-- Note changed column order from original table
-- Allows reused of legacy spreadsheet edit by Brian Maitner
-- Eventually should switch back to exact copy of original table
DROP TABLE IF EXISTS datasource_update;
CREATE TABLE datasource_update (LIKE datasource INCCLUDING ALL); 

CREATE INDEX ON datasource_update (datasource_id);
CREATE INDEX ON datasource_update (proximate_provider_name);
CREATE INDEX ON datasource_update (source_name);