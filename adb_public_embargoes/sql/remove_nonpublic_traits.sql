-- --------------------------------------------------------------------
-- Removes non-public traits records
-- --------------------------------------------------------------------

SET search_path TO :sch;

-- Delete non-public records
-- Be sure to add index on column access if it doesn't already have one
DELETE FROM :sch.agg_traits
WHERE access <> 'public'
OR access IS NULL
OR trait_value IS NULL
;
