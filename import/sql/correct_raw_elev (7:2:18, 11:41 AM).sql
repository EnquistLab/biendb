-- ------------------------------------------------------------
-- Make integer mean, min and max elevation columns
--
-- 
-- Parameters:
-- 	:sch - schema name
-- 	:"tbl" - table name
-- 	:"elev_col" - name of concatenated text elevation field
-- 	:elev_mean_col - numeric year column
-- 	:elev_max_col - numeric month column 
-- 	:elev_min_col - numeric day column 
-- 
-- Note: Recommend partial not-null index on elev_col. Will
--	dramatically improve performance if most records null for 
-- 	this column.
-- ------------------------------------------------------------

SET search_path TO :sch;

-- Add year, month and day columns
ALTER TABLE :"tbl"
ADD COLUMN :elev_mean_col numeric,
ADD COLUMN :elev_max_col numeric,
ADD COLUMN :elev_min_col numeric
;

-- Add not null index to speed performance
DROP INDEX IF EXISTS elev_text_not_null_idx;
CREATE INDEX elev_text_not_null_idx ON :"tbl" (:"elev_col") WHERE :"elev_col" IS NOT NULL;

-- Extract single elevation
UPDATE :tbl
SET :elev_mean_col=:"elev_col"::numeric
WHERE :"elev_col" IS NOT NULL AND public.is_numeric(:"elev_col")='t'
;

-- Extract single elevation followed by "m"
UPDATE :tbl
SET :elev_mean_col=trim(split_part(:"elev_col",'m',1))::numeric
WHERE :"elev_col" IS NOT NULL 
AND public.is_numeric( trim(split_part(:"elev_col",'m',1)) )
AND :elev_mean_col IS NULL
;

-- Extract elevation range
UPDATE :tbl
SET 
:elev_min_col=split_part(:"elev_col",'-',1)::numeric,
:elev_max_col=split_part(:"elev_col",'-',2)::numeric
WHERE :"elev_col" IS NOT NULL 
AND public.is_numeric(split_part(:"elev_col",'-',1))='t'
AND public.is_numeric(split_part(:"elev_col",'-',2))='t'
AND :elev_min_col IS NULL AND :elev_max_col IS NULL
;

-- Extract elevation range followed by m
UPDATE :tbl
SET 
:elev_min_col=split_part(trim(split_part(:"elev_col",'m',1)),'-',1)::numeric,
:elev_max_col=split_part(trim(split_part(:"elev_col",'m',1)),'-',2)::numeric
WHERE :"elev_col" IS NOT NULL 
AND public.is_numeric( split_part(trim(split_part(:"elev_col",'m',1)),'-',1) )='t'
AND public.is_numeric( split_part(trim(split_part(:"elev_col",'m',1)),'-',2) )='t'
AND :elev_min_col IS NULL AND :elev_max_col IS NULL
;

-- Calculate mean value of ranges
UPDATE :tbl
SET :elev_mean_col=(:elev_min_col + :elev_max_col) / 2
WHERE :"elev_col" IS NOT NULL 
AND :elev_min_col IS NOT NULL AND :elev_max_col IS NOT NULL
;

-- Swap min and max in case reversed
UPDATE :tbl
SET 
:elev_min_col=:elev_max_col,
:elev_max_col=:elev_min_col
WHERE :"elev_col" IS NOT NULL 
AND :elev_min_col > :elev_max_col
;