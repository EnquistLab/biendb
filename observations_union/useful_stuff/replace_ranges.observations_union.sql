-- -----------------------------------------------------------------
-- Create table version of view observations_union in schema ranges
-- Do this prior to rebuilding table 
-- analytical_db.observations_union, in case operation fails.
-- Websites biendata.org and biendatadev.xyz both depend on view
-- ranges.observations_union. Changing it to a table prevents 
-- cascade deletion on delete of analytical_db.observations_union.
-- -----------------------------------------------------------------

\c vegbien
set search_path to ranges, postgis;

-- Create the table
DROP VIEW observations_union;

-- !! STOP HERE IF COMMAND FAILS BECAUSE observations_union IS A TABLE!!
-- !! DON'T NEED TO REPLACE, JUST REFRESH AFTER THE NEW 
-- analytical_db.observations_union is read

CREATE TABLE observations_union (LIKE analytical_db.observations_union);
INSERT INTO observations_union SELECT * FROM analytical_db.observations_union;

-- Add constraints and indexes
-- Note: adding "INCLUDING ALL" to the view doesn't recreate the indexes
-- of the original table in schema analytical_db
ALTER TABLE observations_union
ADD CONSTRAINT observations_union_pkey
PRIMARY KEY (gid)
;
ALTER TABLE observations_union
ADD CONSTRAINT observations_union_enforce_dims_geom 
CHECK ((st_ndims(geom) = 2))
;
ALTER TABLE observations_union
ADD CONSTRAINT observations_union_enforce_srid_geom 
CHECK ((st_srid(geom) = 3857))
;
CREATE INDEX observations_union_gist_idx ON observations_union USING gist (geom);
CREATE INDEX observations_union_species_idx ON observations_union USING btree (species);
CREATE INDEX observations_union_species_std_idx ON observations_union USING btree (species_std);

-- Update permissions
GRANT SELECT ON ALL TABLES IN SCHEMA ranges TO biendata_private;
ALTER DEFAULT PRIVILEGES IN SCHEMA ranges GRANT SELECT ON TABLES TO biendata_private;

