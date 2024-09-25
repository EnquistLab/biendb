-- -------------------------------------------------------------
-- Add candidate fk for table cods_prox_submitted to tables
-- vfoi and agg_traits
--
-- Clear ALL indexes and pks before running!
-- -------------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE view_full_occurrence_individual_dev
DROP COLUMN IF EXISTS latlong_text;
ALTER TABLE view_full_occurrence_individual_dev
ADD COLUMN latlong_text text DEFAULT NULL;

UPDATE view_full_occurrence_individual_dev
SET latlong_text=CONCAT_WS('@',
latitude::text,
longitude::text
)
WHERE is_geovalid=1
;

ALTER TABLE agg_traits
DROP COLUMN IF EXISTS latlong_text;
ALTER TABLE agg_traits
ADD COLUMN latlong_text text DEFAULT NULL;

UPDATE agg_traits
SET latlong_text=CONCAT_WS('@',
latitude::text,
longitude::text
)
WHERE is_geovalid=1
;