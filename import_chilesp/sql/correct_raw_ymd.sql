-- 
-- Make integer year, month, day columns
--

SET search_path TO :sch;

-- Add integer year, month and day columns
ALTER TABLE chilesp_raw
ADD COLUMN yr integer,
ADD COLUMN mo integer,
ADD COLUMN dy integer
;

-- Convert empty strings to null 
UPDATE chilesp_raw
SET 
yr=
CASE
WHEN TRIM("Year")='' THEN NULL
ELSE cast("Year" as integer)
END,
mo=
CASE
WHEN TRIM("Month")='' THEN NULL
ELSE cast("Month" as integer)
END,
dy=
CASE
WHEN TRIM("Day")='' THEN NULL
ELSE cast("Day" as integer)
END
;

