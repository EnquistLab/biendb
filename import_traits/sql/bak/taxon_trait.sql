--
-- Create table taxon_trait
--

BEGIN;

-- Create table in development schema
SET search_path TO :src_schema;

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

-- move table to production schema
SET search_path TO :target_schema;
DROP TABLE IF EXISTS taxon_trait;
ALTER TABLE :src_schema.taxon_trait SET SCHEMA :target_schema;

-- Index the table
CREATE INDEX ON taxon_trait ("scientificName", "measurementType");

REVOKE ALL ON TABLE taxon_trait FROM PUBLIC;
REVOKE ALL ON TABLE taxon_trait FROM bien;
GRANT ALL ON TABLE taxon_trait TO bien;
ALTER TABLE taxon_trait OWNER TO bien;
GRANT SELECT ON TABLE taxon_trait TO public_bien;
GRANT SELECT ON TABLE taxon_trait TO public_bien3;

COMMIT;