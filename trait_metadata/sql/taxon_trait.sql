--
-- Creates table taxon_trait
--

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS taxon_trait;
CREATE TABLE taxon_trait AS
SELECT
scrubbed_species_binomial AS "scientificName", 
trait_name AS "measurementType",
trait_value AS "measurementValue",
unit AS "measurementUnit"
FROM agg_traits
WHERE scrubbed_species_binomial IS NOT NULL
;

CREATE INDEX ON taxon_trait ("scientificName");
CREATE INDEX ON taxon_trait ("measurementType");
CREATE INDEX ON taxon_trait ("measurementValue");
CREATE INDEX ON taxon_trait ("measurementUnit");
