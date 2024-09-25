-- -------------------------------------------------------------
-- Create indexes on CODS results tables and main tables
-- -------------------------------------------------------------

SET search_path TO :sch;

--
-- Proximity results table
-- 
DROP INDEX IF EXISTS cods_proximity_user_id_idx;
CREATE INDEX cods_proximity_user_id_idx ON cods_proximity (user_id);

--
-- Keyword results table
-- 

-- Alter table, adding columns from joining table
ALTER TABLE cods_keyword
DROP COLUMN IF EXISTS tbl_name,
DROP COLUMN IF EXISTS tbl_id
;
ALTER TABLE cods_keyword
ADD COLUMN tbl_name text,
ADD COLUMN tbl_id bigint
;
-- Set user_id data type to integer
ALTER TABLE cods_keyword
ALTER COLUMN user_id SET DATA TYPE integer 
USING user_id::integer
;

-- Index the join fields
DROP INDEX IF EXISTS cods_keyword_user_id_idx;
CREATE INDEX cods_keyword_user_id_idx ON cods_keyword (user_id);

DROP INDEX IF EXISTS cods_desc_submitted_raw_id_idx;
CREATE INDEX cods_desc_submitted_raw_id_idx ON cods_desc_submitted_raw (id);

UPDATE cods_keyword a
SET 
tbl_name=b.tbl_name,
tbl_id=b.tbl_id
FROM cods_desc_submitted_raw b
WHERE a.user_id=b.id
;

DROP INDEX IF EXISTS cods_keyword_tbl_name_idx;
CREATE INDEX cods_keyword_tbl_name_idx ON cods_keyword (tbl_name);
DROP INDEX IF EXISTS cods_keyword_tbl_id_idx;
CREATE INDEX cods_keyword_tbl_id_idx ON cods_keyword (tbl_id);


