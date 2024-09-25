-- ---------------------------------------------------------
-- Populates temp table observ_10k
-- ---------------------------------------------------------

SET search_path TO :sch, postgis;

DROP TABLE IF EXISTS observations_union CASCADE;
CREATE TABLE observations_union (
gid BIGSERIAL NOT NULL,
species TEXT NOT NULL,
geom geometry DEFAULT NULL,
CONSTRAINT observations_union_enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
CONSTRAINT observations_union_enforce_srid_geom CHECK ((st_srid(geom) = 3857))
);

INSERT INTO observations_union (
species, geom
)
SELECT 
species, 
ST_Union(geom)
FROM observations_all
GROUP BY species
;

-- Remove underscores in species names, replacing with spaces
-- UPDATE observations_union SET species=REPLACE(species, '_', ' ');

ALTER TABLE "observations_union" ADD PRIMARY KEY (gid);
CREATE INDEX observations_union_gid_idx ON observations_union USING btree (gid);
CREATE INDEX observations_union_gist_idx ON observations_union USING gist (geom);
CREATE INDEX observations_union_species_idx ON observations_union USING btree (species);

DROP TABLE IF EXISTS observations_all;