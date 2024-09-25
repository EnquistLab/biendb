
-- --------------------------------------------------------------
-- Insert georeferenced trait observations to staging table
-- 
-- NOTES: 
--	1. Records inserted from agg_traits, not traits_raw
--	2. Only NEW observations, not previously extracted from vfoi,
--		are loaded.
-- --------------------------------------------------------------

SET search_path TO :sch;

INSERT INTO vfoi_staging (
observation_type,
plot_metadata_id,
datasource_id,
datasource,
dataset,
dataowner,
country_verbatim,
state_province_verbatim,
county_verbatim,
country,
state_province,
county,
locality,
latlong_verbatim,	
latitude,
longitude,
geodeticDatum,
coord_uncertainty_m,
coord_uncertainty_verbatim,
coord_max_uncertainty_km,
georef_sources,
georef_protocol,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
is_new_world,
project_id,
project_contributors,
location_id,
plot_name,
subplot,
is_location_cultivated,
locationevent_id,
event_date_verbatim,
event_date,
event_date_accuracy,
elevation_verbatim,
elevation_m,
elevation_min_m,
elevation_max_m,
slope_aspect_deg,
slope_gradient_deg,
plot_area_ha,
sampling_protocol,
temperature_c,
precip_mm,
stratum_name,
vegetation_verbatim,
community_concept_name,
observation_contributors,
custodial_institution_codes,
collection_code,
catalog_number,
occurrence_id,
recorded_by,
record_number,
date_collected_verbatim,
date_collected,
date_collected_accuracy,
identified_by,
date_identified_verbatim,
date_identified,
date_identified_accuracy,
identification_remarks,
bien_taxonomy_id,
taxon_id,
family_taxon_id,
genus_taxon_id,
species_taxon_id,
verbatim_family,
verbatim_scientific_name,
name_submitted,
fk_tnrs_id,
family_matched,
name_matched,
name_matched_author,
tnrs_name_matched_score,
tnrs_warning,
matched_taxonomic_status,
scrubbed_taxonomic_status,
higher_plant_group,
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical,
scrubbed_author,
scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies,
growth_form,
reproductive_condition,
occurrence_remarks,
taxon_observation_id,
taxon_name_usage_concept_author_code,
plantobservation_id,
aggregate_organism_observation_id,
individual_organism_observation_id,
individual_id,
individual_count,
stem_height_m,
cover_percent,
cites,
iucn,
usda_federal,
usda_state,
is_embargoed_observation,
geom,
citation_verbatim,
citation,
is_new
) 
SELECT
'trait occurrence',
NULL,
NULL,
:'src',
:'src',
:'src',
"country_verbatim",
"state_province_verbatim",
"county_verbatim",
NULL,
NULL,
NULL,
locality_description,
latlong_verbatim,
latitude::numeric,
longitude::numeric,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
visiting_date_verbatim,
visiting_date,
visiting_date_accuracy,
elevation_verbatim,
elevation_m::numeric,
elevation_min_m::numeric,
elevation_max_m::numeric,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
string_to_array(authorship, ';'),
NULL,
NULL,
id,
NULL,
authorship,
NULL,
observation_date_verbatim,
observation_date,
observation_date_accuracy,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
verbatim_family,
verbatim_scientific_name,
name_submitted,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
case
when trait_name='growth form' then trait_value
else null
end,
NULL,
observation_context,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
case
when trait_name='whole plant height' and unit='m' and public.is_numeric(trait_value)='t' then trait_value::numeric
else null
end,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
citation_bibtex,
citation_bibtex,
1
FROM agg_traits
WHERE verbatim_scientific_name IS NOT NULL
AND latitude IS NOT NULL
AND longitude IS NOT NULL
AND taxonobservation_id IS NULL
;
