-- 
-- Remove null records with null values for stem_dbh_cm
--

SET search_path TO :sch;

DELETE FROM analytical_stem_staging
WHERE stem_dbh_cm IS NULL
;