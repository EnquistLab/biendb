-- 
-- Hack to fix providers with >1 record
-- Proper fix out of scope: would require rebuilding table datasource
-- 

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS duplicate_providers;
CREATE TABLE duplicate_providers AS
SELECT provider, 
COUNT(*) AS num_records
FROM data_contributors 
GROUP BY provider 
HAVING count(*)>1;

ALTER TABLE duplicate_providers
ADD COLUMN sourcetype TEXT DEFAULT NULL, 
ADD COLUMN observationtype TEXT DEFAULT NULL,
ADD COLUMN url TEXT DEFAULT NULL, 
ADD COLUMN is_herbarium INTEGER DEFAULT NULL, 
ADD COLUMN url_ih TEXT DEFAULT NULL, 
ADD COLUMN provider_name TEXT DEFAULT NULL, 
ADD COLUMN city TEXT DEFAULT NULL, 
ADD COLUMN state_province TEXT DEFAULT NULL, 
ADD COLUMN country TEXT DEFAULT NULL,
ADD COLUMN datasource_id BIGINT DEFAULT NULL,
ADD COLUMN obs INTEGER DEFAULT NULL
;

UPDATE duplicate_providers a
SET 
provider=b.provider, 
sourcetype=b.sourcetype, 
observationtype=b.sourcetype,
url=b.url, 
is_herbarium=b.is_herbarium, 
url_ih=b.url_ih, 
provider_name=b.provider_name, 
city=b.city, 
state_province=b.state_province, 
country=b.country
FROM (
SELECT DISTINCT a.provider, a.sourcetype, a.observationtype,
a.url, a.is_herbarium, a.url_ih, a.provider_name, a.city, a.state_province, a.country
FROM data_contributors a JOIN duplicate_providers b
ON a.provider=b.provider
) AS b
WHERE a.provider=b.provider
;

UPDATE duplicate_providers a
SET datasource_id=b.max_id
FROM (
SELECT provider, MAX(datasource_id) AS max_id
FROM data_contributors 
GROUP BY provider
) AS b
WHERE a.provider=b.provider
;

UPDATE duplicate_providers a
SET obs=b.sum_obs
FROM (
SELECT provider, SUM(obs) AS sum_obs
FROM data_contributors 
GROUP BY provider
) AS b
WHERE a.provider=b.provider
;

UPDATE data_contributors a
SET sourcetype='delete'
FROM duplicate_providers b
WHERE a.provider=b.provider
;
DELETE FROM data_contributors
WHERE sourcetype='delete'
;

ALTER TABLE duplicate_providers
DROP COLUMN num_records;

-- Insert now-unique duplicate providers
INSERT INTO data_contributors (
datasource_id,
provider,
sourcetype,
observationtype,
obs,
url,
is_herbarium,
url_ih,
provider_name,
city,
state_province,
country
)
SELECT
datasource_id,
provider,
sourcetype,
observationtype,
obs,
url,
is_herbarium,
url_ih,
provider_name,
city,
state_province,
country
FROM duplicate_providers
;

DROP TABLE duplicate_providers;