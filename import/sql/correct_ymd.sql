-- --------------------------------------------------
-- Corrects dates stored as separate Y, M, D fields
-- --------------------------------------------------

-- --------------------------------------------------
-- NOTES:
-- Table and field names are parameters
-- All fields must already be valid integer data type
-- Bad/invalid date values are set to null
-- 
-- --------------------------------------------------

SET search_path TO :sch;

--
-- Check dates & set null any invalid values
--

-- Add indexes to speed performance
DROP INDEX IF EXISTS :"y_idx";
DROP INDEX IF EXISTS :"m_idx";
DROP INDEX IF EXISTS :"d_idx";
-- CREATE INDEX :"y_idx" ON :"tbl" (:"y_col");
-- CREATE INDEX :"m_idx" ON :"tbl" (:"m_col");
-- CREATE INDEX :"d_idx" ON :"tbl" (:"d_col");

-- Bad year
UPDATE :"tbl"
SET 
:"y_col"=
case
when :"y_col">(select extract(year from current_date)) or :"y_col"<1700 then null
else :"y_col"
end
;

-- Bad month
UPDATE :"tbl"
SET 
:"m_col"=
case
when :"m_col">12 or :"m_col"<1 then null
else :"m_col"
end
;

-- Bad day
UPDATE :"tbl"
SET 
:"d_col"=
case
when :"d_col">31 or :"d_col"<1 then null
else :"d_col"
end
;

UPDATE :"tbl"
SET 
:"d_col"=
case
when :"m_col" in (9,4,6,11) and :"d_col">30 then null
else :"d_col"
end
;

-- Fix any bad null combinations
UPDATE :"tbl"
SET :"m_col"=null 
WHERE :"y_col" is null
;
UPDATE :"tbl"
SET :"d_col"=null 
WHERE :"m_col" is null
;

-- Drop the indexes
DROP INDEX IF EXISTS :"y_idx";
DROP INDEX IF EXISTS :"m_idx";
DROP INDEX IF EXISTS :"d_idx";
