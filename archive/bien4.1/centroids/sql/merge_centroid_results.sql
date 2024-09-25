-- -------------------------------------------------------------
-- Merge tables centroid_1 and centroid_2 into table centroid
-- (one time fix)
-- -------------------------------------------------------------

SET search_path TO :sch;

-- First, cast column tbl_id in table centroid_2 to bigint
-- Column initially created as numeric to support scientific notation
ALTER TABLE centroid_2
ALTER COLUMN tbl_id TYPE bigint USING tbl_id::bigint
;
ALTER TABLE centroid_2
ALTER COLUMN centroid_id TYPE bigint USING centroid_id::bigint
;

INSERT INTO centroid (
centroid_id,
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
county_max_uncertainty,
is_centroid,
centroid_dist_relative,
centroid_poldiv,
centroid_type,
centroid_max_uncertainty
)
SELECT
a.centroid_id,
a.tbl,
a.tbl_id,
a.country_cent_dist,
a.country_cent_dist_relative,
a.country_cent_type,
a.country_max_uncertainty,
a.state_cent_dist,
a.state_cent_dist_relative,
a.state_cent_type,
a.state_max_uncertainty,
a.county_cent_dist,
a.county_cent_dist_relative,
a.county_cent_type,
a.county_max_uncertainty,
b.is_centroid,
b.centroid_dist_relative,
b.centroid_poldiv,
b.centroid_type,
b.centroid_max_uncertainty
FROM centroid_1 a JOIN centroid_2 b
ON a.centroid_id=b.centroid_id
;

