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

-- Add indexes 
CREATE INDEX vfoi_dev_observation_type_idx ON view_full_occurrence_individual_dev (observation_type);
CREATE INDEX vfoi_dev_datasource_idx ON view_full_occurrence_individual_dev (datasource);

-- Update the original table by joining 1:1 to temp table
UPDATE view_full_occurrence_individual_dev 
SET
dataset=
CASE
WHEN observation_type='specimen' THEN custodial_institution_codes
WHEN observation_type='plot' AND (datasource='FIA' OR datasource='NVS') THEN datasource
ELSE NULL
END,
dataowner=
CASE
WHEN observation_type='specimen' THEN custodial_institution_codes
WHEN observation_type='plot' AND (datasource='FIA' OR datasource='NVS') THEN datasource
ELSE NULL
END,
plot_name=
CASE
WHEN observation_type='plot' THEN plot_name
ELSE NULL
END,
subplot=
CASE
WHEN observation_type='plot' THEN subplot
ELSE NULL
END
;

-- Commit & release share lock on original table
COMMIT;