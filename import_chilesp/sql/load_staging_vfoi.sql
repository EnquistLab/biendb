
-- --------------------------------------------------------------
-- Insert raw data to staging table
-- 
-- NOTE: This script is source-specific
-- NOTE: Population of _date columns assumes:
-- 1. All empty strings in columns "Year", "Month" and "Day" have 
-- 	been converted to NULL.
-- 2. Non-null combinations of "Year", "Month", "Day" represent
--  valid dates.
-- The preceding corrections should be performed in correct_raw.sql
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
event_date,
event_date_accuracy,
elevation_verbatim,
elevation_m,
slope_aspect_deg,
slope_gradient_deg,
plot_area_ha,
sampling_protocol,
temperature_c,
precip_mm,
stratum_name,
community_concept_name,
observation_contributors,
custodial_institution_codes,
collection_code,
catalog_number,
occurrence_id,
recorded_by,
record_number,
date_collected,
date_collected_accuracy,
identified_by,
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
cover_percent,
cites,
iucn,
usda_federal,
usda_state,
is_embargoed_observation,
geom,
nsr_id,
native_status_country,
native_status_state_province,
native_status_county_parish,
native_status,
native_status_reason,
native_status_sources,
isintroduced,
is_cultivated_in_region,
is_new
) 
SELECT
'specimen',
NULL,
NULL,
:'src',
:'src',
:'src',
'Chile',
"stateProvince",
"county",
NULL,
NULL,
NULL,
case
when "municipality" is not null and trim("municipality")<>'' then "municipality" || coalesce(', ',"locality") || coalesce(', ',"higherGeography")
else 
	case 
	when "locality" is not null and trim("locality")<>'' then "locality" || coalesce(', ',"higherGeography") 
	else "higherGeography" 
	end
end,
CONCAT_WS(', ',"decimalLatitude","decimalLongitude"),
case
when "decimalLatitude"='' then null
else cast("decimalLatitude" as numeric)
end,
case
when "decimalLongitude"='' then null
else cast("decimalLongitude" as numeric)
end,
"geodeticDatum",
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
when "yr" is null then NULL
when "yr" is not null and "mo" is null then cast(CONCAT_WS('-',"yr",'1','1') as date)
when "yr" is not null and "mo" is not null and "dy" is null then cast(CONCAT_WS('-',"yr","mo",'1') as date)
when "yr" is not null and "mo" is not null and "dy" is not null then cast(CONCAT_WS('-',"yr","mo","dy") as date)
else null
end,
case
when "yr" is not null and "mo" is null then 'year'
when "yr" is not null and "mo" is not null and "dy" is null then 'month'
when "yr" is not null and "mo" is not null and "dy" is not null then 'day'
else null
end,
"verbatimElevation",
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
"datasetName",
NULL,
"catalogNumber",
NULL,
case
when "recordedBy"='No data' then NULL
else "recordedBy"
end,
NULL,
case
when "yr" is null then NULL
when "yr" is not null and "mo" is null then cast(CONCAT_WS('-',"yr",'1','1') as date)
when "yr" is not null and "mo" is not null and "dy" is null then cast(CONCAT_WS('-',"yr","mo",'1') as date)
when "yr" is not null and "mo" is not null and "dy" is not null then cast(CONCAT_WS('-',"yr","mo","dy") as date)
else null
end,
case
when "yr" is not null and "mo" is null then 'year'
when "yr" is not null and "mo" is not null and "dy" is null then 'month'
when "yr" is not null and "mo" is not null and "dy" is not null then 'day'
else null
end,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
"Family",
"scientificName",
trim(concat_ws(' ',"Family","scientificName")),
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
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
CASE 
WHEN "individualCount"~E'^\\d+$' THEN "individualCount"::integer 
ELSE null 
END,
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
1
FROM chilesp_raw
;

