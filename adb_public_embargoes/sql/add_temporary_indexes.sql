-- --------------------------------------------------------------------
-- Add temporary indexes needed for dataset embargo operations
-- --------------------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS analytical_stem_datasource_idx;
CREATE INDEX analytical_stem_datasource_idx ON analytical_stem (datasource);

DROP INDEX IF EXISTS view_full_occurrence_individual_datasource_idx;
CREATE INDEX view_full_occurrence_individual_datasource_idx ON view_full_occurrence_individual (datasource);

DROP INDEX IF EXISTS agg_traits_access_idx;
CREATE INDEX agg_traits_access_idx ON agg_traits (access);

DROP INDEX IF EXISTS agg_traits_trait_value_idx;
CREATE INDEX agg_traits_trait_value_idx ON agg_traits (trait_value);