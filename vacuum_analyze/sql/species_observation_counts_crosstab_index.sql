-- ------------------------------------------------------------
-- Add indexed columns family, taxonomic status & index species
-- Requires parameter:
--	$sch --> :sch
-- ------------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS species_observation_counts_crosstab_temp;
CREATE TABLE species_observation_counts_crosstab_temp AS
SELECT DISTINCT
b.taxonomic_status,
NULL::text AS family,
a.*
FROM species_observation_counts_crosstab a LEFT JOIN (
	SELECT x.scrubbed_species_binomial, x.scrubbed_taxonomic_status AS taxonomic_status
	FROM bien_taxonomy x JOIN (
		SELECT scrubbed_species_binomial, COUNT(DISTINCT scrubbed_taxonomic_status) 
		FROM bien_taxonomy
		GROUP BY scrubbed_species_binomial
		HAVING COUNT(DISTINCT scrubbed_taxonomic_status)=1
	) y
	ON x.scrubbed_species_binomial=y.scrubbed_species_binomial
) AS b
ON a.species=b.scrubbed_species_binomial
;

DROP TABLE IF EXISTS species_observation_counts_crosstab;
ALTER TABLE species_observation_counts_crosstab_temp RENAME TO species_observation_counts_crosstab;

DROP INDEX IF EXISTS species_observation_counts_crosstab_species_idx;
CREATE INDEX species_observation_counts_crosstab_species_idx ON species_observation_counts_crosstab (species);

UPDATE species_observation_counts_crosstab a
SET family=b.scrubbed_family
FROM (
SELECT x.scrubbed_family, x.scrubbed_species_binomial
FROM bien_taxonomy x JOIN (
SELECT scrubbed_species_binomial, COUNT(DISTINCT scrubbed_family)
FROM bien_taxonomy
GROUP BY scrubbed_species_binomial
HAVING COUNT(DISTINCT scrubbed_family)=1
) y
ON x.scrubbed_species_binomial=y.scrubbed_species_binomial
) b
WHERE a.species=b.scrubbed_species_binomial
;

UPDATE species_observation_counts_crosstab
SET family='[ambiguous]'
WHERE family IS NULL OR family ILIKE '%unknown%';
;
UPDATE species_observation_counts_crosstab
SET taxonomic_status='[ambiguous]'
WHERE taxonomic_status IS NULL
;