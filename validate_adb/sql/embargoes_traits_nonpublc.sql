-- ------------------------------------------------------------
-- Check that all non-public traits removed from table agg_traits
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (
SELECT id 
FROM agg_traits 
WHERE access <> 'public'
OR access IS NULL
OR trait_value IS NULL
LIMIT 1
) AS a;

