
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
citation_verbatim,
citation,
is_new
) 
SELECT
'plot occurrence',
NULL,
NULL,
:'src',
:'src',
:'src',
"Country",
NULL,
NULL,
NULL,
NULL,
NULL,
"Location",
CONCAT_WS(', ',"Latitude","Longitude"),
case
when "Latitude"='' then null
else cast("Latitude" as numeric)
end,
case
when "Longitude"='' then null
else cast("Longitude" as numeric)
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
0,
NULL,
NULL,
NULL,
case
when "plot_ID"='NA' then null
else "plot_ID"
end,
NULL,
NULL,
NULL,
case
when "Year"='NA' or "Year" is null  or trim("Year")='' then NULL
else CAST(CONCAT_WS('-',"Year",'-1-1') AS date)
end,
case
when "Year"='NA' or "Year" is null  or trim("Year")='' then NULL
else 'year'
end,
"ALT_m",
case
when "ALT_m"='NA' or "ALT_m"=null or trim("ALT_m")='' THEN null
WHEN "ALT_m" LIKE '%-%' THEN CAST( 
( (split_part("ALT_m",'-',1)::numeric + split_part("ALT_m",'-',2)::numeric) / 2 ) 
AS numeric)
else cast("ALT_m" as numeric)
end,
case
WHEN "ALT_m" LIKE '%-%' THEN split_part("ALT_m",'-',1)::numeric
else NULL
end,
case
WHEN "ALT_m" LIKE '%-%' THEN split_part("ALT_m",'-',2)::numeric
else NULL
end,
NULL,
NULL,
NULL,
'see reference details in columns citation & citation_verbatim',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
"RowPlotDB",
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
"species",
"species",
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
'Schepaschenko, D., A. Shvidenko, V. A. Usoltsev, P. Lakyda, Y. Luo, R. Vasylyshyn, I. Lakyda, Y. Myklush, L. See, I. McCallum, S. Fritz, F. Kraxner, and M. Obersteiner. 2017. A database of forest biomass structure for Eurasia. PANGAEA. doi:10.1594/PANGAEA.871492',
'@misc{schepaschenko2017adof,
abstract = {The most comprehensive database of in situ destructive sampling measurements of forest biomass in Eurasia have been compiled from a combination of experiments undertaken by the authors and from scientific publications. Biomass is reported as five components: live trees (stem, bark, branches, foliage, roots); understory (above- and below ground); green forest floor (above- and below ground); and coarse woody debris (snags, logs, dead branches of living trees and dead roots), consisting of ca 10300 unique records of sample plots and ca 9600 sample trees from ca 1200 experiments for the period 1930-2014. Some components are better represented than others, e.g. stem wood compared to roots. The database also contains other forest stand parameters such as tree species composition, average age, tree height, growing stock volume, etc., when available. Such a database can be used for the development of models of biomass structure, biomass extension factors, the calibration of remotely sensed data, change detection in biomass structure, and the assessment of carbon pool and its dynamics, among many others.},
annote = {Supplement to: Schepaschenko, D et al. (2017): A dataset of forest biomass structure for Eurasia. Scientific Data, 4, 170070, https://doi.org/10.1038/sdata.2017.70},
author = {Schepaschenko, Dmitry and Shvidenko, Anatoly and Usoltsev, Vladimir A and Lakyda, Petro and Luo, Yunjian and Vasylyshyn, Roman and Lakyda, Ivan and Myklush, Yuriy and See, Linda and McCallum, Ian and Fritz, Steffen and Kraxner, Florian and Obersteiner, Michael},
doi = {10.1594/PANGAEA.871492},
publisher = {PANGAEA},
title = {{A database of forest biomass structure for Eurasia}},
type = {data set},
url = {https://doi.org/10.1594/PANGAEA.871492},
year = {2017}
}
',
1
FROM :"tbl"
:limit
;

