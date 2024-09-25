-- ---------------------------------------------------------
-- Copy table from core schema to development schema,
-- omitting unused columns, adding new columns & reordering
-- existing columns. New columns are empty placeholders; they 
-- will be re-created and populated in later "CREATE TABLE AS"
-- operations
-- ---------------------------------------------------------

\c public_vegbien

-- SET search_path TO public_vegbien_dev;
SET search_path TO public_vegbien_dev;

BEGIN;

LOCK TABLE public.view_full_occurrence_individual IN SHARE MODE;

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
locality,
latitude,
longitude,
coord_uncertainty_m,
georef_sources,
georef_protocol,
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
CAST(
CASE
WHEN scrubbed_species_binomial IS NOT NULL AND scrubbed_species_binomial<>scrubbed_taxon_name_no_author THEN 1
ELSE 0
END
AS INTEGER) AS is_infraspecific,
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
CAST(scrubbed_taxon_name_no_author AS TEXT) AS scrubbed_taxon_canonical,
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
CAST(NULL AS TEXT) AS cites,
CAST(NULL AS TEXT) AS iucn,
CAST(NULL AS TEXT) AS usda_federal,
CAST(NULL AS TEXT) AS usda_state,
CAST(0 AS INTEGER) AS is_embargoed_observation,
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
FROM public.view_full_occurrence_individual
;

-- Commit & release share lock on original table
COMMIT;
