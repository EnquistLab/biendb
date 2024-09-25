-- -------------------------------------------------------------------
-- Remove any temporary tables or sequences created by hotfix
-- -------------------------------------------------------------------

SET search_path TO :sch;

BEGIN;

-- Drop indexes, if any
ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS view_full_occurrence_individual_dev_pkey;
DROP INDEX IF EXISTS vfoi_dev_datasource_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_observation_type_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_dataset_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_plot_name_idx;

-- Drop temporary tables
DROP TABLE IF EXISTS fia_poldivs;
DROP TABLE IF EXISTS fia_plot_codes;

COMMIT;
