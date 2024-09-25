-- ----------------
-- Transfers contents of new columns from vfoi_dev to analytical_stem_dev
-- 
-- Regenerates entire table using CREATE TABLE AS to
-- avoid memory overload
-- ----------------

SET search_path TO :dev_schema;

BEGIN;

ALTER TABLE analytical_stem_dev 
RENAME TO analytical_stem_temp;

DROP INDEX IF EXISTS analytical_stem_temp_taxonobservation_id_idx;
CREATE INDEX analytical_stem_temp_taxonobservation_id_idx ON analytical_stem_temp(taxonobservation_id);

DROP INDEX IF EXISTS view_full_occurrence_individual_dev_taxonobservation_id_idx;
CREATE INDEX view_full_occurrence_individual_dev_taxonobservation_id_idx ON view_full_occurrence_individual_dev(taxonobservation_id);
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_observation_type_idx;
CREATE INDEX view_full_occurrence_individual_dev_observation_type_idx ON view_full_occurrence_individual_dev(observation_type);

-- Possibly adjust work_mem, but research carefully
-- SET LOCAL work_mem = '1000 MB';  -- just for this transaction

--
-- Add & populate temporary text FK
-- 
DROP TABLE IF EXISTS analytical_stem_dev;
CREATE TABLE analytical_stem_dev AS 
SELECT 
CAST(NULL AS TEXT) AS analytical_stem_id,
b.datasource_id,
b.datasource,
b.dataset,
b.dataowner,
b.plot_metadata_id,
a.plot_name,
a.plantobservation_id,
a.taxonobservation_id,
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
b.verbatim_family,
b.verbatim_scientific_name,
b.name_submitted,
b.family_matched,
b.name_matched,
b.name_matched_author,
b.tnrs_warning,
b.matched_taxonomic_status AS taxonomic_status,
b.matched_taxonomic_status,
b.higher_plant_group,
b.scrubbed_family,
b.scrubbed_genus,
b.scrubbed_specific_epithet,
b.scrubbed_species_binomial,
b.scrubbed_taxon_name_no_author,
b.scrubbed_taxon_canonical,
b.scrubbed_author,
b.scrubbed_taxon_name_with_author,
b.scrubbed_species_binomial_with_morphospecies,
b.scrubbed_taxonomic_status,
a.growth_form,
a.reproductive_condition,
a.is_cultivated,
a.is_cultivated_basis,
a.occurrence_remarks,
a.cover_percent,
a.taxon_observation_id,
a.taxon_name_usage_concept_author_code,
a.aggregate_organism_observation_id,
a.individual_organism_observation_id,
a.individual_id,
a.individual_count,
a.tag,
a.relative_x_m,
a.relative_y_m,
a.stem_code,
a.stem_dbh_cm,
a.stem_height_m
FROM analytical_stem_temp a JOIN view_full_occurrence_individual_dev b
ON a.taxonobservation_id=b.taxonobservation_id
WHERE b.observation_type='plot'
;

DROP TABLE IF EXISTS analytical_stem_temp;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_taxonobservation_id_idx;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_observation_type_idx;

COMMIT;