-- ---------------------------------------------------------
-- Drop spatial constraints
-- ---------------------------------------------------------

SET search_path TO :sch, postgis;

ALTER TABLE :tbl DROP CONSTRAINT IF EXISTS enforce_dimensions_geom;
ALTER TABLE :tbl DROP CONSTRAINT IF EXISTS enforce_geometrytype_geom;
ALTER TABLE :tbl DROP CONSTRAINT IF EXISTS enforce_srid_geom;
