-- ---------------------------------------------------------
-- Update standard political division columns in table
-- plot_metadata by transferring GNRS results from vfoi
-- ---------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE plot_metadata DROP COLUMN IF EXISTS fk_cds_id;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS is_centroid;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS centroid_dist_km;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS centroid_dist_relative;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS centroid_likelihood;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS centroid_poldiv;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS centroid_type;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS coordinate_inherent_uncertainty_m;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS is_invalid_latlong;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS invalid_latlong_reason;

ALTER TABLE plot_metadata 
ADD COLUMN fk_cds_id INTEGER DEFAULT NULL,

ADD COLUMN is_centroid INTEGER DEFAULT NULL,
ADD COLUMN centroid_dist_km numeric DEFAULT NULL,
ADD COLUMN centroid_dist_relative numeric DEFAULT NULL,
ADD COLUMN centroid_likelihood numeric DEFAULT NULL,
ADD COLUMN centroid_poldiv text DEFAULT NULL,
ADD COLUMN centroid_type text DEFAULT NULL,
ADD COLUMN coordinate_inherent_uncertainty_m numeric DEFAULT NULL,
ADD COLUMN is_invalid_latlong INTEGER DEFAULT 0,
ADD COLUMN invalid_latlong_reason text DEFAULT NULL
;

-- Create temporary partial index
DROP INDEX IF EXISTS plot_metadata_latlong_verbatim_idx;
CREATE INDEX plot_metadata_latlong_verbatim_idx ON plot_metadata (latlong_verbatim);

-- Update plot_metadata and drop the remaining temp table
UPDATE plot_metadata a
SET 
fk_cds_id=b.id::integer,
is_centroid=
CASE
WHEN b.centroid_dist_relative IS NULL THEN 0
WHEN b.centroid_dist_relative <= :REL_DIST_MAX THEN 1
ELSE 0
END,
is_invalid_latlong=
CASE
WHEN b.latlong_err IS NOT NULL THEN 1
ELSE 0
END,
invalid_latlong_reason=b.latlong_err,
centroid_dist_km=b.centroid_dist_km,
centroid_dist_relative=b.centroid_dist_relative,
centroid_likelihood=
CASE
WHEN b.centroid_dist_relative IS NOT NULL THEN 
1-b.centroid_dist_relative::numeric
ELSE NULL
END,
centroid_poldiv=b.centroid_poldiv,
centroid_type=b.centroid_type,
coordinate_inherent_uncertainty_m=b.coordinate_inherent_uncertainty_m,
is_in_country=
CASE
WHEN a.gid_0=b.gid_0 THEN 1
WHEN a.gid_0<>b.gid_0 AND a.gid_0 IS NOT NULL AND b.gid_0 IS NOT NULL THEN 0
ELSE NULL
END,
is_in_state_province=
CASE
WHEN a.gid_0=b.gid_0 AND a.gid_1=b.gid_1 THEN 1
WHEN a.gid_0=b.gid_0 AND a.gid_1<>b.gid_1 AND a.gid_1 IS NOT NULL AND b.gid_1 IS NOT NULL THEN 0
ELSE NULL
END,
is_in_county=
CASE
WHEN a.gid_0=b.gid_0 AND a.gid_1=b.gid_1 AND a.gid_2=b.gid_2 THEN 1
WHEN a.gid_0=b.gid_0 AND a.gid_1=b.gid_1 AND a.gid_2<>b.gid_2 AND a.gid_1 IS NOT NULL AND b.gid_1 IS NOT NULL AND b.gid_2 IS NOT NULL THEN 0
ELSE NULL
END
FROM cds b
WHERE a.latlong_verbatim=b.latlong_verbatim
;

