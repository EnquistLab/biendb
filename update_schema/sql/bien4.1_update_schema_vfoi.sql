-- ---------------------------------------------------------
-- Update schema of view_full_occurrence_individual, 
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :sch;

DROP TABLE IF EXISTS view_full_occurrence_individual_temp;
ALTER TABLE view_full_occurrence_individual RENAME TO view_full_occurrence_individual_temp;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

--
-- Create indexes as needed
--

DROP INDEX IF EXISTS centroid_tbl_idx;
CREATE INDEX centroid_tbl_idx ON centroid (tbl);
DROP INDEX IF EXISTS centroid_tbl_id_idx;
CREATE INDEX centroid_tbl_id_idx ON centroid (tbl_id);

-- Primary key
ALTER TABLE view_full_occurrence_individual_temp DROP CONSTRAINT IF EXISTS view_full_occurrence_individual_temp_pkey;
ALTER TABLE view_full_occurrence_individual_temp ADD PRIMARY KEY (taxonobservation_id);

--
-- Generate the new table from the temp copy, adding and populating 
-- new columns in the positions desired. Be sure to copy ALL 
-- existing columns in source table, in addition to new or updated
-- columns.
-- 
CREATE TABLE view_full_occurrence_individual AS 
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
c.continent,
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
b.centroid_id AS fk_centroid_id,
b.is_centroid,
b.centroid_dist_relative,
b.centroid_poldiv,
b.centroid_type,
b.centroid_max_uncertainty,
a.is_in_country,
a.is_in_state_province,
a.is_in_county,
CASE
WHEN a.latitude IS NULL OR a.longitude IS NULL THEN '0'
WHEN abs(a.latitude)>90 OR abs(a.longitude)>180 THEN '0'
ELSE a.is_geovalid
END
AS is_geovalid,
CASE
WHEN a.latitude IS NULL OR a.longitude IS NULL THEN 'Missing lat/long'
WHEN abs(a.latitude)>90 OR abs(a.longitude)>180 THEN 'Impossible lat/long'
ELSE NULL
END
AS is_geovalid_issue,
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
a.bien_taxonomy_id,
a.taxon_id,
a.family_taxon_id,
a.genus_taxon_id,
a.species_taxon_id,
a.verbatim_family,
a.verbatim_scientific_name,
a.name_submitted,
a.fk_tnrs_id,
a.family_matched,
a.name_matched,
a.name_matched_author,
a.tnrs_name_matched_score,
a.tnrs_warning,
a.matched_taxonomic_status,
a.match_summary,
a.scrubbed_taxonomic_status,
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
a.is_introduced,
a.is_cultivated_in_region,
a.is_cultivated_taxon,
a.is_cultivated_observation,
a.is_cultivated_observation_basis,
a.citation_verbatim,
a.citation
FROM view_full_occurrence_individual_temp a 
LEFT JOIN (
SELECT * FROM centroid 
WHERE tbl='vfoi'
) b
ON a.taxonobservation_id=b.tbl_id 
LEFT JOIN country c
ON a.country=c.country
;

-- Drop the temp table
-- DROP TABLE IF EXISTS view_full_occurrence_individual_temp;

COMMIT;