-- 
-- Update dev copy of table datasource from spreadsheet imported  
-- as table datasource_update in development schema 
--

SET search_path TO :dev_schema;

DROP INDEX IF EXISTS datasource_update_proximate_provider_name_idx;
CREATE INDEX datasource_update_proximate_provider_name_idx ON datasource_update(proximate_provider_name);
DROP INDEX IF EXISTS datasource_update_source_name_idx;
CREATE INDEX datasource_update_source_name_idx ON datasource_update(source_name);

DROP INDEX IF EXISTS datasource_proximate_provider_name_idx;
CREATE INDEX datasource_proximate_provider_name_idx ON datasource(proximate_provider_name);
DROP INDEX IF EXISTS datasource_source_name_idx;
CREATE INDEX datasource_source_name_idx ON datasource(source_name);

UPDATE datasource a
SET
source_fullname=b.source_fullname, 
primary_contact_institution_name=b.primary_contact_institution_name,
primary_contact_firstname=b.primary_contact_firstname,
primary_contact_lastname=b.primary_contact_lastname,
primary_contact_fullname=b.primary_contact_fullname,
primary_contact_email=b.primary_contact_email,
source_url=b.source_url,
source_citation=b.source_citation,
access_conditions=b.access_conditions,
access_level=b.access_level,
locality_error_added=b.locality_error_added,
locality_error_details=b.locality_error_details
FROM datasource_update b
WHERE a.proximate_provider_name=b.proximate_provider_name
AND a.source_name=b.source_name
; 

DROP TABLE IF EXISTS datasource_update;