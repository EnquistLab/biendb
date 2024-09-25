-- 
-- Create table datasource
--

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS datasource;
CREATE TABLE datasource (
datasource_id BIGSERIAL PRIMARY KEY,
source_name TEXT DEFAULT NULL,
source_fullname TEXT DEFAULT NULL, 
source_type VARCHAR(50) DEFAULT NULL,
observation_type VARCHAR(50) DEFAULT NULL,
is_herbarium INTEGER DEFAULT 0,
proximate_provider_name TEXT DEFAULT NULL,
proximate_provider_datasource_id INTEGER,
primary_contact_institution_name TEXT DEFAULT NULL,
primary_contact_firstname TEXT DEFAULT NULL,
primary_contact_lastname TEXT DEFAULT NULL,
primary_contact_fullname TEXT DEFAULT NULL,
primary_contact_email TEXT DEFAULT NULL,
date_accessed date default null,
doi text default null,
source_url TEXT DEFAULT NULL,
source_citation TEXT DEFAULT NULL,
access_conditions TEXT DEFAULT 'acknowledge',
access_level TEXT DEFAULT NULL,
locality_error_added BOOLEAN DEFAULT FALSE,
locality_error_details TEXT DEFAULT NULL
); 