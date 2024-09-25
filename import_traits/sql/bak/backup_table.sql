--
-- Backup table src_tbl from src_schema to table target_tbl
-- in schema target_schema
--

SET search_path TO :target_schema;

DROP TABLE IF EXISTS :target_tbl;
CREATE TABLE :target_tbl AS
SELECT * FROM :src_schema.:src_tbl
;
