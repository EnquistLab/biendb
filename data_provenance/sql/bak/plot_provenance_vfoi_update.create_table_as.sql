-- 
-- Transfer plot datasource info back to vfoi
-- 

-- This version uses 'CREATE TABLE AS' method

BEGIN;

SET search_path TO public_vegbien_dev;

LOCK TABLE view_full_occurrence_individual_temp IN SHARE MODE;


DROP TABLE IF EXISTS vfoi_dev;
CREATE TABLE vfoi_dev AS 
SELECT
taxonobservation_id,
observation_type,
a.datasource,
CASE
WHEN a.dataset IS NULL OR TRIM(a.dataset)='' THEN b.dataset
ELSE a.dataset
END,
CASE
WHEN a.dataowner IS NULL OR TRIM(a.dataowner)='' THEN b.primary_dataowner
ELSE a.dataowner
END,
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
a.plot_name,
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
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
scrubbed_author,
scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies,
growth_form,
reproductive_condition,
is_cultivated,
is_cultivated_basis,
occurrence_remarks,
cover_percent,
taxon_observation_id,
taxon_name_usage_concept_author_code,
aggregate_organism_observation_id,
individual_organism_observation_id,
individual_id,
individual_count,
plantobservation_id,
cites,
geom,
native_status_country,
native_status_state_province,
native_status_county_parish,
native_status,
native_status_reason,
native_status_sources,
isintroduced,
is_cultivated_in_region,
nsr_id
FROM vfoi_test AS a LEFT JOIN plot_provenance AS b
ON a.datasource=b.datasource AND a.plot_name=b.plot_name
;

COMMIT;