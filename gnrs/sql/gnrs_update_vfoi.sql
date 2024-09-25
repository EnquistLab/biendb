-- ---------------------------------------------------------
-- Update starndard political division columns in table vfoi 
-- with results of GNRS validations
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :sch;

DROP TABLE IF EXISTS view_full_occurrence_individual_temp;
ALTER TABLE view_full_occurrence_individual_dev RENAME TO view_full_occurrence_individual_temp;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

-- Create any indexes needed here:
-- DROP INDEX IF EXISTS tbl_col_idx;
-- CREATE INDEX tbl_col_idx ON tbl (col);

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
-- new/changed gnrs cols at end
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
a.is_centroid,
a.centroid_likelihood,
a.centroid_poldiv,
a.centroid_type,
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
a.isintroduced,
a.is_cultivated_in_region,
a.is_cultivated_taxon,
a.is_cultivated_observation,
a.is_cultivated_observation_basis,
a.citation_verbatim,
a.citation,
a.is_new, 
-- All new fields after here
-- Rearrange in final step of pipeline
NULL::text AS "TEMP_NEW_COLS_gnrs", 
CAST(b.id AS bigint) AS fk_gnrs_id,
b.country,
b.state_province,
b.county_parish AS county,
b.gid_0,
b.gid_1,
b.gid_2
FROM view_full_occurrence_individual_temp a LEFT JOIN gnrs b
ON a.poldiv_full=b.poldiv_full
;

-- Drop the temp table
DROP TABLE IF EXISTS view_full_occurrence_individual_temp;

COMMIT;