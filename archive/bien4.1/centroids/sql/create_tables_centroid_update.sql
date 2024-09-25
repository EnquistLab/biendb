-- -------------------------------------------------------------
-- Create centroid update table (one time fix)
-- -------------------------------------------------------------

SET search_path TO :sch;

-- Temporary version to accommodate integer IDs stored using
-- scientific notation. Columns tbl_id and centroid_id here 
-- defined as type numeric, but later cast to bigint.
DROP TABLE IF EXISTS centroid_2;
CREATE TABLE centroid_2 (
tbl text not null,
tbl_id numeric not null,
centroid_id numeric primary key,
is_centroid smallint,
centroid_dist_relative numeric,
centroid_poldiv text,
centroid_type text,
centroid_max_uncertainty numeric
);

DROP TABLE IF EXISTS centroid;
CREATE TABLE centroid (
centroid_id bigint primary key,
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
county_max_uncertainty numeric,
is_centroid smallint,
centroid_dist_relative numeric,
centroid_poldiv text,
centroid_type text,
centroid_max_uncertainty numeric
);