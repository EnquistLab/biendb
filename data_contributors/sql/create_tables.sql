-- 
-- Create table data_contributors in development schema
--

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS data_contributors;
CREATE TABLE data_contributors (
datasource_id bigint DEFAULT NULL,
provider TEXT NOT NULL,
provider_name TEXT DEFAULT NULL,
proximate_provider TEXT NOT NULL,
sourcetype TEXT DEFAULT NULL,
observationtype TEXT DEFAULT NULL,
obs INTEGER DEFAULT NULL,
url TEXT DEFAULT NULL,
is_herbarium INTEGER DEFAULT NULL,
url_ih TEXT DEFAULT NULL,
city TEXT DEFAULT NULL,
state_province TEXT DEFAULT NULL,
country TEXT DEFAULT NULL
);

DROP TABLE IF EXISTS proximate_providers;
CREATE TABLE proximate_providers (
datasource_id bigint DEFAULT NULL,
proximate_provider TEXT NOT NULL,
proximate_provider_name TEXT DEFAULT NULL,
sourcetype TEXT DEFAULT NULL,
observationtype TEXT DEFAULT NULL,
obs INTEGER DEFAULT NULL
);
