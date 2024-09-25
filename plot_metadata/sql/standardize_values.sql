-- 
--  Standardize vocabulary of constrained columns
--

SET search_path TO :dev_schema;

UPDATE plot_metadata
SET abundance_measurement=TRIM(abundance_measurement)
WHERE abundance_measurement IS NOT NULL
;

UPDATE plot_metadata
SET abundance_measurement=NULL
WHERE abundance_measurement=''
;

UPDATE plot_metadata
SET abundance_measurement='cover and individuals'
WHERE abundance_measurement='cover individuals'
;