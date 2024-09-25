-- 
-- Create table bien_summary
--

SET search_path TO :sch;

DROP TABLE IF EXISTS chilesp_raw;
CREATE TABLE chilesp_raw (
"language" text,
"catalogNumber" text,
"Kingdom" text,
"Phyllum" text,
"Class" text,
"Order" text,
"Family" text,
"Genus" text,
"scientificName" text,
"organismName" text,
"establishmentMeans" text,
"individualCount" text,
"recordedBy" text,
"Year" text,
"Month" text,
"Day" text,
"higherGeography" text,
"locality" text,
"stateProvince" text,
"county" text,
"municipality" text,
"verbatimElevation" text,
"geodeticDatum" text,
"decimalLongitude" text,
"decimalLatitude" text,
"associatedReferences" text,
"datasetName" text
); 

