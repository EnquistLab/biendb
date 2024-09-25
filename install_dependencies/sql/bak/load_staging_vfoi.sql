
-- --------------------------------------------------------------
-- Insert raw data to staging table
-- 
-- NOTE: This script is source-specific
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
coord_uncertainty_m,
coord_uncertainty_verbatim,
coord_max_uncertainty_km,
georef_sources,
georef_protocol,
is_centroid,
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
identified_by,
date_identified,
identification_remarks,
bien_taxonomy_id,
taxon_id,
family_taxon_id,
genus_taxon_id,
species_taxon_id,
verbatim_family,
verbatim_scientific_name,
name_submitted,
fk_tnrs_user_id,
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
is_cultivated,
is_cultivated_basis,
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
case 
when "basisOfRecord"='PreservedSpecimen' then 'specimen'
when "basisOfRecord"='' then 'occurrence'
else "basisOfRecord"
end,
NULL,
NULL,
'ala',
'ala',
'ala',
"country",
"stateProvince",
"county",
NULL,
NULL,
NULL,
"locality",
"verbatimCoordinates",
case
when "decimalLatitude"='' then null
else cast("decimalLatitude" as double precision)
end,
case
when "decimalLongitude"='' then null
else cast("decimalLongitude" as double precision)
end,
case
when "coordinateUncertaintyInMeters"='' then -9999
else cast("coordinateUncertaintyInMeters" as double precision)
end,
"coordinateUncertaintyInMeters",
NULL,
case
when "georeferenceSources"='' then null
else "georeferenceSources"
end,
case
when "georeferenceProtocol"='' then null
else "georeferenceProtocol"
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
NULL,
NULL,
NULL,
NULL,
case
when "eventDate"='' then NULL
else cast("eventDate" as date)
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
NULL,
NULL,
"collectionCode",
"catalogNumber",
NULL,
"recordedBy",
"recordNumber",
case
when "eventDate"='' then NULL
else cast("eventDate" as date)
end,
"identifiedBy",
case
when "dateIdentified"='' then NULL
else cast("dateIdentified" as date)
end,
"identificationRemarks",
NULL,
NULL,
NULL,
NULL,
NULL,
"family",
"scientificName",
trim(concat_ws(' ',"family","scientificName")),
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
trim(concat_ws(' ', "habitat", "occurrenceRemarks")),
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
FROM ala_raw
;
