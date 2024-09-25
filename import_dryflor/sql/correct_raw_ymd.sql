-- NOT USED FOR THIS SOURCE
-- Make integer year, month, day columns
--

SET search_path TO :sch;

-- Add integer year, month and day columns
ALTER TABLE :"tbl"
ADD COLUMN col_yr integer,
ADD COLUMN col_mo integer,
ADD COLUMN col_dy integer,
ADD COLUMN det_yr integer,
ADD COLUMN det_mo integer,
ADD COLUMN det_dy integer
;

-- Convert non-integers to null
UPDATE :"tbl"
SET 
col_yr=
CASE 
WHEN "YearCollected"~E'^\\d+$' THEN "YearCollected"::integer 
ELSE null 
END,
col_mo=
CASE
WHEN "MonthCollected"~E'^\\d+$' THEN "MonthCollected"::integer 
ELSE null 
END,
col_dy=
CASE
WHEN "DayCollected"~E'^\\d+$' THEN "DayCollected"::integer 
ELSE null 
END,
det_yr=
CASE
WHEN "YearIdentified"~E'^\\d+$' THEN "YearIdentified"::integer 
ELSE null 
END,
det_mo=
CASE
WHEN "MonthIdentified"~E'^\\d+$' THEN "MonthIdentified"::integer 
ELSE null 
END,
det_dy=
CASE
WHEN TRIM("DayIdentified")='' THEN NULL
WHEN "DayIdentified"~E'^\\d+$' THEN "DayIdentified"::integer 
ELSE null 
END
;
