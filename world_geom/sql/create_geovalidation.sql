-- -------------------------------------------------------------
-- Create geovalidation results table
-- -------------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS geovalidation;
CREATE TABLE geovalidation (
tbl varchar(25) not null,
id bigint not null,
is_in_country smallint,
is_in_state smallint,
is_in_county smallint
);