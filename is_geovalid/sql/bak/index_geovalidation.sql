-- -------------------------------------------------------------
-- Index geovalidation results table
-- -------------------------------------------------------------

SET search_path TO :sch;


-- May need to deactivate the following until solve repeat problem
-- CREATE UNIQUE INDEX geovalidation_tbl_id_idx ON geovalidation (tbl,id);
CREATE INDEX geovalidation_tbl_idx ON geovalidation (tbl);
CREATE INDEX geovalidation_id_idx ON geovalidation (id);