
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
'specimen',
NULL,
NULL,
:'src',
:'src',
:'src',
"country",
"stateProvince",
NULL,
NULL,
NULL,
NULL,
trim(concat_ws(' ',"locality","d_locnotes","d_habitat")),
CONCAT_WS(' ',"decimalLatitude","decimalLatitude"),
case
when "decimalLatitude"='' then null
else cast("decimalLatitude" as double precision)
end,
case
when "decimalLongitude"='' then null
else cast("decimalLongitude" as double precision)
end,
NULL,
NULL,
accuracy,
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
when "col_yr" is null then NULL
when "col_yr" is not null and "col_mo" is null then cast(CONCAT_WS('-',"col_yr",'1','1') as date)
when "col_yr" is not null and "col_mo" is not null and "col_dy" is null then cast(CONCAT_WS('-',"col_yr","col_mo",'1') as date)
when "col_yr" is not null and "col_mo" is not null and "col_dy" is not null then cast(CONCAT_WS('-',"col_yr","col_mo","col_dy") as date)
else null
end,
case
when "col_yr" is not null and "col_mo" is null then 'year'
when "col_yr" is not null and "col_mo" is not null and "col_dy" is null then 'month'
when "col_yr" is not null and "col_mo" is not null and "col_dy" is not null then 'day'
else null
end,
case
when alt='NA' THEN null
else cast(alt as double precision)
end,
case
when alt='NA' THEN null
else cast(alt as double precision)
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
"dups",
NULL,
"catalogNumber",
NULL,
"colnam",
concat_ws('',"prefix","nbr","suffix"),
case
when "col_yr" is null then NULL
when "col_yr" is not null and "col_mo" is null then cast(CONCAT_WS('-',"col_yr",'1','1') as date)
when "col_yr" is not null and "col_mo" is not null and "col_dy" is null then cast(CONCAT_WS('-',"col_yr","col_mo",'1') as date)
when "col_yr" is not null and "col_mo" is not null and "col_dy" is not null then cast(CONCAT_WS('-',"col_yr","col_mo","col_dy") as date)
else null
end,
case
when "col_yr" is not null and "col_mo" is null then 'year'
when "col_yr" is not null and "col_mo" is not null and "col_dy" is null then 'month'
when "col_yr" is not null and "col_mo" is not null and "col_dy" is not null then 'day'
else null
end,
"d_detnam",
case
when "det_yr" is null then NULL
when "det_yr" is not null and "det_mo" is null then cast(CONCAT_WS('-',"det_yr",'1','1') as date)
when "det_yr" is not null and "det_mo" is not null and "det_dy" is null then cast(CONCAT_WS('-',"det_yr","det_mo",'1') as date)
when "det_yr" is not null and "det_mo" is not null and "det_dy" is not null then cast(CONCAT_WS('-',"det_yr","det_mo","det_dy") as date)
else null
end,
case
when "det_yr" is not null and "det_mo" is null then 'year'
when "det_yr" is not null and "det_mo" is not null and "det_dy" is null then 'month'
when "det_yr" is not null and "det_mo" is not null and "det_dy" is not null then 'day'
else null
end,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
"family",
"tax_tax",
trim(concat_ws(' ',"family","tax_tax")),
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
"a_habit",
case
when "d_pheno_fl" is not null and trim("d_pheno_fl")<>'' and "d_pheno_fr" is not null and trim("d_pheno_fr")<>'' then 
concat_ws(' ',
coalesce('d_pheno_fl: ',"d_pheno_fl"),
coalesce('d_pheno_fr: ',"d_pheno_fr")
)
when "d_pheno_fl" is not null and trim("d_pheno_fl")<>'' and ("d_pheno_fr" is null or trim("d_pheno_fr")='') then 
concat_ws(' ',coalesce('d_pheno_fl: ',"d_pheno_fl"))
when ("d_pheno_fl" is null or trim("d_pheno_fl")='') and "d_pheno_fr" is not null and trim("d_pheno_fr")<>'' then 
concat_ws(' ',coalesce('d_pheno_fr: ',"d_pheno_fr"))
else null
end,
case
when "a_cultivated"='f' then 0
when "a_cultivated"='t' then 1
else null
end,
case
when "a_cultivated"='f' then 'Source database'
when "a_cultivated"='t' then 'Source database'
else null
end,
"d_description",
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
1
FROM :"tbl"
;

