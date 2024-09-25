-- 
-- Custom changes to raw data table(s)
--

SET search_path TO :sch;

-- Add integer year, month and day columns for column eventdate
ALTER TABLE :tbl_raw
ADD COLUMN eventdate_yr integer,
ADD COLUMN eventdate_mo integer,
ADD COLUMN eventdate_dy integer
;

-- Add integer year, month and day columns for column dateidentified
ALTER TABLE :tbl_raw
ADD COLUMN dateidentified_yr integer,
ADD COLUMN dateidentified_mo integer,
ADD COLUMN dateidentified_dy integer
;

-- For fast creation of isnull partial indexes, where the values in the 
-- main column don't matter
ALTER TABLE :tbl_raw
ADD COLUMN dummycol integer default null
;

