--
-- Restores all indexes on agg_traits
--

SET search_path TO :sch;

-- Drop all the indexes, in case they already exist
DROP INDEX IF EXISTS agg_traits_pkey;
DROP INDEX IF EXISTS agg_traits_authorship_idx;
DROP INDEX IF EXISTS agg_traits_country_idx;
DROP INDEX IF EXISTS agg_traits_family_matched_idx;
DROP INDEX IF EXISTS agg_traits_fk_tnrs_user_id_idx;
DROP INDEX IF EXISTS agg_traits_higher_plant_group_idx;
DROP INDEX IF EXISTS agg_traits_matched_taxonomic_status_idx;
DROP INDEX IF EXISTS agg_traits_method_idx;
DROP INDEX IF EXISTS agg_traits_name_matched_idx;
DROP INDEX IF EXISTS agg_traits_name_submitted_idx;
DROP INDEX IF EXISTS agg_traits_project_pi_idx;
DROP INDEX IF EXISTS agg_traits_region_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_family_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_genus_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_with_morphospecies_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_taxon_canonical_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_taxon_name_no_author_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_taxonomic_status_idx;
DROP INDEX IF EXISTS agg_traits_source_idx;
DROP INDEX IF EXISTS agg_traits_stateprovince_idx;
DROP INDEX IF EXISTS agg_traits_trait_name_idx;
DROP INDEX IF EXISTS agg_traits_unit_idx;
DROP INDEX IF EXISTS agg_traits_verbatim_family_idx;
DROP INDEX IF EXISTS agg_traits_verbatim_scientific_name_idx;

-- New columns:
DROP INDEX IF EXISTS agg_traits_country_verbatim_idx;
DROP INDEX IF EXISTS agg_traits_state_province_verbatim_idx;
DROP INDEX IF EXISTS agg_traits_county_verbatim_idx;
DROP INDEX IF EXISTS agg_traits_country_verbatim_is_null_idx;
DROP INDEX IF EXISTS agg_traits_state_province_verbatim_is_null_idx;
DROP INDEX IF EXISTS agg_traits_county_verbatim_is_null_idx;
DROP INDEX IF EXISTS agg_traits_poldiv_full_idx;
DROP INDEX IF EXISTS agg_traits_col_idx;
DROP INDEX IF EXISTS agg_traits_col_idx;
DROP INDEX IF EXISTS agg_traits_col_idx;
DROP INDEX IF EXISTS agg_traits_col_idx;
DROP INDEX IF EXISTS agg_traits_col_idx;
