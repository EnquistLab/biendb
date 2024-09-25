-- 
-- Add remaining indexes to final table
--

SET search_path TO :dev_schema;

DROP INDEX IF EXISTS data_contributors_sourcetype_idx;
DROP INDEX IF EXISTS data_contributors_observationtype_idx;
DROP INDEX IF EXISTS data_contributors_is_herbarium_idx;
DROP INDEX IF EXISTS data_contributors_provider_name_idx;
DROP INDEX IF EXISTS data_contributors_country_idx;
DROP INDEX IF EXISTS data_contributors_proximate_provider_idx;

CREATE INDEX data_contributors_sourcetype_idx ON data_contributors (sourcetype);
CREATE INDEX data_contributors_observationtype_idx ON data_contributors (observationtype);
CREATE INDEX data_contributors_is_herbarium_idx ON data_contributors (is_herbarium);
CREATE INDEX data_contributors_provider_name_idx ON data_contributors (provider_name);
CREATE INDEX data_contributors_country_idx ON data_contributors (country);
CREATE INDEX data_contributors_proximate_provider_idx ON data_contributors (proximate_provider);


DROP INDEX IF EXISTS proximate_providers_proximate_provider_idx;
DROP INDEX IF EXISTS proximate_providers_datasource_id_idx;

CREATE INDEX proximate_providers_proximate_provider_idx ON proximate_providers (proximate_provider);
CREATE INDEX proximate_providers_datasource_id_idx ON proximate_providers (datasource_id);