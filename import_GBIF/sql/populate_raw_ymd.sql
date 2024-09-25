-- -----------------------------------------------------------------------
-- Make integer year, month, day columns
-- 
-- Note that in this case I am accepting GBIF's conversions as-is
-- Assume y, m, and d values are valid integers, will fail if not
-- -----------------------------------------------------------------------

SET search_path TO :sch;

-- eventDate: type cast
UPDATE :tbl_raw
SET 
eventdate_yr="year"::integer,
eventdate_mo="month"::integer,
eventdate_dy="day"::integer
;

-- dateIdentified: parse, convert nulls & type cast 
UPDATE :tbl_raw
SET 
dateidentified_yr=
CASE
WHEN TRIM("dateIdentified")='' THEN NULL
ELSE CAST(split_part("dateIdentified",'-',1) as integer)
END,
dateidentified_mo=
CASE
WHEN TRIM("dateIdentified")='' THEN NULL
ELSE CAST(split_part("dateIdentified",'-',2) as integer)
END,
dateidentified_dy=
CASE
WHEN TRIM("dateIdentified")='' THEN NULL
ELSE CAST(LEFT(split_part("dateIdentified",'-',3),2) as integer)
END
;
