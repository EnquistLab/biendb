-- ----------------------------------------------------------------
-- Drop the temporary indexes
-- ----------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS vfoi_dev_dataset_plots_partial_no_country_idx;
