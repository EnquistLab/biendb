-- ---------------------------------------------------------
-- Copies table vfoi, populating columns dataset and dataowner  
-- with the herbarium code if the observation is a specimen,  
-- otherwise leaves null. Columns plot_name and subplot are
-- populated only if observation_type='plot'. This removes  
-- the GBIF specimen records erroneously added as plots. 
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :dev_schema;

ALTER TABLE view_full_occurrence_individual_dev RENAME TO view_full_occurrence_individual_temp;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

CREATE INDEX vfoi_temp_observation_type_idx ON view_full_occurrence_individual_temp(observation_type);
CREATE INDEX vfoi_temp_datasource_idx ON view_full_occurrence_individual_temp(datasource);

--
-- Generate the first temp table, adding and populating the
-- new column in position desired. Be sure to copy ALL 
-- existing columns in source table!
-- 
CREATE TABLE view_full_occurrence_individual_dev AS 
SELECT 
taxonobservation_id,
observation_type,
plot_metadata_id,
datasource_id,
datasource,
CAST(CASE WHEN observation_type='specimen' THEN custodial_institution_codes WHEN observation_type='plot' AND (datasource='FIA' OR datasource='NVS') THEN datasource ELSE NULL END AS TEXT) AS dataset,
CAST(CASE WHEN observation_type='specimen' THEN custodial_institution_codes WHEN observation_type='plot' AND (datasource='FIA' OR datasource='NVS') THEN datasource ELSE NULL END AS TEXT) AS dataowner,
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
CAST(CASE WHEN observation_type='plot' THEN plot_name ELSE NULL END AS TEXT) AS plot_name,
CAST(CASE WHEN observation_type='plot' THEN subplot ELSE NULL END AS TEXT) AS subplot,
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
is_new
FROM view_full_occurrence_individual_temp
;

-- Drop temporary indexes and table
DROP INDEX vfoi_temp_observation_type_idx ;
DROP INDEX vfoi_temp_datasource_idx;
DROP TABLE view_full_occurrence_individual_temp;

-- Commit & release share lock on original table
COMMIT;