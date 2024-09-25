-- ---------------------------------------------------------
-- Update starndard political division columns
-- with results of GNRS validations
-- ---------------------------------------------------------

SET search_path TO :sch;

UPDATE ih a
SET
fk_gnrs_id=b.id,
country=b.country,
state_province=b.state_province
FROM gnrs b
WHERE a.poldiv_full=b.poldiv_full
;