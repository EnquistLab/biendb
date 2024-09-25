-- ---------------------------------------------------------
-- Applies locality embargoes to endangered species in table
-- vfoi
-- ---------------------------------------------------------

-- SET search_path TO public_vegbien_dev;
SET search_path TO public_vegbien_dev;

BEGIN;

ALTER TABLE view_full_occurrence_individual_dev RENAME TO view_full_occurrence_individual_dev_temp;

-- Adjust work_mem, but research carefully
-- SET LOCAL work_mem = '500 MB';  -- just for this transaction

-- Generate the first temp table, adding and populating the
-- new columns in position desired. Be sure to copy ALL 
-- existing columns in source table, unless you want to remove
-- one or more columns
-- 'is_infraspecific' is temporary, needed for subsequent steps,
-- will be removed at end
DROP TABLE IF EXISTS public_vegbien_dev.view_full_occurrence_individual_dev;
CREATE TABLE public_vegbien_dev.view_full_occurrence_individual_dev AS 
SELECT 
taxonobservation_id,
observation_type,
plot_metadata_id,
datasource_id,
datasource,
dataset,
dataowner,
country,
state_province,
county,
CASE
WHEN is_embargoed_observation=1 THEN '[Locality information hidden to protect endangered species]'
ELSE locality
END,
CASE
WHEN is_embargoed_observation=1 THEN NULL
ELSE longitude
END,
CASE
WHEN is_embargoed_observation=1 THEN NULL
ELSE latitude
END,
coord_uncertainty_m,
georef_sources,
georef_protocol,
is_geovalid,
is_new_world,
project_id,
project_contributors,
CASE
WHEN is_embargoed_observation=1 THEN NULL
ELSE location_id
END,
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
CASE
WHEN is_embargoed_observation=1 THEN NULL
ELSE occurrence_id
END,
recorded_by,
record_number,
date_collected,
bien_taxonomy_id,
verbatim_family,
verbatim_scientific_name,
identified_by,
date_identified,
identification_remarks,
family_matched,
name_matched,
name_matched_author,
higher_plant_group,
taxonomic_status,
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
CASE
WHEN is_embargoed_observation=1 THEN '[Information hidden to protect endangered species]'
ELSE occurrence_remarks
END,
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
is_cultivated_in_region
FROM view_full_occurrence_individual_dev_temp
;

DROP TABLE view_full_occurrence_individual_dev_temp;

-- Commit & release share lock on original table
COMMIT;
