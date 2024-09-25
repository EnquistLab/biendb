-- 
-- Create table datasource
--

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS datasource;
CREATE TABLE datasource (
datasource_id BIGSERIAL PRIMARY KEY,
source_name VARCHAR(100) DEFAULT NULL,
source_fullname VARCHAR(500) DEFAULT NULL, 
source_type VARCHAR(50) DEFAULT NULL,
observation_type VARCHAR(25) DEFAULT NULL,
is_herbarium INTEGER DEFAULT 0,
proximate_provider_name VARCHAR(25) DEFAULT NULL,
proximate_provider_datasource_id INTEGER,
primary_contact_institution_name VARCHAR(500) DEFAULT NULL,
primary_contact_firstname VARCHAR(50) DEFAULT NULL,
primary_contact_lastname VARCHAR(50) DEFAULT NULL,
primary_contact_fullname VARCHAR(500) DEFAULT NULL,
primary_contact_email VARCHAR(500) DEFAULT NULL,
source_url TEXT DEFAULT NULL,
source_citation TEXT DEFAULT NULL,
access_conditions VARCHAR(50) DEFAULT 'acknowledge',
access_level VARCHAR(50) DEFAULT NULL,
locality_error_added BOOLEAN DEFAULT FALSE,
locality_error_details TEXT DEFAULT NULL
); 