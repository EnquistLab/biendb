/* ------------------------------------------------------------------
Fix incorrect geopolitical validation fields (is_in_country, 
is_in_state_province, is_in_county) for observations from South Sudan.

All South Sudan obs were marked is_in_country=0 due to erroneous value
of gid_0='SDS' for South Sudan in the GNRS, which does not match to the
correct value gid_0='SSD' in the CDS. The only error is in gid_0; gid_1 and gid_2 are fine.

Issue has been fixed in GNRS; no correction to DB pipeline is required.
BIEN DB version incremented from 4.2.2 to 4.2.3 after this update

Date: 3 Nov. 2021
*/ ------------------------------------------------------------------

\c vegbien
set search_path to analytical_db;

--
-- Update gid_0 in table gnrs
--

UPDATE gnrs
SET gid_0='SSD'
WHERE gid_0='SDS'
;

--
-- Update gid_0 in table vfoi
--

UPDATE view_full_occurrence_individual
SET gid_0='SSD'
WHERE gid_0='SDS'
;

--
-- Update geopolitical validation fields in table vfoi
--

-- Index column vfoi.latlong_verbatim
-- Also added to pipeline index scripts in modules restore_indexes/ 
-- and remove_indexes/ 
DROP INDEX IF EXISTS vfoi_latlong_verbatim_idx;
CREATE INDEX vfoi_latlong_verbatim_idx ON view_full_occurrence_individual(latlong_verbatim);

-- update poldiv-specific geopolitical validation fields
UPDATE view_full_occurrence_individual a
SET 
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
WHERE a.gid_0='SSD' 
AND a.latitude IS NOT NULL AND a.longitude IS NOT NULL 
AND a.is_invalid_latlong=0
AND b.gid_0='SSD'
AND a.latlong_verbatim=b.latlong_verbatim
;

-- Update consensus geovalidation field "is_geovalid"
UPDATE view_full_occurrence_individual
SET 
is_geovalid=
CASE
WHEN is_in_country=1 
AND (is_in_state_province=1 OR is_in_state_province IS NULL)
AND (is_in_county=1 OR is_in_county IS NULL)
THEN 1
ELSE 0
END 
WHERE gid_0='SSD'
AND latitude IS NOT NULL AND longitude IS NOT NULL 
AND is_invalid_latlong=0
;

