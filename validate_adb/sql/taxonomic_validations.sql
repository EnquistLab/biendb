-- ------------------------------------------------------------
-- Taxonomic validations
-- ------------------------------------------------------------

\c vegbien
SET search_path TO analytical_db_dev;

-- 
-- Non-plant families
-- 

SELECT scrubbed_family FROM 
(
SELECT DISTINCT scrubbed_family
FROM view_full_occurrence_individual
WHERE scrubbed_family IS NOT NULL 
) AS a
WHERE NOT scrubbed_family ILIKE '%aceae%'
ORDER BY scrubbed_family
;

-- 
-- Count of higher plant groups
-- 

SELECT major_taxon, COUNT(*)
FROM tnrs
GROUP BY major_taxon
ORDER BY major_taxon
;