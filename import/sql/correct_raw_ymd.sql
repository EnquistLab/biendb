-- ------------------------------------------------------------
-- Make integer year, month, day columns
--
-- 
-- Parameters:
-- 	:sch - schema name
-- 	:"tbl" - table name
-- 	:"col_date" - name of concatenated date field to be split
-- 	:y_col - integer year column
-- 	:m_col - integer month column 
-- 	:d_col - integer day column 
--
-- Warning: 
-- 	Date MUST be of format yyyy-mm-dd or dd-mm-yyyy
--	Month can be numeric or spelled out
-- 
-- Note: 
-- 	Recommend partial not-null index on col_date. Will
--	dramatically improve performance if most records null for 
-- 	this column.
-- ------------------------------------------------------------

SET search_path TO :sch;

-- Add year, month and day columns
ALTER TABLE :"tbl"
ADD COLUMN :y_col integer,
ADD COLUMN :m_col text,
ADD COLUMN :d_col integer
;

-- Split the dates, converting yr & day into integer immediately
UPDATE :"tbl"
SET 
:y_col=
CASE
WHEN split_part(:"col_date",'-',1)~E'^\\d+$' THEN split_part(:"col_date",'-',1)::integer
ELSE NULL
END,
:m_col=split_part(:"col_date",'-',2),
:d_col=
CASE
WHEN split_part(:"col_date",'-',3)~E'^\\d+$' THEN split_part(:"col_date",'-',3)::integer
ELSE NULL
END
WHERE :"col_date" is not null 
;

-- Convert month to integer, else null
UPDATE :"tbl"
SET :m_col=
CASE
WHEN :m_col~E'^\\d+$' THEN :m_col
WHEN :m_col ILIKE 'Jan%' THEN '1'
WHEN :m_col ILIKE 'Feb%' THEN '2'
WHEN :m_col ILIKE 'Mar%' THEN '3'
WHEN :m_col ILIKE 'Apr%' THEN '4'
WHEN :m_col ILIKE 'May%' THEN '5'
WHEN :m_col ILIKE 'Jun%' THEN '6'
WHEN :m_col ILIKE 'Jul%' THEN '7'
WHEN :m_col ILIKE 'Aug%' THEN '8'
WHEN :m_col ILIKE 'Sep%' THEN '9'
WHEN :m_col ILIKE 'Oct%' THEN '10'
WHEN :m_col ILIKE 'Nov%' THEN '11'
WHEN :m_col ILIKE 'Dec%' THEN '12'
ELSE null
END
WHERE :"col_date" is not null 
;

-- Now convert month to integer as well
ALTER TABLE :"tbl" 
ALTER COLUMN :m_col TYPE integer USING :m_col::integer;

-- Check valid year
-- If can't be resolved then set to null
UPDATE :"tbl"
SET :y_col=
CASE
WHEN :y_col>2017 THEN null
WHEN :y_col<1800 THEN 
CASE 
WHEN :y_col<=31 AND :y_col>=1 THEN
CASE
WHEN :d_col>=1800 AND :d_col<=2017 THEN :y_col
ELSE NULL
END 
ELSE null
END
ELSE :y_col
END
WHERE :"col_date" is not null 
; 

-- Swap day and year if applicable
UPDATE :"tbl"
SET 
:y_col=:d_col,
:d_col=:y_col
WHERE :"col_date" is not null 
AND :d_col>=1800 AND :d_col<=2017
;

-- Remove mo and dy if yr is bad
UPDATE :"tbl"
SET :m_col=null,
:d_col=null
WHERE :"col_date" is not null 
AND :y_col is null
;

-- Swap day and month if applicable
UPDATE :"tbl"
SET 
:m_col=:d_col,
:d_col=:m_col
WHERE :"col_date" is not null 
AND (
(:d_col IN (1,3,5,7,8,10,12) AND :m_col>12 AND :m_col<=31)
OR
(:d_col IN (2,4,6,9,11) AND :m_col>12 AND :m_col<=30)
)
;

-- Remove dy & mo if mo is bad
UPDATE :"tbl"
SET 
:d_col=null,
:m_col=null
WHERE :"col_date" is not null 
AND (
:m_col is null OR :m_col NOT IN (1,2,3,4,5,6,7,8,9,10,11,12)
)
;

-- Check valid day
UPDATE :"tbl"
SET :d_col=
CASE
WHEN :d_col>31 OR :d_col<1 THEN null
WHEN :d_col=31 THEN 
CASE 
WHEN :m_col IN (1,3,5,7,8,10,12) THEN :d_col
END
ELSE :d_col
END
WHERE :"col_date" is not null 
; 