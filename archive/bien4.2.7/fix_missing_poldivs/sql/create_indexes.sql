-- ----------------------------------------------------------------
-- Add temporary partial index 
-- ----------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS vfoi_dev_dataset_plots_partial_no_country_idx;
CREATE INDEX vfoi_dev_dataset_plots_partial_no_country_idx ON view_full_occurrence_individual_dev (dataset) 
WHERE datasource IN ('CVS','Madidi','NVS','TEAM')
AND country_verbatim IS NULL OR TRIM(country_verbatim)=''
;