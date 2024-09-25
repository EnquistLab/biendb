-- ---------------------------------------------------------
-- Populate nsr columns in vfoi_dev
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

-- Build indexes needed to populate observation_type
CREATE INDEX vfoi_taxonobservation_id_idx ON view_full_occurrence_individual_dev USING btree (taxonobservation_id)
;
DROP INDEX IF EXISTS nsr_user_id_idx;
CREATE INDEX nsr_user_id_idx ON nsr USING btree (user_id)
;

-- Fix erroneous literal text values of NULL
UPDATE nsr
SET isintroduced=NULL
WHERE isintroduced='NULL';

-- Wrap the rest in a transaction to be safe
BEGIN;

ALTER TABLE view_full_occurrence_individual_dev 
RENAME TO view_full_occurrence_individual_temp;

-- Possibly adjust work_mem, but research carefully
-- SET LOCAL work_mem = '1000 MB';  -- just for this transaction

-- Note left join
DROP TABLE IF EXISTS view_full_occurrence_individual_dev;
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
a.bien_taxonomy_id,
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
b.id AS nsr_id,
b.native_status_country,
b.native_status_state_province,
b.native_status_county_parish,
b.native_status,
b.native_status_reason,
b.native_status_sources,
CAST(b.isintroduced AS INTEGER) AS isintroduced,
CAST(b.iscultivatednsr AS INTEGER) AS is_cultivated_in_region
FROM view_full_occurrence_individual_temp a LEFT JOIN nsr b
ON a.taxonobservation_id=b.user_id
;

DROP TABLE IF EXISTS view_full_occurrence_individual_temp;

COMMIT;
