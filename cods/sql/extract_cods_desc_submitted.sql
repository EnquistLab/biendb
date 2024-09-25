-- ---------------------------------------------------------
-- Extract CODS description data 
-- ---------------------------------------------------------

SET search_path TO :sch;

INSERT INTO cods_desc_submitted_raw (
tbl_name,
tbl_id,
description
)
SELECT 
'view_full_occurrence_individual',
taxonobservation_id::bigint,
trim(concat_ws(' ', 
locality, occurrence_remarks, vegetation_verbatim
))
FROM view_full_occurrence_individual_dev
WHERE locality IS NOT NULL
OR occurrence_remarks IS NOT NULL
OR vegetation_verbatim IS NOT NULL
;

INSERT INTO cods_desc_submitted_raw (
tbl_name,
tbl_id,
description
)
SELECT 
'agg_traits',
id::bigint,
locality_description
FROM agg_traits
WHERE locality_description IS NOT NULL
;

DELETE FROM cods_desc_submitted_raw
WHERE TRIM(description)=''
;

INSERT INTO cods_desc_submitted (
id,
description
)
SELECT
id,
description
FROM cods_desc_submitted_raw
;
