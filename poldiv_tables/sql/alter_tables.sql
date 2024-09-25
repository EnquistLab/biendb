-- --------------------------------------------------------
-- Alters political division tables, removing unnecessary  
-- and/or confusibngcolumns
-- --------------------------------------------------------

SET search_path TO :sch;

-- 
-- Drop columns
-- 

ALTER TABLE country_name DROP COLUMN is_preferred_name_en, DROP COLUMN is_official_name, DROP COLUMN is_official_name_ascii;

ALTER TABLE state_province_name DROP COLUMN is_preferred_name_en, DROP COLUMN is_official_name, DROP COLUMN is_official_name_ascii;

ALTER TABLE county_parish_name DROP COLUMN is_preferred_name_en, DROP COLUMN is_official_name, DROP COLUMN is_official_name_ascii;


-- 
--  Drop sequences
-- 

ALTER TABLE country_name ALTER COLUMN country_name_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS country_name_country_name_id_seq;

ALTER TABLE county_parish_name ALTER COLUMN county_parish_name_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS county_parish_name_county_parish_name_id_seq;

ALTER TABLE state_province_name ALTER COLUMN state_province_name_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS state_province_name_state_province_name_id_seq;

