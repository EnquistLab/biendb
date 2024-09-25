-- ---------------------------------------------------------
-- Adds geometry column to table
-- ---------------------------------------------------------

SET search_path TO :sch, postgis;

-- Geometry dimensions must be 2 (point)
SELECT AddGeometryColumn (:'sch', :'tbl', 'geom', :SRID,'POINT',2);
