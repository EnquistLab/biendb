-- ------------------------------------------------------------
-- Check that at least one validation fk value present in table
-- Requires parameters:
--	$sch --> :sch
-- 	$check_tbl --> :check_tbl
--	$sql_where --> :sql_where
--	$name_where --> :name_where
-- ------------------------------------------------------------

SET search_path TO :sch;

INSERT INTO species_observation_counts (
species,
filter,
observations
) 
SELECT 
scrubbed_species_binomial,
:'name_where',
COUNT(*)
FROM :"check_tbl"
:sql_where
GROUP BY scrubbed_species_binomial
;

INSERT INTO species_observation_counts_filters (
filter_name,
filter
)
VALUES (
:'name_where',
:'sql_where'
)
;

