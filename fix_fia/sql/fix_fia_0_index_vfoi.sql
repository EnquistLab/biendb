-- ----------------------------------------------------------------
-- Add temporary indexes to vfoi
-- Copying the tables purges all existing indexes
-- ----------------------------------------------------------------

SET search_path TO :sch;

BEGIN;

-- Purge existing indexes
ALTER TABLE view_full_occurrence_individual_dev 
RENAME TO view_full_occurrence_individual_temp
;
CREATE TABLE view_full_occurrence_individual_dev ( LIKE view_full_occurrence_individual_temp )
;
INSERT INTO view_full_occurrence_individual_dev SELECT * FROM view_full_occurrence_individual_temp
;
DROP TABLE view_full_occurrence_individual_temp
;

-- Add just the temporary indexes needed
ALTER TABLE view_full_occurrence_individual_dev ADD PRIMARY KEY (taxonobservation_id);
CREATE INDEX vfoi_dev_datasource_idx ON view_full_occurrence_individual_dev (datasource);

COMMIT;