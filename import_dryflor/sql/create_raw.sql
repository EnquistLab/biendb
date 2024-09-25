-- 
-- Raw data table for this source
--

SET search_path TO :sch;

DROP TABLE IF EXISTS :"tbl_raw";
CREATE TABLE :"tbl_raw" (
taxon text,
taxon_verbatim text,
locality text,
country text,
latitude text,
longitude text,
altitude_m text,
vegetation text,
reference text,
specimen_details text,
unknown_fld_1 text,
unknown_fld_2 text
); 

