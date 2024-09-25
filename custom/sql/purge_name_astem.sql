-- --------------------------------------------------------------------
-- Purge name resolution results from analytical_stem where name match score
-- less than threshold, by fk_tnrs_id
-- 
-- Parameters:
-- 	:sch	schema
-- 	:match_threshold
--	:fk_tnrs_id	
-- 
-- Note: keeping foreign keys fk_tnrs_id and nsr_id, just in case.
-- --------------------------------------------------------------------

SET search_path TO :sch;

UPDATE analytical_stem_dev
SET
bien_taxonomy_id=NULL,
taxon_id=NULL,
family_taxon_id=NULL,
genus_taxon_id=NULL,
species_taxon_id=NULL,
family_matched=NULL,
name_matched=NULL,
name_matched_author=NULL,
tnrs_name_matched_score=NULL,
tnrs_warning=NULL,
matched_taxonomic_status=NULL,
match_summary='[No match found]',
scrubbed_taxonomic_status=NULL,
higher_plant_group=NULL,
scrubbed_family=NULL,
scrubbed_genus=NULL,
scrubbed_specific_epithet=NULL,
scrubbed_species_binomial=NULL,
scrubbed_taxon_name_no_author=NULL,
scrubbed_taxon_canonical=NULL,
scrubbed_author=NULL,
scrubbed_taxon_name_with_author=NULL,
scrubbed_species_binomial_with_morphospecies=name_submitted,
is_embargoed_observation=NULL,
nsr_id=nsr_id,
native_status_country=NULL,
native_status_state_province=NULL,
native_status_county_parish=NULL,
native_status=NULL,
native_status_reason=NULL,
native_status_sources=NULL,
is_introduced=NULL,
is_cultivated_in_region=NULL,
is_cultivated_taxon=NULL
WHERE tnrs_name_matched_score<:match_threshold
AND fk_tnrs_id=:fk_tnrs_id
;