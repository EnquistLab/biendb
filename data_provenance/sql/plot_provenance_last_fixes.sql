-- 
-- Final fixes to table plot_provenance
-- 

SET search_path TO :dev_schema;

-- Empty strings to null
UPDATE plot_provenance AS a
SET primary_dataowner=NULL,
primary_dataowner_email=NULL
WHERE primary_dataowner=''
;

-- bad emails
UPDATE plot_provenance
SET primary_dataowner_email=NULL
WHERE primary_dataowner_email NOT LIKE '%@%'
;

-- bad data owners (no last name)
UPDATE plot_provenance
SET primary_dataowner=NULL,
primary_dataowner_email=NULL
WHERE primary_dataowner NOT LIKE '% %'
;
