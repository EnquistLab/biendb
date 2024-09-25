-- 
-- Update dev copy of table datasource from spreadsheet imported  
-- as table datasource_update in development schema 
--

SET search_path TO :dev_schema;

UPDATE datasource a
SET
source_name=b.source_name,
source_fullname=b.source_fullname, 
source_type=b.source_type,
observation_type=b.observation_type,
is_herbarium=b.is_herbarium,
proximate_provider_name=b.proximate_provider_name,
proximate_provider_datasource_id=b.proximate_provider_datasource_id,
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
WHERE a.source_name=b.source_name
AND a.proximate_provider_name=b.proximate_provider_name
; 

DROP TABLE IF EXISTS datasource_update;