-- ---------------------------------------------------------
-- Create table for storing CDS validation results
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS cds;
CREATE TABLE cds (
id text,
latitude_verbatim text,
longitude_verbatim text,
latitude numeric,
longitude numeric,
user_id text,
gid_0 text,
country text,
gid_1 text,
state text,
gid_2 text,
county text,
country_cent_dist numeric,
country_cent_dist_relative numeric,
country_cent_type text,
country_cent_dist_max numeric,
is_country_centroid smallint default null,
state_cent_dist numeric,
state_cent_dist_relative numeric,
state_cent_type text,
state_cent_dist_max numeric,
is_state_centroid smallint default null,
county_cent_dist numeric,
county_cent_dist_relative numeric,
county_cent_type text,
county_cent_dist_max numeric,
is_county_centroid smallint default null,
subpoly_cent_dist numeric,
subpoly_cent_dist_relative numeric,
subpoly_cent_type text,
subpoly_cent_dist_max numeric,
is_subpoly_centroid smallint default null,
centroid_dist_km numeric,
centroid_dist_relative numeric,
centroid_type text,
centroid_dist_max_km numeric,
centroid_poldiv text,
max_dist numeric,
max_dist_rel numeric,
latlong_err text,
coordinate_decimal_places int,
coordinate_inherent_uncertainty_m numeric
) 
;
