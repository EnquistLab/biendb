-- --------------------------------------------------
-- Replaces original tables in core database with new tables
--
-- DANGEROUS! Only run after backup and extensive testing!
-- --------------------------------------------------

set search_path to :prod_schema;

BEGIN;

-- Drop original table  
DROP TABLE IF EXISTS agg_traits;

-- Replace with new table from dev schema
ALTER TABLE :dev_schema.agg_traits SET SCHEMA :prod_schema;

--
-- Adjust permissions
--
REVOKE ALL ON TABLE agg_traits FROM PUBLIC;
REVOKE ALL ON TABLE agg_traits FROM bien;
GRANT ALL ON TABLE agg_traits TO bien;
ALTER TABLE agg_traits OWNER TO bien;
GRANT SELECT ON TABLE agg_traits TO public_bien;
GRANT SELECT ON TABLE agg_traits TO public_bien3;

COMMIT;