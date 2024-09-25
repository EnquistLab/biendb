-- -------------------------------------------------------------
-- Enables primary key for table vfoi 
-- Also add temporary fk to staging table
-- -------------------------------------------------------------

SET search_path TO :sch;

--
-- drop default and sequence in case they already exist
--

ALTER TABLE view_full_occurrence_individual_dev ALTER COLUMN taxonobservation_id DROP DEFAULT;

DROP SEQUENCE IF EXISTS view_full_occurrence_individual_id_seq;

--
-- create the sequence, change the datatype and bind it to the sequence
--
  
DROP SEQUENCE IF EXISTS view_full_occurrence_individual_id_seq;
CREATE SEQUENCE view_full_occurrence_individual_id_seq;

ALTER TABLE view_full_occurrence_individual_dev
ALTER COLUMN taxonobservation_id TYPE BIGINT USING taxonobservation_id::BIGINT, 
ALTER COLUMN taxonobservation_id SET NOT NULL, 
ALTER COLUMN taxonobservation_id SET DEFAULT nextval('view_full_occurrence_individual_id_seq')
;

ALTER SEQUENCE view_full_occurrence_individual_id_seq
OWNED BY view_full_occurrence_individual_dev.taxonobservation_id
;

--
-- reset the sequence to contain the maximum occuring player_id in the table
--
SELECT setval('view_full_occurrence_individual_id_seq', max_id.max_id)
FROM (SELECT MAX(taxonobservation_id) AS max_id FROM view_full_occurrence_individual_dev) max_id
;

--
-- Add FK for linking to staging table
-- Needed for loading stem data to analytical_stem
-- 
ALTER TABLE view_full_occurrence_individual_dev
ADD COLUMN fk_vfoi_staging_id bigint default null
;
