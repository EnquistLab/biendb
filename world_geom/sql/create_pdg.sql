-- -----------------------------------------------------------
-- Create table pdg to hold results of pdg validation
-- -----------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS pdg;
CREATE TABLE pdg (
pdg_id bigserial not null,
tbl_name text not null,
tbl_id bigint not null,
country text not null,
state_province text default null,
county text default null,
latitude numeric not null,
longitude numeric not null,
geom postgis.geometry(Point,4326) default null,
is_in_country smallint default null,
is_in_state_province smallint default null,
is_in_county smallint default null,
is_geovalid smallint default null,
geovalid_fail_reason text default null
);
