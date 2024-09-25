-- --------------------------------------------------------------------
-- Add temporary indexes needed for dataset embargo operations
-- --------------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS analytical_stem_datasource_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_datasource_idx;
DROP INDEX IF EXISTS agg_traits_access_idx;
DROP INDEX IF EXISTS agg_traits_trait_value_idx;
