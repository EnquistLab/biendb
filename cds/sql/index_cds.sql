-- ---------------------------------------------------------
-- Index CDS results table 
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS cds_centroid_poldiv_idx;
DROP INDEX IF EXISTS cds_centroid_type_idx;
DROP INDEX IF EXISTS cds_coordinate_decimal_places_idx;
DROP INDEX IF EXISTS cds_country_cent_type_idx;
DROP INDEX IF EXISTS cds_country_idx;
DROP INDEX IF EXISTS cds_county_cent_type_idx;
DROP INDEX IF EXISTS cds_county_idx;
DROP INDEX IF EXISTS cds_gid_0_idx;
DROP INDEX IF EXISTS cds_gid_1_idx;
DROP INDEX IF EXISTS cds_gid_2_idx;
DROP INDEX IF EXISTS cds_is_country_centroid_idx;
DROP INDEX IF EXISTS cds_is_county_centroid_idx;
DROP INDEX IF EXISTS cds_is_state_centroid_idx;
DROP INDEX IF EXISTS cds_is_subpoly_centroid_idx;
DROP INDEX IF EXISTS cds_latitude_verbatim_idx;
DROP INDEX IF EXISTS cds_latlong_err_idx;
DROP INDEX IF EXISTS cds_latlong_verbatim_idx;
DROP INDEX IF EXISTS cds_longitude_verbatim_idx;
DROP INDEX IF EXISTS cds_max_dist_idx;
DROP INDEX IF EXISTS cds_max_dist_rel_idx;
DROP INDEX IF EXISTS cds_state_cent_type_idx;
DROP INDEX IF EXISTS cds_state_idx;
DROP INDEX IF EXISTS cds_subpoly_cent_type_idx;

CREATE INDEX cds_centroid_poldiv_idx ON cds (centroid_poldiv);
CREATE INDEX cds_centroid_type_idx ON cds (centroid_type);
CREATE INDEX cds_coordinate_decimal_places_idx ON cds (coordinate_decimal_places);
CREATE INDEX cds_country_cent_type_idx ON cds (country_cent_type);
CREATE INDEX cds_country_idx ON cds (country);
CREATE INDEX cds_county_cent_type_idx ON cds (county_cent_type);
CREATE INDEX cds_county_idx ON cds (county);
CREATE INDEX cds_gid_0_idx ON cds (gid_0);
CREATE INDEX cds_gid_1_idx ON cds (gid_1);
CREATE INDEX cds_gid_2_idx ON cds (gid_2);
CREATE INDEX cds_is_country_centroid_idx ON cds (is_country_centroid);
CREATE INDEX cds_is_county_centroid_idx ON cds (is_county_centroid);
CREATE INDEX cds_is_state_centroid_idx ON cds (is_state_centroid);
CREATE INDEX cds_is_subpoly_centroid_idx ON cds (is_subpoly_centroid);
CREATE INDEX cds_latitude_verbatim_idx ON cds (latitude_verbatim);
CREATE INDEX cds_latlong_err_idx ON cds (latlong_err);
CREATE INDEX cds_latlong_verbatim_idx ON cds (latlong_verbatim);
CREATE INDEX cds_longitude_verbatim_idx ON cds (longitude_verbatim);
CREATE INDEX cds_max_dist_idx ON cds (max_dist);
CREATE INDEX cds_max_dist_rel_idx ON cds (max_dist_rel);
CREATE INDEX cds_state_cent_type_idx ON cds (state_cent_type);
CREATE INDEX cds_state_idx ON cds (state);
CREATE INDEX cds_subpoly_cent_type_idx ON cds (subpoly_cent_type);