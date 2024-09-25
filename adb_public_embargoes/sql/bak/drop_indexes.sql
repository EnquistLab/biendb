-- --------------------------------------------------------------------
-- Create index-free copy of large tables from which records will be 
-- deleted. This step not needed for vfoi as indexes were already
-- stripped during taxon embargoes
-- --------------------------------------------------------------------

SET search_path TO :sch;

-- analytical_stem
BEGIN;

ALTER TABLE :sch.analytical_stem RENAME TO analytical_stem_temp;
CREATE TABLE :sch.analytical_stem (LIKE analytical_stem_temp);
INSERT INTO :sch.analytical_stem SELECT * FROM analytical_stem_temp;
DROP TABLE analytical_stem_temp;

COMMIT;

-- agg_traits
BEGIN;

ALTER TABLE :sch.agg_traits RENAME TO agg_traits_temp;
CREATE TABLE :sch.agg_traits (LIKE agg_traits_temp);
INSERT INTO :sch.agg_traits SELECT * FROM agg_traits_temp;
DROP TABLE agg_traits_temp;

COMMIT;

-- bien_taxonomy
BEGIN;

ALTER TABLE :sch.bien_taxonomy RENAME TO bien_taxonomy_temp;
CREATE TABLE :sch.bien_taxonomy (LIKE bien_taxonomy_temp);
INSERT INTO :sch.bien_taxonomy SELECT * FROM bien_taxonomy_temp;
DROP TABLE bien_taxonomy_temp;

COMMIT;

