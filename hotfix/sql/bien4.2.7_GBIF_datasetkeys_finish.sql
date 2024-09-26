-- -----------------------------------------------------------
-- Optimize indexes and finish up
-- -----------------------------------------------------------

SET search_path TO :SCH;

ALTER TABLE :TBL
DROP COLUMN IF EXISTS updated
;

-- -- Optimize the table
-- vacuum analyze :TBL;

-- Remove test table if this is a test
DROP TABLE IF EXISTS vfoi_test;
