-- -------------------------------------------------------------------
-- Remove any temporary tables or sequences created by hotfix
-- -------------------------------------------------------------------

SET search_path TO analytical_db;

BEGIN;

DROP TABLE IF EXISTS fia_poldivs;
DROP TABLE IF EXISTS fia_plot_codes;

ALTER TABLE plot_metadata ALTER COLUMN plot_metadata_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS plot_metadata_dev_plot_metadata_id_seq;

COMMIT;
