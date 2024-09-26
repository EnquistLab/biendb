-- --------------------------------------------------------------------
-- Update plot codes and FK plot_metadata_id in analytical_stem
-- --------------------------------------------------------------------

SET search_path TO :sch;

BEGIN;

-- 
-- Create development copy table without indexes
-- 

-- Parameter :reclim for testing only
DROP TABLE IF EXISTS astem_dev;
CREATE TABLE astem_dev ( LIKE analytical_stem );
INSERT INTO astem_dev SELECT * FROM analytical_stem
:reclim
;

-- 
-- Add indexes needed for update
-- 

DROP INDEX IF EXISTS astem_dev_taxonobservation_id_idx;
CREATE INDEX astem_dev_taxonobservation_id_idx ON astem_dev (taxonobservation_id);
DROP INDEX IF EXISTS astem_dev_datasource_idx;
CREATE INDEX astem_dev_datasource_idx ON astem_dev (datasource);
ALTER TABLE vfoi_dev DROP CONSTRAINT IF EXISTS vfoi_dev_pkey;
ALTER TABLE vfoi_dev ADD PRIMARY KEY (taxonobservation_id);

-- 
-- Execute the update by joining to vfoi_dev
-- 

UPDATE astem_dev a
SET 
plot_metadata_id=b.plot_metadata_id,
plot_name=b.plot_name
FROM vfoi_dev b
WHERE a.taxonobservation_id=b.taxonobservation_id
AND a.datasource='FIA'
;

-- 
-- Drop temporary indexes
-- 

DROP INDEX IF EXISTS astem_dev_taxonobservation_id_idx;
DROP INDEX IF EXISTS astem_dev_datasource_idx;
ALTER TABLE vfoi_dev DROP CONSTRAINT vfoi_dev_pkey;

COMMIT;
