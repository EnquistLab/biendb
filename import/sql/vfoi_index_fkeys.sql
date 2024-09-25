-- -------------------------------------------------------------
-- After insert on vfoi, index fkey from vfoi to vfoi_staging,
-- populate fk vfoi_staging.taxonobservation_id and index it.
--
-- Requires parameters sch, src
-- -------------------------------------------------------------

SET search_path TO :sch;

-- Drop any other indexes
DROP INDEX IF EXISTS vfoi_staging_dataset_idx;
DROP INDEX IF EXISTS vfoi_staging_datasource_idx;
DROP INDEX IF EXISTS vfoi_staging_plot_name_idx;
DROP INDEX IF EXISTS vfoi_staging_verbatim_family_idx;

-- Create where and join indexes on vfoi 
DROP INDEX IF EXISTS vfoi_fk_vfoi_staging_id_idx;
CREATE INDEX vfoi_fk_vfoi_staging_id_idx ON view_full_occurrence_individual_dev (fk_vfoi_staging_id) WHERE fk_vfoi_staging_id IS NOT NULL;
DROP INDEX IF EXISTS vfoi_datasource_idx;
CREATE INDEX vfoi_datasource_idx ON view_full_occurrence_individual_dev (datasource);

UPDATE vfoi_staging a
SET taxonobservation_id=b.taxonobservation_id
FROM view_full_occurrence_individual_dev b
WHERE a.vfoi_staging_id=b.fk_vfoi_staging_id
AND b.datasource=:'src'
;

DROP INDEX IF EXISTS vfoi_staging_taxonobservation_id_idx;
CREATE INDEX vfoi_staging_taxonobservation_id_idx ON vfoi_staging (taxonobservation_id)
;