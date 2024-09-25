-- ---------------------------------------------------------
-- Outputs list of distinct species where geocoordinates are
-- not null
-- ---------------------------------------------------------

SET search_path TO :sch;

SELECT DISTINCT country
FROM country
ORDER BY country
;