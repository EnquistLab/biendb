-- --------------------------------------------------------
-- Add not null partial index on column geom
-- A one-time thing; this index now added to pipeline
-- --------------------------------------------------------

SET search_path TO :sch, postgis;

DROP INDEX IF EXISTS vfoi_geom_not_null_idx;
CREATE INDEX vfoi_geom_not_null_idx ON
view_full_occurrence_individual(is_geovalid)
WHERE geom IS NOT NULL;