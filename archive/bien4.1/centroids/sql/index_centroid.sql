-- -------------------------------------------------------------
-- Index centroid results table
-- -------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS centroid_is_centroid_idx;
DROP INDEX IF EXISTS centroid_centroid_poldiv_idx;
DROP INDEX IF EXISTS centroid_centroid_type_idx;
DROP INDEX IF EXISTS centroid_tbl_tbl_id_uniq_idx;

CREATE INDEX centroid_is_centroid_idx ON centroid (is_centroid);
CREATE INDEX centroid_centroid_poldiv_idx ON centroid (centroid_poidiv);
CREATE INDEX centroid_centroid_type_idx ON centroid (centroid_type);
CREATE UNIQUE INDEX centroid_tbl_tbl_id_uniq_idx ON centroid (tbl,tbl_id);
