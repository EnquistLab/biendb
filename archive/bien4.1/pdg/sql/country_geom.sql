-- 
-- Creates geometry/spatial table of countries, states and counties
-- Each political division is represented by a single polygon only
-- Speed up queries
--
-- 

-- note addition of spatial schema to search_path
SET search_path TO :sch, postgis;

DROP TABLE IF EXISTS country_geom;
CREATE TABLE country_geom (
gid serial NOT NULL, 
country text default null,
state_province text default null,
county text default null,
rank varchar(15) default null,
geom geometry, 
CONSTRAINT country_geom_pkey PRIMARY KEY (gid), 
CONSTRAINT enforce_dims_geom CHECK (st_ndims(geom) = 2), 
CONSTRAINT enforce_geotype_geom CHECK ((geometrytype(geom) = ANY (ARRAY['MULTIPOLYGON'::text, 'POLYGON'::text])) OR geom IS NULL), 
CONSTRAINT enforce_srid_geom CHECK (st_srid(geom) = 4326) )
;

-- Insert country polygons
CREATE TABLE country_geom AS
INSERT INTO country_geom (
country,
geom,
rank
)
SELECT 
country, 
ST_Union(ST_SnapToGrid(geom,0.000001)),
'country'
FROM world_geom
WHERE country IS NOT NULL
GROUP BY country
ORDER BY country
;

-- Insert state polygons
INSERT INTO country_geom (
country,
state_province,
geom,
rank
)
SELECT 
country,
state_province,
ST_Union(ST_SnapToGrid(geom,0.000001)),
'state_province'
FROM world_geom
WHERE country IS NOT NULL AND state_province IS NOT NULL
GROUP BY country, state_province
ORDER BY country, state_province
;

-- Insert county polygons
INSERT INTO country_geom (
country,
state_province,
county,
geom,
rank
)
SELECT 
country,
state_province,
county,
ST_Union(ST_SnapToGrid(geom,0.000001)),
'county'
FROM world_geom
WHERE country IS NOT NULL AND state_province IS NOT NULL AND county IS NOT NULL
GROUP BY country, state_province, county
ORDER BY country, state_province, county
;

-- Index the final table
DROP INDEX IF EXISTS country_geom_country_idx;
CREATE INDEX country_geom_country_idx ON country_geom (country);

DROP INDEX IF EXISTS country_geom_state_province_idx;
CREATE INDEX country_geom_state_province_idx ON country_geom (state_province);

DROP INDEX IF EXISTS country_geom_county_idx;
CREATE INDEX country_geom_county_idx ON country_geom (county);

DROP INDEX IF EXISTS country_geom_geom_idx;
CREATE INDEX country_geom_geom_idx ON country_geom USING gist (geom);


