-- ---------------------------------------------------------
-- Create tables for validation pdg
-- 
-- Latitude and longitude MUST have been already converted to
-- wkt in source table, as only the resulting geom field is 
-- copied over
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS pdg_submitted;
CREATE TABLE pdg_submitted (
id text,
country_verbatim text,
state_province_verbatim text,
county_verbatim text,
geom geometry(Point,4326),
id_int bigserial primary key
);

DROP TABLE IF EXISTS pdg_results;
CREATE TABLE pdg_results (
id text,
id_int bigint,
country_verbatim text,
state_province_verbatim text,
county_verbatim text,
geom geometry(Point,4326),
country text default null,
state_province text default null,
county text default null,
country_id bigint default null,
state_province_id bigint default null,
county_id bigint default null,
is_in_country smallint default null,
is_in_state_province smallint default null,
is_in_county smallint default null,
is_geovalid smallint default null,
);