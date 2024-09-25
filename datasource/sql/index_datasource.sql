-- 
-- Add remaining indexes
--

SET search_path TO :dev_schema;

CREATE INDEX ON datasource (source_fullname);
CREATE INDEX ON datasource (source_type);
CREATE INDEX ON datasource (observation_type);
CREATE INDEX ON datasource (primary_contact_fullname);
CREATE INDEX ON datasource (access_conditions);

-- Index recursive foreign key
CREATE INDEX ON datasource (proximate_provider_datasource_id);