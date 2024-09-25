-- ---------------------------------------------------------
-- Update political division columns in table vfoi with 
-- results of GNRS validations
-- ---------------------------------------------------------


SET search_path TO :sch;

-- For best performance, only index on vfoi should be on column poldiv_full
UPDATE view_full_occurrence_individual_dev a
SET
fk_gnrs_id=b.id,
country=b.country,
state_province=b.state_province,
county=b.county_parish
FROM gnrs b
WHERE a.poldiv_full=b.poldiv_full
;

-- Now drop the index
DROP INDEX IF EXISTS vfoi_poldiv_full_idx;