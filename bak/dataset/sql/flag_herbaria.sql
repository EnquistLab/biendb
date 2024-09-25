-- 
-- Flag datasource which as also herbaria
--

SET search_path TO :dev_schema;

CREATE INDEX ON datasource (is_herbarium);

UPDATE datasource AS a
SET is_herbarium=1,
source_fullname=
COALESCE("*NamOrganisation", '') || ',' || COALESCE(b."*NamSection",''),
primary_contact_institution_name=
COALESCE("*NamOrganisation", '') || ',' || COALESCE(b."*NamSection",''),
primary_contact_fullname=
COALESCE("*NamOrganisation", '') || ',' || COALESCE(b."*NamSection",''),
source_url=b."*AddWeb"
FROM ih AS b
WHERE a.source_name=b.specimen_duplicate_institutions
AND a.observation_type='specimen'
;

UPDATE datasource
SET source_fullname = 
substring(source_fullname from 1 for char_length(source_fullname)-1 )
WHERE 
substring(source_fullname from char_length(source_fullname) for 1 ) = ',';

UPDATE datasource
SET primary_contact_institution_name = 
substring(primary_contact_institution_name from 1 for char_length(primary_contact_institution_name)-1 )
WHERE 
substring(primary_contact_institution_name from char_length(primary_contact_institution_name) for 1 ) = ',';

UPDATE datasource
SET primary_contact_fullname = 
substring(primary_contact_fullname from 1 for char_length(primary_contact_fullname)-1 )
WHERE 
substring(primary_contact_fullname from char_length(primary_contact_fullname) for 1 ) = ',';