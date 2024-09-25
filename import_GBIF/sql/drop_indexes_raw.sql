-- --------------------------------------------------------------
-- Drop temporary indexes used for validation and loading
-- --------------------------------------------------------------

SET search_path TO :sch;

-- DROP INDEX IF EXISTS gbif_raw_basisofrecord_idx;  -- keep for now
-- DROP INDEX IF EXISTS gbif_raw_institutioncode_idx;  -- keep for now
DROP INDEX IF EXISTS gbif_raw_locality_idx;
DROP INDEX IF EXISTS gbif_raw_verbatimlocality_idx;
DROP INDEX IF EXISTS gbif_raw_eventdate_isnotnull_idx;
DROP INDEX IF EXISTS gbif_raw_eventdate_yr_isnotnull_idx;
DROP INDEX IF EXISTS gbif_raw_eventdate_mo_isnotnull_idx;
DROP INDEX IF EXISTS gbif_raw_eventdate_dy_isnotnull_idx;
DROP INDEX IF EXISTS gbif_raw_dateidentified_isnotnull_idx;
DROP INDEX IF EXISTS gbif_raw_dateidentified_yr_isnotnull_idx;
DROP INDEX IF EXISTS gbif_raw_dateidentified_mo_isnotnull_idx;
DROP INDEX IF EXISTS gbif_raw_dateidentified_dy_isnotnull_idx;
DROP INDEX IF EXISTS gbif_raw_identificationqualifier_isnotnull_idx;
DROP INDEX IF EXISTS gbif_raw_establishmentmeans_isnotnull_idx;