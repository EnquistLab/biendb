-- 
-- Lists all traits and their units in the BIEN database, along
-- with counts of species and observations
--

BEGIN;

SET search_path TO :src_schema;

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

-- move table to production schema
SET search_path TO :target_schema;
DROP TABLE IF EXISTS trait_summary;
ALTER TABLE :src_schema.trait_summary SET SCHEMA :target_schema;

REVOKE ALL ON TABLE trait_summary FROM PUBLIC;
REVOKE ALL ON TABLE trait_summary FROM bien;
GRANT ALL ON TABLE trait_summary TO bien;
ALTER TABLE trait_summary OWNER TO bien;
GRANT SELECT ON TABLE trait_summary TO public_bien;
GRANT SELECT ON TABLE trait_summary TO public_bien3;

COMMIT;