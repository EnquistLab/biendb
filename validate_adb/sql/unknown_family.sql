-- ------------------------------------------------------------
-- Check for non-plant scrubbed families
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (SELECT scrubbed_family FROM bien_taxonomy WHERE LOWER(scrubbed_family)='unknown') AS a;
