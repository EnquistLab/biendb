-- 
-- Creates general raw data tables
--

SET search_path TO :sch;

-- Raw metadata in vertical format
-- First column is column names, second column
-- is values in row 1
-- Only one row of values as this is single source
DROP TABLE IF EXISTS datasource_raw;
CREATE TABLE datasource_raw (
colname text,
row1_val text
);

