-- ------------------------------------------------------------
-- Check that all traits with <300 species removed from traits
-- table
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (
SELECT id 
FROM agg_traits a JOIN trait_summary b
ON a.trait_name=b.trait_name
WHERE b.species_count<=300
LIMIT 1
) AS a;

