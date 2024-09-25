-- 
-- Corrections best done to raw data
--

SET search_path TO :sch;

-- Convert empty strings to null for selected fields
UPDATE chilesp_raw
SET 
"municipality"=
CASE
WHEN TRIM("municipality")='' THEN NULL
ELSE "municipality"
END,
"locality"=
CASE
WHEN TRIM("locality")='' THEN NULL
ELSE "locality"
END,
"higherGeography"=
CASE
WHEN TRIM("higherGeography")='' THEN NULL
ELSE "higherGeography"
END
;

