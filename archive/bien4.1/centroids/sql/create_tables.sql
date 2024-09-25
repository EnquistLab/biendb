-- -------------------------------------------------------------
-- Create centroid results table
-- -------------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS centroid;
CREATE TABLE centroid (
tbl text not null,
tbl_id bigint not null,
country_cent_dist numeric,
country_cent_dist_relative numeric,
country_cent_type text,
country_max_uncertainty numeric,
state_cent_dist numeric,
state_cent_dist_relative numeric,
state_cent_type text,
state_max_uncertainty numeric,
county_cent_dist numeric,
county_cent_dist_relative numeric,
county_cent_type text,
county_max_uncertainty numeric
);

DROP TABLE IF EXISTS centroid_raw;
CREATE TABLE centroid_raw (
tbl_tbl_id text not null,
country_cent_dist numeric,
country_cent_dist_relative numeric,
country_cent_type text,
country_max_uncertainty numeric,
state_cent_dist numeric,
state_cent_dist_relative numeric,
state_cent_type text,
state_max_uncertainty numeric,
county_cent_dist numeric,
county_cent_dist_relative numeric,
county_cent_type text,
county_max_uncertainty numeric
);