-- 
-- Corrections best done to raw data
--

SET search_path TO :sch;


-- Add empty columns so both plots have identical schemas
ALTER TABLE schep_plotdb_raw
ADD COLUMN "Location" text default NULL
;
ALTER TABLE schep_tree_db_raw
ADD COLUMN "Year" text default NULL,
ADD COLUMN "RowPlotDB" text default NULL
;


-- Fixing bad elevational ranges
UPDATE schep_plotdb_raw
SET "ALT_m"='455-1495'
WHERE "ALT_m" LIKE '%1495%'
;