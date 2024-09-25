-- ---------------------
-- Regenerate table again, adding and 
-- populating the second (integer) FK
-- ---------------------

SET search_path = :dev_schema;

ALTER TABLE view_full_occurrence_individual_dev
RENAME TO view_full_occurrence_individual_temp;

-- Note:
-- 1. Use of LEFT JOIN
-- 2. All fields come from vfoi_dev (table a), with
-- the exception of the integer FK ("b.bien_taxonomy_id")
-- 3. Text FK is omitted from final table
CREATE TABLE view_full_occurrence_individual_dev AS 
SELECT 
a.taxonobservation_id,
a.observation_type,
a.plot_metadata_id,
a.datasource_id,
a.datasource,
a.dataset,
a.dataowner,
a.country,
a.state_province,
a.county,
a.locality,
a.latitude,
a.longitude,
a.coord_uncertainty_m,
a.georef_sources,
a.georef_protocol,
a.is_geovalid,
a.is_new_world,
a.project_id,
a.project_contributors,
a.location_id,
a.plot_name,
a.subplot,
a.is_location_cultivated,
a.locationevent_id,
a.event_date,
a.elevation_m,
a.slope_aspect_deg,
a.slope_gradient_deg,
a.plot_area_ha,
a.sampling_protocol,
a.temperature_c,
a.precip_mm,
a.stratum_name,
a.community_concept_name,
a.observation_contributors,
a.custodial_institution_codes,
a.collection_code,
a.catalog_number,
a.occurrence_id,
a.recorded_by,
a.record_number,
a.date_collected,
a.identified_by,
a.date_identified,
a.identification_remarks,
b.bien_taxonomy_id,
a.verbatim_family,
a.verbatim_scientific_name,
a.name_submitted,
a.family_matched,
a.name_matched,
a.name_matched_author,
a.tnrs_warning,
a.matched_taxonomic_status,
a.higher_plant_group,
a.scrubbed_family,
a.scrubbed_genus,
a.scrubbed_specific_epithet,
a.scrubbed_species_binomial,
a.scrubbed_taxon_name_no_author,
a.scrubbed_taxon_canonical,
a.scrubbed_author,
a.scrubbed_taxon_name_with_author,
a.scrubbed_species_binomial_with_morphospecies,
a.scrubbed_taxonomic_status,
a.growth_form,
a.reproductive_condition,
a.is_cultivated,
a.is_cultivated_basis,
a.occurrence_remarks,
a.taxon_observation_id,
a.taxon_name_usage_concept_author_code,
a.plantobservation_id,
a.aggregate_organism_observation_id,
a.individual_organism_observation_id,
a.individual_id,
a.individual_count,
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
a.is_cultivated_in_region
FROM view_full_occurrence_individual_temp a LEFT JOIN bien_taxonomy_dev b
ON a.bien_taxonomy_id_txt=b.bien_taxonomy_id_txt
;

-- Drop the temp table
DROP TABLE IF EXISTS view_full_occurrence_individual_temp;