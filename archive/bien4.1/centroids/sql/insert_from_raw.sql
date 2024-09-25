-- -------------------------------------------------------------
-- Create geovalidation results table
-- -------------------------------------------------------------

SET search_path TO :sch;

INSERT INTO centroid (
tbl,
tbl_id,
country_cent_dist,
country_cent_dist_relative,
country_cent_type,
country_max_uncertainty,
state_cent_dist,
state_cent_dist_relative,
state_cent_type,
state_max_uncertainty,
county_cent_dist,
county_cent_dist_relative,
county_cent_type,
county_max_uncertainty
)
SELECT 
split_part(tbl_tbl_id, '_', 1),
split_part(tbl_tbl_id, '_', 2)::bigint,
country_cent_dist,
country_cent_dist_relative,
country_cent_type,
country_max_uncertainty,
state_cent_dist,
state_cent_dist_relative,
state_cent_type,
state_max_uncertainty,
county_cent_dist,
county_cent_dist_relative,
county_cent_type,
county_max_uncertainty
FROM centroid_raw
;

DROP TABLE centroid_raw;