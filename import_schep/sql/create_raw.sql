-- 
-- Raw data table for this source
--

SET search_path TO :sch;

DROP TABLE IF EXISTS "schep_plotdb_raw";
CREATE TABLE "schep_plotdb_raw" (
"species" text,
"plot_ID" text,
"Country" text,
"Latitude" text,
"Longitude" text,
"ALT_m" text,
"Year" text,
"RowPlotDB" integer
);

DROP TABLE IF EXISTS "schep_tree_db_raw";
CREATE TABLE "schep_tree_db_raw" (
"species" text,
"Country" text,
"Location" text,
"Latitude" text,
"Longitude" text,
"ALT_m" text,
"plot_ID" text
);


