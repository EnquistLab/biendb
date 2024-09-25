-- -------------------------------------------------------------
-- Appends to datasource from staging table
-- 
-- Includes all columns except the (auto-increment) primary
-- key datasource_id and recursive FK proximate_provider_id
-- -------------------------------------------------------------

SET search_path TO :sch;

-- Add temporary FK column
ALTER TABLE datasource
ADD COLUMN datasource_staging_id INTEGER DEFAULT NULL
;

-- 
-- Insert the new records
-- forward compatibility
-- 
INSERT INTO datasource (
source_name,
source_fullname,
source_type,
observation_type,
is_herbarium,
proximate_provider_name,
primary_contact_institution_name,
primary_contact_firstname,
primary_contact_lastname,
primary_contact_fullname,
primary_contact_email,
source_url,
source_citation,
access_conditions,
access_level,
locality_error_added,
locality_error_details,
datasource_staging_id
)
SELECT
source_name,
source_fullname,
source_type,
observation_type,
is_herbarium::integer,
proximate_provider_name,
primary_contact_institution_name,
primary_contact_firstname,
primary_contact_lastname,
primary_contact_fullname,
primary_contact_email,
source_url,
source_citation,
access_conditions,
access_level,
case
when locality_error_added='' or locality_error_added is null then 'f'
else locality_error_added::boolean
end,
locality_error_details,
datasource_staging_id
FROM datasource_staging
;

-- 
-- Update recursive FK proximate_provider_id by joining on 
-- text source_name. Would be better to use the temporary recusive
-- FK but keeping this method for backward-compatibility with sources
-- already coded
-- 

UPDATE datasource a
SET proximate_provider_datasource_id=b.datasource_id
FROM datasource b
WHERE a.proximate_provider_datasource_id IS NULL
AND a.proximate_provider_name=b.source_name 
;

-- 
-- Now transfer back the actual PK and recursive FK
-- 

-- Index the temporary join columns
DROP INDEX IF EXISTS datasource_datasource_staging_id_idx;
CREATE INDEX datasource_datasource_staging_id_idx ON datasource (datasource_staging_id)
;

UPDATE datasource_staging a
SET datasource_id=b.datasource_id
FROM datasource b
WHERE a.datasource_staging_id=b.datasource_staging_id
;

-- Drop the temporary columns
ALTER TABLE datasource DROP COLUMN datasource_staging_id;
