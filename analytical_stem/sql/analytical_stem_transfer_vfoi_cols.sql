-- ----------------
-- Transfers contents of new columns from vfoi_dev to analytical_stem_dev
-- 
-- Regenerates entire table using CREATE TABLE AS to
-- avoid memory overload
-- ----------------

SET search_path TO :dev_schema;

-- Note PK on taxonobservation_id. This is critical, can't have repeats
DROP INDEX IF EXISTS vfoi_pkey;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_pkey;
ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS vfoi_pkey;
ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS view_full_occurrence_individual_dev_pkey;
ALTER TABLE view_full_occurrence_individual_dev ADD PRIMARY KEY (taxonobservation_id);

DROP INDEX IF EXISTS view_full_occurrence_individual_dev_observation_type_idx;
CREATE INDEX view_full_occurrence_individual_dev_observation_type_idx ON view_full_occurrence_individual_dev(observation_type);

BEGIN;

ALTER TABLE analytical_stem_dev RENAME TO analytical_stem_temp;

-- Populate auto_increment PK
ALTER TABLE analytical_stem_temp DROP COLUMN analytical_stem_id;
ALTER TABLE analytical_stem_temp ADD column analytical_stem_id bigserial;

DROP INDEX IF EXISTS analytical_stem_temp_taxonobservation_id_idx;
CREATE INDEX analytical_stem_temp_taxonobservation_id_idx ON analytical_stem_temp(taxonobservation_id);

-- Increase working memory
SET LOCAL work_mem = '8000 MB';  -- just for this transaction

--
-- Add & populate temporary text FK
-- 
DROP TABLE IF EXISTS analytical_stem_dev;
CREATE TABLE analytical_stem_dev AS 
SELECT 
a.analytical_stem_id::bigint,
a.taxonobservation_id,
b.plot_metadata_id,
b.datasource_id,
a.datasource,
b.dataset,
b.dataowner,
b.country_verbatim,
b.state_province_verbatim,
b.county_verbatim,
b.poldiv_full,
b.fk_gnrs_id,
b.continent,
b.country,
b.state_province,
b.county,
b.gid_0,
b.gid_1,
b.gid_2,
a.locality,
b.latlong_verbatim,
b.latitude,
b.longitude,
b.geodeticdatum,
b.coord_uncertainty_m,
b.coord_uncertainty_verbatim,
b.coord_max_uncertainty_km,
b.georef_sources,
b.georef_protocol,
b.fk_cds_id,
b.is_centroid,
b.centroid_dist_km,
b.centroid_dist_relative,
b.centroid_likelihood,
b.centroid_poldiv,
b.centroid_type,
b.coordinate_inherent_uncertainty_m,
b.is_invalid_latlong,
b.invalid_latlong_reason,
b.is_in_country,
b.is_in_state_province,
b.is_in_county,
b.is_geovalid,
b.is_new_world,
b.project_id,
b.project_contributors,
b.location_id,
b.plot_name,
b.subplot,
b.is_location_cultivated,
b.locationevent_id,
b.event_date_verbatim,
b.event_date,
b.event_date_accuracy,
b.elevation_verbatim,
b.elevation_m,
b.elevation_min_m,
b.elevation_max_m,
b.slope_aspect_deg,
b.slope_gradient_deg,
b.plot_area_ha,
b.sampling_protocol,
b.temperature_c,
b.precip_mm,
b.stratum_name,
b.vegetation_verbatim,
b.community_concept_name,
b.observation_contributors,
b.custodial_institution_codes,
b.collection_code,
b.catalog_number,
b.occurrence_id,
b.recorded_by,
b.record_number,
b.date_collected_verbatim,
b.date_collected,
b.date_collected_accuracy,
b.identified_by,
b.date_identified_verbatim,
b.date_identified,
b.date_identified_accuracy,
b.identification_remarks,
b.bien_taxonomy_id,
b.taxon_id,
b.family_taxon_id,
b.genus_taxon_id,
b.species_taxon_id,
b.verbatim_family,
b.verbatim_scientific_name,
b.name_submitted,
b.fk_tnrs_id,
b.family_matched,
b.name_matched,
b.name_matched_author,
b.tnrs_name_matched_score,
b.tnrs_warning,
b.matched_taxonomic_status,
b.match_summary,
b.scrubbed_taxonomic_status,
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
b.growth_form,
b.reproductive_condition,
b.occurrence_remarks,
b.taxon_observation_id,
b.taxon_name_usage_concept_author_code,
b.plantobservation_id,
b.aggregate_organism_observation_id,
b.individual_organism_observation_id,
a.individual_id,
a.individual_count,
a.tag,
a.relative_x_m,
a.relative_y_m,
a.stem_code,
a.stem_dbh_cm_verbatim,
a.stem_dbh_cm,
a.stem_height_m_verbatim,
b.stem_height_m,
b.cover_percent,
b.is_embargoed_observation,
b.nsr_id,
b.native_status_country,
b.native_status_state_province,
b.native_status_county_parish,
b.native_status,
b.native_status_reason,
b.native_status_sources,
b.is_introduced,
b.is_cultivated_in_region,
b.is_cultivated_taxon,
b.cods_proximity_id,
b.cods_keyword_id,
b.is_cultivated_observation,
b.is_cultivated_observation_basis,
b.citation_verbatim,
b.citation
FROM analytical_stem_temp a JOIN view_full_occurrence_individual_dev b
ON a.taxonobservation_id=b.taxonobservation_id
WHERE b.observation_type='plot'
;

DROP TABLE IF EXISTS analytical_stem_temp;

COMMIT;

ALTER TABLE view_full_occurrence_individual_dev DROP CONSTRAINT IF EXISTS view_full_occurrence_individual_dev_pkey;
DROP INDEX IF EXISTS view_full_occurrence_individual_dev_observation_type_idx;
