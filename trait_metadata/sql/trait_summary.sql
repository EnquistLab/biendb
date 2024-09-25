--
-- Creates table trait_summary
--

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS trait_summary;
CREATE TABLE trait_summary AS
SELECT a.trait_name, units, species_count, obs_count
FROM 
(
SELECT DISTINCT trait_name, unit AS units
FROM agg_traits
) AS a
LEFT JOIN 
(
SELECT trait_name, 
COUNT(DISTINCT (scrubbed_species_binomial)) AS species_count
FROM agg_traits
WHERE scrubbed_species_binomial IS NOT NULL
GROUP BY trait_name
) AS b
ON a.trait_name=b.trait_name
LEFT JOIN 
(
SELECT trait_name, COUNT(*) AS obs_count
FROM agg_traits
GROUP BY trait_name
) AS c
ON a.trait_name=c.trait_name
;

CREATE INDEX ON trait_summary (trait_name);
CREATE INDEX ON trait_summary (units);

