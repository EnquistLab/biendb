-- ------------------------------------------------------------
-- Check that at least one validation fk value present in table
-- Requires parameters:
--	$sch --> :sch
-- 	$check_tbl --> :check_tbl
--	$sql_where --> :sql_where
--	$name_where --> :name_where
-- ------------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS species_observation_counts_sep;
CREATE TABLE species_observation_counts_sep AS
SELECT scrubbed_species_binomial AS species,
:'name_where' AS filter,
COUNT(*)::integer AS observations
FROM :"check_tbl"
:sql_where
GROUP BY scrubbed_species_binomial
;

DROP TABLE IF EXISTS species_observation_counts_sep_filters;
CREATE TABLE species_observation_counts_sep_filters (
filter_name text,
filter text
);
INSERT INTO species_observation_counts_sep_filters (
filter_name,
filter
)
VALUES (
:'name_where',
:'sql_where'
)
;
