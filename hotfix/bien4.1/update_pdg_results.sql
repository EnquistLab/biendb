-- -----------------------------------------------------------------
-- Populates missing pdg results for countries with only 2
-- political divisions. Due to glitch in PDG that will be fixed 
-- next time around.
-- -----------------------------------------------------------------

SET search_path TO analytical_db_dev;

-- analytical_stem
-- same ID as vfoi
UPDATE analytical_stem a
SET 
is_in_country=b.is_in_country,
is_in_state_province=b.is_in_state_province,
is_in_county=b.is_in_county.
is_geovalid=b.is_geovalid
FROM pdg
WHERE a.country IS NOT NULL
AND a.is_geovalid_issue IS NULL
AND a.is_geovalid IS NULL
AND b.tbl_name='view_full_occurrence_individual'
AND a.taxonobservation_id=b.tbl_id
;

UPDATE agg_traits a
SET 
is_in_country=b.is_in_country,
is_in_state_province=b.is_in_state_province,
is_in_county=b.is_in_county.
is_geovalid=b.is_geovalid
FROM pdg
WHERE a.country IS NOT NULL
AND a.is_geovalid_issue IS NULL
AND a.is_geovalid IS NULL
AND b.tbl_name='agg_traits'
AND a.id=b.tbl_id
;

UPDATE view_full_occurrence_individual a
SET 
is_in_country=b.is_in_country,
is_in_state_province=b.is_in_state_province,
is_in_county=b.is_in_county.
is_geovalid=b.is_geovalid
FROM pdg
WHERE a.country IS NOT NULL
AND a.is_geovalid_issue IS NULL
AND a.is_geovalid IS NULL
AND b.tbl_name='view_full_occurrence_individual'
AND a.taxonobservation_id=b.tbl_id
;