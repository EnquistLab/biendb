-- -------------------------------------------------------------------------
-- Update table datasource with content from BIEN 4.1.1
--
-- Recycling information as basically nothing has changed
-- Note that module "update_datasource.sh" MUST be commented out
-- in pipeline step 4 for this to work
-- -------------------------------------------------------------------------

set search_path to analytical_db_dev;

DROP TABLE IF EXISTS datasource_update;
CREATE TABLE datasource_update (LIKE analytical_db.datasource INCLUDING ALL); 
INSERT INTO datasource_update SELECT * FROM analytical_db.datasource;

-- CREATE INDEX ON datasource_update (datasource_id);
-- CREATE INDEX ON datasource_update (proximate_provider_name);
-- CREATE INDEX ON datasource_update (source_name);


UPDATE datasource a
SET
source_fullname=
CASE 
WHEN a.source_fullname IS NULL THEN b.source_fullname
ELSE a.source_fullname
END, 
primary_contact_institution_name=
CASE 
WHEN a.primary_contact_institution_name IS NULL THEN b.primary_contact_institution_name
ELSE a.primary_contact_institution_name
END, 
primary_contact_firstname=
CASE 
WHEN a.primary_contact_firstname IS NULL THEN b.primary_contact_firstname
ELSE a.primary_contact_firstname
END, 
primary_contact_lastname=
CASE 
WHEN a.primary_contact_lastname IS NULL THEN b.primary_contact_lastname
ELSE a.primary_contact_lastname
END, 
primary_contact_fullname=
CASE 
WHEN a.primary_contact_fullname IS NULL THEN b.primary_contact_fullname
ELSE a.primary_contact_fullname
END, 
primary_contact_email=
CASE 
WHEN a.primary_contact_email IS NULL THEN b.primary_contact_email
WHEN a.primary_contact_email NOT LIKE '%@%' THEN b.primary_contact_email
ELSE a.primary_contact_email
END, 
source_url=
CASE 
WHEN a.source_url IS NULL THEN b.source_url
ELSE a.source_url
END, 
source_citation=b.source_citation, 
access_conditions=
CASE 
WHEN a.access_conditions IS NULL THEN b.access_conditions
ELSE a.access_conditions
END, 
access_level=
CASE 
WHEN a.access_level IS NULL THEN b.access_level
ELSE a.access_level
END, 
locality_error_added=
CASE 
WHEN a.locality_error_added IS NULL THEN b.locality_error_added
ELSE a.locality_error_added
END, 
locality_error_details=
CASE 
WHEN a.locality_error_details IS NULL THEN b.locality_error_details
ELSE a.locality_error_details
END
FROM datasource_update b
WHERE a.source_name=b.source_name
AND a.proximate_provider_name=b.proximate_provider_name
; 

DROP TABLE IF EXISTS datasource_update;