-- ---------------------------------------------------------
-- Applies locality embargoes to endangered species in table
-- vfoi
-- ---------------------------------------------------------

SET search_path TO :sch;

BEGIN;

ALTER TABLE :sch.view_full_occurrence_individual RENAME TO view_full_occurrence_individual_temp;

-- Adjust work_mem, but research carefully
-- SET LOCAL work_mem = '500 MB';  -- just for this transaction

-- Generate the first temp table, adding and populating the
-- new columns in position desired. Be sure to copy ALL 
-- existing columns in source table, unless you want to remove
-- one or more columns
-- 'is_infraspecific' is temporary, needed for subsequent steps,
-- will be removed at end
DROP TABLE IF EXISTS :sch.view_full_occurrence_individual;
CREATE TABLE :sch.view_full_occurrence_individual AS 
SELECT 
taxonobservation_id,
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
CASE
WHEN is_embargoed_observation='1' THEN '[Locality information hidden to protect endangered species]'
ELSE locality
END
AS locality,
CASE
WHEN is_embargoed_observation='1' THEN '[hidden]'
ELSE latlong_verbatim
END
AS latlong_verbatim,
CASE
WHEN is_embargoed_observation='1' THEN NULL
ELSE latitude
END
AS latitude,
CASE
WHEN is_embargoed_observation='1' THEN NULL
ELSE longitude
END
AS longitude,
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
CASE
WHEN is_embargoed_observation='1' THEN NULL
ELSE location_id
END
AS location_id,
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
CASE
WHEN is_embargoed_observation='1' THEN NULL
ELSE occurrence_id
END
AS occurrence_id,
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
CASE
WHEN is_embargoed_observation='1' THEN '[Information hidden to protect endangered species]'
ELSE occurrence_remarks
END
AS occurrence_remarks,
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
is_introduced,
is_cultivated_in_region,
is_cultivated_taxon,
is_cultivated_observation,
is_cultivated_observation_basis,
citation_verbatim,
citation
FROM view_full_occurrence_individual_temp
;

DROP TABLE view_full_occurrence_individual_temp;

-- Commit & release share lock on original table
COMMIT;
