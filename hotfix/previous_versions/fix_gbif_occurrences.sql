-- -----------------------------------------------------------------
-- Import 5-column GBIF extracts for updating occurrence_type
-- -----------------------------------------------------------------

SET search_path TO analytical_db_dev2;

--
-- Fossil file
-- 

DROP TABLE IF EXISTS gbif_fossils_raw;
CREATE TABLE gbif_fossils_raw (
"gbifID" text default null,
"institutionCode" text default null,
"basisOfRecord" text default null,
"countryCode" text default null,
"scientificName" text default null
);

\copy gbif_fossils_raw FROM '/home/boyle/bien3/data/gbif/gbif_plant_fossils_20180426.csv' CSV HEADER;

CREATE INDEX gbif_fossils_raw_gbifid_idx ON gbif_fossils_raw ("gbifID");
CREATE INDEX gbif_fossils_raw_basisofrecord_idx ON gbif_fossils_raw ("basisOfRecord");

--
-- All plants file
-- 

DROP TABLE IF EXISTS gbif_all_plants_raw;
CREATE TABLE gbif_all_plants_raw (
"gbifID" text default null,
"institutionCode" text default null,
"basisOfRecord" text default null,
"countryCode" text default null,
"scientificName" text default null
);

\copy gbif_all_plants_raw FROM '/home/boyle/bien3/data/gbif/gbif_all_plants_20180427.csv' CSV HEADER DELIMITER E'\t';

CREATE INDEX gbif_all_plants_raw_gbifid_idx ON gbif_all_plants_raw ("gbifID");
CREATE INDEX gbif_all_plants_raw_basisofrecord_idx ON gbif_all_plants_raw ("basisOfRecord");
