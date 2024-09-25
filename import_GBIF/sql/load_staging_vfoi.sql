-- --------------------------------------------------------------
-- Insert raw data to staging table
-- --------------------------------------------------------------

SET search_path TO :sch;

-- Insert the records
-- Note filtering criteria in WHERE clause
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
poldiv_full,
fk_gnrs_id,
country,
state_province,
county,
locality,
latlong_verbatim,
latitude,
longitude,
geodeticdatum,
coord_uncertainty_m,
coord_uncertainty_verbatim,
coord_max_uncertainty_km,
georef_sources,
georef_protocol,
fk_centroid_id,
is_centroid,
centroid_likelihood,
centroid_poldiv,
centroid_type,
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
match_summary,
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
nsr_id,
native_status_country,
native_status_state_province,
native_status_county_parish,
native_status,
native_status_reason,
native_status_sources,
isintroduced,
is_cultivated_in_region,
is_cultivated_taxon,
is_cultivated_observation,
is_cultivated_observation_basis,
citation_verbatim,
citation,
is_new,
fk_vfoi_staging_id,
datasource_staging_id
) 
SELECT
CASE
WHEN "basisOfRecord"='HUMAN_OBSERVATION' THEN 'human observation'
WHEN "basisOfRecord"='LITERATURE' THEN 'literature'
WHEN "basisOfRecord"='MATERIAL_SAMPLE' THEN 'material sample'
WHEN "basisOfRecord"='OBSERVATION' THEN 'unknown'
WHEN "basisOfRecord"='PRESERVED_SPECIMEN' THEN 'specimen'
WHEN "basisOfRecord" IS NULL THEN 'unknown'
ELSE 'unknown'
END,
NULL,
NULL,
:'src',
CASE
WHEN "institutionCode" IS NULL OR "institutionCode"='' THEN '[unknown]'
ELSE "institutionCode"
END,
CASE
WHEN "institutionCode" IS NULL OR "institutionCode"='' THEN '[unknown]'
ELSE "institutionCode"
END,
"countryCode",
"stateProvince",
"county",
NULL,
NULL,
NULL,
NULL,
NULL,
CASE
WHEN "locality"="verbatimLocality" THEN TRIM(CONCAT_WS(' ', "locality", "locationRemarks"))
ELSE TRIM(CONCAT_WS(' ', "locality", "verbatimLocality", "locationRemarks"))
END,
TRIM(CONCAT_WS(', ', "decimalLatitude", "decimalLongitude")),
CASE
WHEN public.is_numeric("decimalLatitude") THEN "decimalLatitude"::numeric
ELSE NULL
END,
CASE
WHEN public.is_numeric("decimalLongitude") THEN "decimalLongitude"::numeric
ELSE NULL
END,
NULL,
CASE
WHEN public.is_numeric("coordinateUncertaintyInMeters") THEN "coordinateUncertaintyInMeters"::double precision
ELSE NULL
END,
CASE
WHEN public.is_numeric("coordinateUncertaintyInMeters") THEN "coordinateUncertaintyInMeters"::double precision
ELSE NULL
END,
NULL,
"georeferenceSources",
"georeferenceProtocol",
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
WHEN "establishmentMeans"='MANAGED' THEN true
WHEN "establishmentMeans"='NATIVE' THEN false
ELSE NULL
END,
NULL,
"eventDate",
CASE
WHEN "eventdate_yr" IS NULL THEN NULL
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NULL THEN cast(CONCAT_WS('-',"eventdate_yr",'1','1') AS date)
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NOT NULL AND "eventdate_dy" IS NULL THEN cast(CONCAT_WS('-',"eventdate_yr","eventdate_mo",'1') AS date)
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NOT NULL AND "eventdate_dy" IS NOT NULL THEN cast(CONCAT_WS('-',"eventdate_yr","eventdate_mo","eventdate_dy") AS date)
ELSE NULL
END,
CASE
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NULL THEN 'year'
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NOT NULL AND "eventdate_dy" IS NULL THEN 'month'
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NOT NULL AND "eventdate_dy" IS NOT NULL THEN 'day'
ELSE NULL
END,
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
habitat,
NULL,
NULL,
"institutionCode",
"collectionCode",
"gbifID",
NULL,
"recordedBy",
"recordNumber",
"eventDate",
CASE
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NULL THEN cast(CONCAT_WS('-',"eventdate_yr",'1','1') AS date)
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NOT NULL AND "eventdate_dy" IS NULL THEN cast(CONCAT_WS('-',"eventdate_yr","eventdate_mo",'1') AS date)
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NOT NULL AND "eventdate_dy" IS NOT NULL THEN cast(CONCAT_WS('-',"eventdate_yr","eventdate_mo","eventdate_dy") AS date)
ELSE NULL
END,
CASE
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NULL THEN 'year'
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NOT NULL AND "eventdate_dy" IS NULL THEN 'month'
WHEN "eventdate_yr" IS NOT NULL AND "eventdate_mo" IS NOT NULL AND "eventdate_dy" IS NOT NULL THEN 'day'
ELSE NULL
END,
"identifiedBy",
"dateIdentified",
CASE
WHEN "dateidentified_yr" IS NOT NULL AND "dateidentified_mo" IS NULL THEN cast(CONCAT_WS('-',"dateidentified_yr",'1','1') AS date)
WHEN "dateidentified_yr" IS NOT NULL AND "dateidentified_mo" IS NOT NULL AND "dateidentified_dy" IS NULL THEN cast(CONCAT_WS('-',"dateidentified_yr","dateidentified_mo",'1') AS date)
WHEN "dateidentified_yr" IS NOT NULL AND "dateidentified_mo" IS NOT NULL AND "dateidentified_dy" IS NOT NULL THEN cast(CONCAT_WS('-',"dateidentified_yr","dateidentified_mo","dateidentified_dy") AS date)
ELSE NULL
END,
CASE
WHEN "dateidentified_yr" IS NOT NULL AND "dateidentified_mo" IS NULL THEN 'year'
WHEN "dateidentified_yr" IS NOT NULL AND "dateidentified_mo" IS NOT NULL AND "dateidentified_dy" IS NULL THEN 'month'
WHEN "dateidentified_yr" IS NOT NULL AND "dateidentified_mo" IS NOT NULL AND "dateidentified_dy" IS NOT NULL THEN 'day'
ELSE NULL
END,
"identificationRemarks",
NULL,
NULL,
NULL,
NULL,
NULL,
"family",
"scientificName",
CASE
WHEN "identificationQualifier" IS NULL OR "identificationQualifier"='' THEN TRIM(CONCAT_WS(' ', "family", "scientificName"))
ELSE TRIM(CONCAT("family", ' ', "scientificName", ' -', "identificationQualifier"))
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
NULL,
NULL,
NULL,
NULL,
TRIM(CONCAT_WS(' ', "sex", "lifeStage", "reproductiveCondition")),
TRIM(CONCAT_WS(' ', "occurrenceRemarks", "fieldNotes", "eventRemarks")),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
CASE 
WHEN "individualCount"~E'^\\d+$' THEN "individualCount"::integer 
ELSE NULL 
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
NULL,
NULL,
CASE 
WHEN "establishmentMeans"='MANAGED' THEN 1
WHEN "establishmentMeans"='NATIVE' THEN 0
ELSE NULL
END,
CASE 
WHEN "establishmentMeans"='MANAGED' THEN 'establishmentMeans=MANAGED in GBIF'
WHEN "establishmentMeans"='NATIVE' THEN 'establishmentMeans=NATIVE in GBIF'
ELSE NULL
END,
NULL,
NULL,
1,
NULL,
NULL
FROM :"tbl_raw"
WHERE "basisOfRecord" NOT IN (
'FOSSIL_SPECIMEN',
'LIVING_SPECIMEN',
'MACHINE_OBSERVATION'
)
AND "institutionCode"<>'SIVIM'
AND "institutionCode" NOT IN (
:psrc_list
)
;
