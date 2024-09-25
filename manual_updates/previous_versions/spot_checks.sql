-- ------------------------------------------------------------------
-- Quick visual checks on key data elements
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
-- Issues found:
-- 1. Improper formation of morphospecies due to bug in TNRS (FIXED)
-- 2. NSR results missing from agg_traits
-- 3. Cultobs results missing from agg_traits (Know issue, fix next time)
-- 4. Geovalidation: is_in_state_province null when resolved state_province
-- 		present, yet other records with same political division have non-
-- 		null is_in_state_province. (ISSUE WITH geovalidation; fix next time)
-- 5. is_new_world: "United States" marked as Old World! (FIXED)
-- ------------------------------------------------------------------

-- 
-- GNRS results
-- 
-- Also try with agg_traits, analytical_stem_dev
SELECT country_verbatim, state_province_verbatim, county_verbatim, 
country, state_province, county
FROM view_full_occurrence_individual_dev
WHERE county is not null 
limit 12
;
SELECT country_verbatim, state_province_verbatim, county_verbatim, 
country, state_province, county
FROM view_full_occurrence_individual_dev
WHERE county_verbatim is not null and county is null
limit 12
;

-- 
-- TNRS results
-- 

-- Check full results for one record
\x
SELECT 
fk_tnrs_id,
verbatim_scientific_name,
name_submitted,
family_matched,
name_matched,
name_matched_author,
tnrs_name_matched_score,
higher_plant_group,
tnrs_warning,
matched_taxonomic_status,
match_summary,
scrubbed_taxonomic_status,
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical,
scrubbed_author,
scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies
FROM view_full_occurrence_individual_dev
WHERE name_matched IS NOT NULL
LIMIT 1
;
\x
-- Check sets of records
-- Also try with agg_traits, analytical_stem_dev
SELECT 
fk_tnrs_id,
verbatim_scientific_name,
family_matched,
name_matched,
tnrs_name_matched_score as score,
tnrs_warning,
matched_taxonomic_status as status,
match_summary,
scrubbed_family,
scrubbed_taxon_name_no_author as taxon
FROM view_full_occurrence_individual_dev
WHERE name_matched IS NOT NULL
LIMIT 12
;

-- Check morphospecies
SELECT 
verbatim_family,
verbatim_scientific_name,
family_matched,
name_matched,
tnrs_name_matched_score as score,
matched_taxonomic_status as status,
match_summary,
scrubbed_taxon_name_no_author as taxon,
scrubbed_species_binomial_with_morphospecies as morphospecies
FROM view_full_occurrence_individual_dev
WHERE scrubbed_species_binomial_with_morphospecies ~ 'sp.[0-9]'
LIMIT 12
;

-- Check subspecies correctly handled
SELECT 
verbatim_family,
verbatim_scientific_name,
family_matched,
name_matched,
tnrs_name_matched_score as score,
matched_taxonomic_status as status,
match_summary,
scrubbed_taxon_name_no_author as taxon,
scrubbed_taxon_canonical as taxon_canonical
FROM view_full_occurrence_individual_dev
WHERE scrubbed_taxon_name_no_author like '%var.%'
LIMIT 12
;

-- Check taxon ids
SELECT 
fk_tnrs_id,
scrubbed_family,
scrubbed_taxon_name_no_author,
b.family,
c.genus, 
d.species,
e.taxon
FROM view_full_occurrence_individual_dev a 
left join taxon b
ON a.family_taxon_id=b.taxon_id
left join taxon c
ON a.genus_taxon_id=c.taxon_id
left join taxon d
ON a.species_taxon_id=d.taxon_id
left join taxon e
ON a.taxon_id=e.taxon_id
WHERE name_matched IS NOT NULL
LIMIT 12
;

-- 
-- Higher taxa
-- 

SELECT higher_plant_group, scrubbed_family,
scrubbed_taxon_name_no_author as taxon,
scrubbed_species_binomial_with_morphospecies as morpho
FROM view_full_occurrence_individual_dev
LIMIT 12;

-- 
-- NSR results
-- 
-- Also try with agg_traits, analytical_stem_dev
SELECT scrubbed_taxon_name_no_author as taxon,
country, state_province, county,
nsr_id, 
native_status_country AS ns_c,
native_status_state_province AS ns_sp,
native_status_county_parish AS ns_cp,
native_status as ns,
native_status_reason as ns_reason,
native_status_sources as ns_sources,
isintroduced as is_intr,
is_cultivated_in_region is_cult_reg,
is_cultivated_taxon as is_cult_taxon
FROM view_full_occurrence_individual_dev
LIMIT 12
;

-- 
-- cultobs results
-- 
-- Also try with agg_traits
SELECT 
scrubbed_family,
scrubbed_taxon_name_no_author,
is_cultivated_observation, 
is_cultivated_observation_basis
FROM view_full_occurrence_individual_dev
LIMIT 12
;

-- 
-- geovalidation results & check is_geovalid
-- 
-- Also try with agg_traits
SELECT 
country, state_province, county,
is_in_country, is_in_state_province, is_in_county,
is_geovalid
FROM view_full_occurrence_individual_dev
LIMIT 12
;

-- 
-- is_new_world
-- 
-- Also try with agg_traits
SELECT is_new_world,
country
FROM view_full_occurrence_individual_dev
LIMIT 12
;




