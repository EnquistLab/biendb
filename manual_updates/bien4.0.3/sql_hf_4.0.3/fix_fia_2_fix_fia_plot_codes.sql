-- ----------------------------------------------------------------
-- Create development copy of vfoi with updated plot codes
-- Parameter :reclim is for testing only
-- ----------------------------------------------------------------

SET search_path TO :sch;

BEGIN;

DROP TABLE IF EXISTS vfoi_dev;
CREATE TABLE vfoi_dev ( LIKE view_full_occurrence_individual );
INSERT INTO vfoi_dev SELECT * FROM view_full_occurrence_individual
:reclim
;

ALTER TABLE vfoi_dev ADD PRIMARY KEY (taxonobservation_id);
CREATE INDEX vfoi_dev_datasource_idx ON vfoi_dev (datasource);

UPDATE vfoi_dev a
SET plot_name=b.plot_name_new
FROM fia_plot_codes b
WHERE a.datasource='FIA'
AND a.taxonobservation_id=b.taxonobservation_id
;

ALTER TABLE vfoi_dev DROP CONSTRAINT vfoi_dev_pkey;
DROP INDEX vfoi_dev_datasource_idx;

COMMIT;