-- -------------------------------------------------------------
-- Add indexed column gbif_datasetkey' to table vfoi
-- -------------------------------------------------------------

set search_path to :sch;

--
-- Create the table and insert unique species + political divisions
--

ALTER TABLE view_full_occurrence_individual
ADD COLUMN gbif_datasetkey text default null
;

