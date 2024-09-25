-- ----------------------------------------------------------------
-- Index the newly populated column and optimize the database
-- ----------------------------------------------------------------

set search_path to :sch

DROP INDEX IF EXISTS vfoi_gbif_datasetkey_idx;
CREATE INDEX vfoi_gbif_datasetkey_idx 
ON view_full_occurrence_individual (gbif_datasetkey)
;

VACUUM ANALYZE view_full_occurrence_individual;


