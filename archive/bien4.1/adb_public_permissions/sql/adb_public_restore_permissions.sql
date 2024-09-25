-- -----------------------------------------------------------------
-- Restore privileges of read-only user on this schema
-- Assumes running as user bien and that bien owns the current schema
-- Be sure to add user to pg_hba file!
-- -----------------------------------------------------------------

-- revoke all for PUBLIC, to prevent inheritance
REVOKE ALL ON ALL TABLES IN SCHEMA :sch FROM PUBLIC;

-- revoke all for user bien_private (inherited from private db)
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA :sch FROM bien_private;
REVOKE USAGE ON SCHEMA :sch FROM bien_private;

-- public_bien
GRANT USAGE ON SCHEMA :sch TO public_bien;
GRANT SELECT ON ALL TABLES IN SCHEMA :sch TO public_bien;

-- Jeanine
GRANT USAGE ON SCHEMA :sch TO jmcgann;
GRANT SELECT ON ALL TABLES IN SCHEMA :sch TO jmcgann;

-- public_bien3
-- selected tables only
GRANT USAGE ON SCHEMA :sch TO public_bien3;
GRANT SELECT ON :sch.agg_traits TO public_bien3;
GRANT SELECT ON :sch.bien_summary TO public_bien3;
GRANT SELECT ON :sch.data_contributors TO public_bien3;
GRANT SELECT ON :sch.endangered_taxa TO public_bien3;
GRANT SELECT ON :sch.taxon_trait TO public_bien3;
GRANT SELECT ON :sch.trait_summary TO public_bien3;
GRANT SELECT ON :sch.view_full_occurrence_individual TO public_bien3;