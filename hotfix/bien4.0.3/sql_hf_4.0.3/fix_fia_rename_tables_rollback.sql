-- --------------------------------------------------------------------
-- Manual rollback for step 6, just in case
-- --------------------------------------------------------------------

SET search_path TO analytical_db;

BEGIN;

ALTER TABLE view_full_occurrence_individual RENAME TO vfoi_dev;
ALTER TABLE view_full_occurrence_individual_bak_4_0_2 RENAME TO view_full_occurrence_individual;

ALTER TABLE analytical_stem RENAME TO astem_dev;
ALTER TABLE analytical_stem_bak_4_0_2 RENAME TO analytical_stem;

ALTER TABLE plot_metadata RENAME TO plot_metadata_dev;
ALTER TABLE plot_metadata_bak_4_0_2 RENAME TO plot_metadata;

COMMIT;