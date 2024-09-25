-- -------------------------------------------------------------
-- Drop temporary fk column fk_vfoi_staging_id
-- Not needed after insert complete. Also reduces hazard of this
-- column persisting across imports, which could result in 
-- erroneous values of taxonobservation_id being inserted into
-- table analytical_stem
-- -------------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE view_full_occurrence_individual_dev
DROP COLUMN IF EXISTS fk_vfoi_staging_id
;
