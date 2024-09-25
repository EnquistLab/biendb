
-- --------------------------------------------------------------
-- Insert raw datasource data to datasource staging table 
-- --------------------------------------------------------------

SET search_path TO :sch;

-- Note that FK column proximate_provider_datasource_id is omitted
-- This is added programmatically during loading to main table
INSERT INTO datasource_staging (
datasource_id,
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
locality_error_details
) 
SELECT *
FROM public.crosstab(
  'select 1 AS row_id, colname, row1_val
   from datasource_raw
')
AS datasource_raw(
row_id integer,
source_name text, 
source_fullname text, 
source_type text, 
observation_type text, 
is_herbarium text, 
proximate_provider_name text, 
primary_contact_institution_name text, 
primary_contact_firstname text, 
primary_contact_lastname text, 
primary_contact_fullname text, 
primary_contact_email text, 
source_url text, 
source_citation text, 
access_conditions text, 
access_level text, 
locality_error_added text, 
locality_error_details text
);

