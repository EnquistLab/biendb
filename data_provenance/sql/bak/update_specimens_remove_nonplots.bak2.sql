-- ---------------------------------------------------------
-- Copies table vfoi, populating columns dataset and dataowner  
-- with the herbarium code if the observation is a specimen,  
-- otherwise leaves null. Columns plot_name and subplot are
-- populated only if observation_type='plot'. This removes  
-- the GBIF specimen records erroneously added as plots. 
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :dev_schema;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

--
-- Generate the first temp table, adding and populating the
-- new column in position desired. Be sure to copy ALL 
-- existing columns in source table!
-- 

CREATE TEMP TABLE tbl_temp AS 
SELECT * FROM view_full_occurrence_individual_dev;

-- Add indexes 
CREATE INDEX vfoi_taxonobservation_id_idx ON view_full_occurrence_individual_dev(taxonobservation_id);

CREATE INDEX tbl_temp_taxonobservation_id_idx ON tbl_temp(taxonobservation_id);
CREATE INDEX tbl_temp_observation_type_idx ON tbl_temp(observation_type);
CREATE INDEX tbl_temp_datasource_idx ON tbl_temp(datasource);

-- Analyze so query planner can use indexes
ANALYZE tbl_temp;

-- Update the original table by joining 1:1 to temp table
UPDATE view_full_occurrence_individual_dev a
SET
dataset=
CASE
WHEN b.observation_type='specimen' THEN b.custodial_institution_codes
WHEN b.observation_type='plot' AND (b.datasource='FIA' OR b.datasource='NVS') THEN b.datasource
ELSE NULL
END,
dataowner=
CASE
WHEN b.observation_type='specimen' THEN b.custodial_institution_codes
WHEN b.observation_type='plot' AND (b.datasource='FIA' OR b.datasource='NVS') THEN b.datasource
ELSE NULL
END,
plot_name=
CASE
WHEN b.observation_type='plot' THEN b.plot_name
ELSE NULL
END,
subplot=
CASE
WHEN b.observation_type='plot' THEN b.subplot
ELSE NULL
END
FROM tbl_temp b
WHERE a.taxonobservation_id=b.taxonobservation_id
;

-- Drop the temp table and indexes
DROP INDEX tbl_temp_taxonobservation_id_idx;
DROP INDEX tbl_temp_observation_type_idx;
DROP INDEX tbl_temp_datasource_idx;
DROP TABLE tbl_temp;

DROP INDEX vfoi_taxonobservation_id_idx;

-- Commit & release share lock on original table
COMMIT;