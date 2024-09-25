-- --------------------------------------------------------------------
-- Move to production by renaming tables
-- 
-- Deactivates current production tables by adding "_bak" suffix. Moves
-- development tables to production by removing "_dev" suffix. Backup
-- tables should be deleted after a while if no issues found with new
-- tables.
-- 
-- Run this script manually for each database (private and public)
-- after validating dev tables. Increment database version immediately
-- after updating each database.
-- --------------------------------------------------------------------

SET search_path TO analytical_db;

BEGIN;

ALTER TABLE view_full_occurrence_individual RENAME TO view_full_occurrence_individual_bak_4_0_2;
ALTER TABLE vfoi_dev RENAME TO view_full_occurrence_individual;

ALTER TABLE analytical_stem RENAME TO analytical_stem_bak_4_0_2;
ALTER TABLE astem_dev RENAME TO analytical_stem;

ALTER TABLE plot_metadata RENAME TO plot_metadata_bak_4_0_2;
ALTER TABLE plot_metadata_dev RENAME TO plot_metadata;

COMMIT;