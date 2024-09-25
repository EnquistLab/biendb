-- -------------------------------------------------------------
-- Removes primary key default value and sequent from table vfoi 
-- -------------------------------------------------------------

SET search_path TO :sch;


ALTER TABLE view_full_occurrence_individual_dev ALTER COLUMN taxonobservation_id DROP DEFAULT;

DROP SEQUENCE IF EXISTS view_full_occurrence_individual_id_seq;
