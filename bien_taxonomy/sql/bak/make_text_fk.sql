-- ----------------
-- Adds bien_taxonomy FK columns and populates text FK
-- 
-- Regenerates entire table using CREATE TABLE AS to
-- avoid memory overload
-- ----------------

SET search_path TO :dev_schema;

BEGIN;

ALTER TABLE view_full_occurrence_individual_dev 
RENAME TO view_full_occurrence_individual_temp;

-- Possibly adjust work_mem, but research carefully
-- SET LOCAL work_mem = '1000 MB';  -- just for this transaction

--
-- Add & populate temporary text FK
-- 
DROP TABLE IF EXISTS view_full_occurrence_individual_dev;
CREATE TABLE view_full_occurrence_individual_dev AS 
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
identified_by,
date_identified,
identification_remarks,
bien_taxonomy_id,
verbatim_family,
verbatim_scientific_name,
name_submitted,
family_matched,
name_matched,
name_matched_author,
tnrs_warning,
matched_taxonomic_status,
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
scrubbed_taxonomic_status,
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
CAST(
CONCAT_WS('@',
COALESCE(higher_plant_group,''),
COALESCE(scrubbed_family,''), 
COALESCE(scrubbed_genus,''),
COALESCE(scrubbed_species_binomial,''),
COALESCE(scrubbed_taxon_name_no_author,''),
COALESCE(scrubbed_author,''),
COALESCE(scrubbed_species_binomial_with_morphospecies,'')
)
AS TEXT) AS bien_taxonomy_id_txt
FROM view_full_occurrence_individual_temp
;

DROP TABLE IF EXISTS view_full_occurrence_individual_temp;

-- Index the text FK so we can join on it
DROP INDEX IF EXISTS vfoi_dev_bien_taxonomy_id_txt_idx;
CREATE INDEX vfoi_dev_bien_taxonomy_id_txt_idx ON view_full_occurrence_individual_dev(bien_taxonomy_id_txt);

-- Commit & release share lock on original table
COMMIT;