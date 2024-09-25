-- ---------------------------------------------------------
-- Populate bien_taxonomy_id, higher_plant_group and updated
-- scrubbed name results from table bien_taxonomy to table 
-- vfoi
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS view_full_occurrence_individual_temp;
ALTER TABLE view_full_occurrence_individual_dev RENAME TO view_full_occurrence_individual_temp;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

-- Create any indexes needed here:
DROP INDEX IF EXISTS vfoi_temp_name_submitted_idx;
CREATE INDEX vfoi_temp_name_submitted_idx ON view_full_occurrence_individual_temp (name_submitted);

--
-- Generate the new table from the temp copy, adding and populating 
-- new columns in the positions desired. Be sure to copy ALL 
-- existing columns in source table, in addition to new or updated
-- columns.
CREATE TABLE view_full_occurrence_individual_dev AS 
SELECT 
a.taxonobservation_id,
a.observation_type,
a.plot_metadata_id,
a.datasource_id,
a.datasource,
a.dataset,
a.dataowner,
a.country_verbatim,
a.state_province_verbatim,
a.county_verbatim,
a.poldiv_full,
a.fk_gnrs_id,
a.country,
a.state_province,
a.county,
a.locality,
a.latlong_verbatim,
a.latitude,
a.longitude,
a.geodeticdatum,
a.coord_uncertainty_m,
a.coord_uncertainty_verbatim,
a.coord_max_uncertainty_km,
a.georef_sources,
a.georef_protocol,
CAST(null AS smallint) as is_centroid,
CAST(null AS numeric) AS centroid_likelihood,
CAST(null AS text) AS centroid_poldiv,
CAST(null AS text) AS centroid_type,
a.is_in_country,
a.is_in_state_province,
a.is_in_county,
a.is_geovalid,
a.is_new_world,
a.project_id,
a.project_contributors,
a.location_id,
a.plot_name,
a.subplot,
a.is_location_cultivated,
a.locationevent_id,
a.event_date_verbatim,
a.event_date,
a.event_date_accuracy,
a.elevation_verbatim,
a.elevation_m,
a.elevation_min_m,
a.elevation_max_m,
a.slope_aspect_deg,
a.slope_gradient_deg,
a.plot_area_ha,
a.sampling_protocol,
a.temperature_c,
a.precip_mm,
a.stratum_name,
a.vegetation_verbatim,
a.community_concept_name,
a.observation_contributors,
a.custodial_institution_codes,
a.collection_code,
a.catalog_number,
a.occurrence_id,
a.recorded_by,
a.record_number,
a.date_collected_verbatim,
a.date_collected,
a.date_collected_accuracy,
a.identified_by,
a.date_identified_verbatim,
a.date_identified,
a.date_identified_accuracy,
a.identification_remarks,
c.bien_taxonomy_id,
c.taxon_id,
c.family_taxon_id,
c.genus_taxon_id,
c.species_taxon_id,
a.verbatim_family,
a.verbatim_scientific_name,
b.name_submitted,
b.tnrs_id AS fk_tnrs_id,
b.family_matched,
b.name_matched,
b.name_matched_author,
b.tnrs_name_matched_score,
b.tnrs_warning,
b.matched_taxonomic_status,
b.tnrs_match_summary AS match_summary,
b.scrubbed_taxonomic_status,
c.higher_plant_group,
b.scrubbed_family,
b.scrubbed_genus,
b.scrubbed_specific_epithet,
b.scrubbed_species_binomial,
b.scrubbed_taxon_name_no_author,
b.scrubbed_taxon_canonical,
b.scrubbed_author,
b.scrubbed_taxon_name_with_author,
b.scrubbed_species_binomial_with_morphospecies,
a.growth_form,
a.reproductive_condition,
a.occurrence_remarks,
a.taxon_observation_id,
a.taxon_name_usage_concept_author_code,
a.plantobservation_id,
a.aggregate_organism_observation_id,
a.individual_organism_observation_id,
a.individual_id,
a.individual_count,
a.stem_height_m,
a.cover_percent,
a.cites,
a.iucn,
a.usda_federal,
a.usda_state,
a.is_embargoed_observation,
a.geom,
a.nsr_id,
a.native_status_country,
a.native_status_state_province,
a.native_status_county_parish,
a.native_status,
a.native_status_reason,
a.native_status_sources,
a.isintroduced,
a.is_cultivated_in_region,
a.is_cultivated_taxon,
a.is_cultivated_observation,
a.is_cultivated_observation_basis,
a.citation_verbatim,
a.citation,
a.is_new
FROM view_full_occurrence_individual_temp a LEFT JOIN tnrs b 
ON a.name_submitted=b.name_submitted_verbatim
LEFT JOIN bien_taxonomy c
ON b.bien_taxonomy_id=c.bien_taxonomy_id
;

-- Drop the temp table
DROP TABLE IF EXISTS view_full_occurrence_individual_temp;

COMMIT;