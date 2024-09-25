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
ADD COLUMN :elev_min_col numeric,
ADD COLUMN elev_verbatim_lc text default null
;

-- Make trimmed, lower case copy of verbatim elevation column
UPDATE :"tbl" 
SET elev_verbatim_lc=
CASE
WHEN TRIM(:"elev_col")='' THEN NULL
ELSE LOWER(TRIM(:"elev_col"))
END
WHERE :"elev_col" IS NOT NULL
;
-- Standardize 'ft.' to 'ft'
UPDATE :"tbl" 
SET elev_verbatim_lc=REPLACE( elev_verbatim_lc, 'ft.', 'ft' )
WHERE elev_verbatim_lc LIKE '%ft.%'
;

-- Add not null index to speed performance
-- Full index not needed as won't be used by 'LIKE'
-- Seems redundant, but greatly reduces number of rows that need to be
-- evaluated by more costly 'LIKE'
DROP INDEX IF EXISTS elev_verbatim_lc_not_null_idx;
CREATE INDEX elev_verbatim_lc_not_null_idx ON :"tbl" (elev_verbatim_lc) WHERE elev_verbatim_lc IS NOT NULL;

-- Extract valid numeric values as elevation
-- Assumes m so be sure to check
UPDATE :tbl
SET :elev_mean_col=elev_verbatim_lc::numeric
WHERE elev_verbatim_lc IS NOT NULL 
AND public.is_numeric(elev_verbatim_lc)='t'
;

-- Extract single elevation followed by "m"
UPDATE :tbl
SET :elev_mean_col=trim(split_part(elev_verbatim_lc,'m',1))::numeric
WHERE elev_verbatim_lc IS NOT NULL 
AND ( elev_verbatim_lc LIKE '% m' OR elev_verbatim_lc LIKE '% m %' )
AND public.is_numeric( trim(split_part(elev_verbatim_lc,'m',1)) )
AND :elev_mean_col IS NULL
;

-- Extract single elevation followed by "ft"
UPDATE :tbl
SET :elev_mean_col= 0.3048 * trim(split_part(elev_verbatim_lc,'ft',1))::numeric
WHERE elev_verbatim_lc IS NOT NULL 
AND ( elev_verbatim_lc LIKE '% ft%')
AND public.is_numeric( trim(split_part(elev_verbatim_lc,'ft',1)) )
AND :elev_mean_col IS NULL
;

-- Extract single elevation followed by "feet"
UPDATE :tbl
SET :elev_mean_col= 0.3048 * trim(split_part(elev_verbatim_lc,'feet',1))::numeric
WHERE ( elev_verbatim_lc LIKE '% feet%')
AND public.is_numeric( trim(split_part(elev_verbatim_lc,'feet',1)) )
AND :elev_mean_col IS NULL
;

-- Extract elevation range in meters
-- Assumes meters if no units specified
UPDATE :tbl
SET 
:elev_min_col=trim(split_part(elev_verbatim_lc,'-',1))::numeric,
:elev_max_col=trim(split_part(elev_verbatim_lc,'-',2))::numeric
WHERE elev_verbatim_lc IS NOT NULL 
AND elev_verbatim_lc NOT LIKE '%ft%' AND elev_verbatim_lc NOT LIKE '%feet%' 
AND public.is_numeric(trim(split_part(elev_verbatim_lc,'-',1)))='t'
AND public.is_numeric(trim(split_part(elev_verbatim_lc,'-',2)))='t'
AND :elev_min_col IS NULL AND :elev_max_col IS NULL
;

-- Extract elevation range explicitly in m
UPDATE :tbl
SET 
:elev_min_col = 0.3048 * split_part(trim(split_part(elev_verbatim_lc,'m',1)),'-',1)::numeric,
:elev_max_col = 0.3048 * split_part(trim(split_part(elev_verbatim_lc,'m',1)),'-',2)::numeric
WHERE elev_verbatim_lc IS NOT NULL 
AND elev_verbatim_lc NOT LIKE '%ft%' AND elev_verbatim_lc NOT LIKE '%feet%'
AND public.is_numeric( split_part(trim(split_part(elev_verbatim_lc,'m',1)),'-',1) )='t'
AND public.is_numeric( split_part(trim(split_part(elev_verbatim_lc,'m',1)),'-',2) )='t'
AND :elev_min_col IS NULL AND :elev_max_col IS NULL
;

-- Extract elevation range in feet and convert to m ('ft')
UPDATE :tbl
SET 
:elev_min_col = 0.3048 * split_part(trim(split_part(elev_verbatim_lc,'ft',1)),'-',1)::numeric,
:elev_max_col = 0.3048 * split_part(trim(split_part(elev_verbatim_lc,'m',1)),'-',2)::numeric
WHERE elev_verbatim_lc IS NOT NULL 
AND elev_verbatim_lc LIKE '%ft%' 
AND public.is_numeric( split_part(trim(split_part(elev_verbatim_lc,'ft',1)),'-',1) )='t'
AND public.is_numeric( split_part(trim(split_part(elev_verbatim_lc,'ft',1)),'-',2) )='t'
AND :elev_min_col IS NULL AND :elev_max_col IS NULL
;

-- Extract elevation range in feet and convert to m ('feet')
UPDATE :tbl
SET 
:elev_min_col = 0.3048 * split_part(trim(split_part(elev_verbatim_lc,'feet',1)),'-',1)::numeric,
:elev_max_col = 0.3048 * split_part(trim(split_part(elev_verbatim_lc,'feet',1)),'-',2)::numeric
WHERE elev_verbatim_lc IS NOT NULL 
AND elev_verbatim_lc LIKE '%feet%' 
AND public.is_numeric( split_part(trim(split_part(elev_verbatim_lc,'feet',1)),'-',1) )='t'
AND public.is_numeric( split_part(trim(split_part(elev_verbatim_lc,'feet',1)),'-',2) )='t'
AND :elev_min_col IS NULL AND :elev_max_col IS NULL
;

-- Calculate mean value of ranges
UPDATE :tbl
SET :elev_mean_col=(:elev_min_col + :elev_max_col) / 2
WHERE elev_verbatim_lc IS NOT NULL 
AND :elev_min_col IS NOT NULL AND :elev_max_col IS NOT NULL
;

-- Swap min and max if reversed
UPDATE :tbl
SET 
:elev_min_col=:elev_max_col,
:elev_max_col=:elev_min_col
WHERE elev_verbatim_lc IS NOT NULL 
AND :elev_min_col > :elev_max_col
;

-- Drop the temporary index
DROP INDEX IF EXISTS elev_verbatim_lc_not_null_idx;