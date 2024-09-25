-- --------------------------------------------------------------
-- Create indexes needed for validation and loading
-- --------------------------------------------------------------

SET search_path TO :sch;

-- PK. Not needed for insert, but add for back-checking original data
ALTER TABLE :"tbl_raw" ADD PRIMARY KEY ("gbifID"); 

DROP INDEX IF EXISTS gbif_raw_basisofrecord_idx;
CREATE INDEX gbif_raw_basisofrecord_idx ON :"tbl_raw" ("basisOfRecord");
DROP INDEX IF EXISTS gbif_raw_institutioncode_idx;
CREATE INDEX gbif_raw_institutioncode_idx ON :"tbl_raw" ("institutionCode");

DROP INDEX IF EXISTS gbif_raw_locality_idx;
CREATE INDEX gbif_raw_locality_idx ON :"tbl_raw" ("locality");
DROP INDEX IF EXISTS gbif_raw_verbatimlocality_idx;
CREATE INDEX gbif_raw_verbatimlocality_idx ON :"tbl_raw" ("verbatimLocality");

DROP INDEX IF EXISTS gbif_raw_eventdate_isnotnull_idx;
CREATE INDEX gbif_raw_eventdate_isnotnull_idx ON :"tbl_raw" ("eventDate") 
WHERE "eventDate" IS NOT NULL;
DROP INDEX IF EXISTS gbif_raw_eventdate_yr_isnotnull_idx;
CREATE INDEX gbif_raw_eventdate_yr_isnotnull_idx ON :"tbl_raw" ("eventdate_yr") 
WHERE "eventdate_yr" IS NOT NULL;
DROP INDEX IF EXISTS gbif_raw_eventdate_mo_isnotnull_idx;
CREATE INDEX gbif_raw_eventdate_mo_isnotnull_idx ON :"tbl_raw" ("eventdate_mo")
WHERE "eventdate_mo" IS NOT NULL;
DROP INDEX IF EXISTS gbif_raw_eventdate_dy_isnotnull_idx;
CREATE INDEX gbif_raw_eventdate_dy_isnotnull_idx ON :"tbl_raw" ("eventdate_dy")
WHERE "eventdate_dy" IS NOT NULL;

DROP INDEX IF EXISTS gbif_raw_dateidentified_isnotnull_idx;
CREATE INDEX gbif_raw_dateidentified_isnotnull_idx ON :"tbl_raw" ("dateIdentified") 
WHERE "dateIdentified" IS NOT NULL;
DROP INDEX IF EXISTS gbif_raw_dateidentified_yr_isnotnull_idx;
CREATE INDEX gbif_raw_dateidentified_yr_isnotnull_idx ON :"tbl_raw" ("dateidentified_yr") 
WHERE "dateidentified_yr" IS NOT NULL;
DROP INDEX IF EXISTS gbif_raw_dateidentified_mo_isnotnull_idx;
CREATE INDEX gbif_raw_dateidentified_mo_isnotnull_idx ON :"tbl_raw" ("dateidentified_mo") 
WHERE "dateidentified_mo" IS NOT NULL;
DROP INDEX IF EXISTS gbif_raw_dateidentified_dy_isnotnull_idx;
CREATE INDEX gbif_raw_dateidentified_dy_isnotnull_idx ON :"tbl_raw" ("dateidentified_dy") 
WHERE "dateidentified_dy" IS NOT NULL;

DROP INDEX IF EXISTS gbif_raw_identificationqualifier_isnotnull_idx;
CREATE INDEX gbif_raw_identificationqualifier_isnotnull_idx ON :"tbl_raw" ("identificationQualifier") 
WHERE "identificationQualifier" IS NOT NULL;
DROP INDEX IF EXISTS gbif_raw_establishmentmeans_isnotnull_idx;
CREATE INDEX gbif_raw_establishmentmeans_isnotnull_idx ON :"tbl_raw" ("establishmentMeans") 
WHERE "establishmentMeans" IS NOT NULL;
