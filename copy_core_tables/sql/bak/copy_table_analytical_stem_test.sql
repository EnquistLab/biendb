-- ---------------------------------------------------------
-- Use this version to ensure that analytical_stem is a 
-- subset of view_full_occurrence_individual_dev
-- WARNING: publc.analytical_stem MUST have an index on
-- fkey taxonobservation_id. Log in as postgres to do this.
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :target_schema;

LOCK TABLE :src_schema.analytical_stem IN SHARE MODE;

-- Need an index to run the following query
DROP INDEX IF EXISTS vfoi_dev_taxonobservation_id_idx;
CREATE INDEX vfoi_dev_taxonobservation_id_idx ON view_full_occurrence_individual_dev (taxonobservation_id);

-- Adjust work_mem, but research carefully
-- SET LOCAL work_mem = '500 MB';  -- just for this transaction

-- Generate the first temp table, adding and populating the
-- new columns in position desired. Be sure to copy ALL 
-- existing columns in source table, unless you want to remove
-- one or more columns
DROP TABLE IF EXISTS analytical_stem_dev;
CREATE TABLE analytical_stem_dev AS 
SELECT 
CAST(NULL AS TEXT) AS analytical_stem_id,
CAST(NULL AS BIGINT) AS datasource_id,
a.datasource,
CAST(NULL AS TEXT) AS dataset,
CAST(NULL AS BIGINT) AS plot_metadata_id,
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
a.verbatim_family,
a.verbatim_scientific_name,
a.identified_by,
a.date_identified,
a.identification_remarks,
a.family_matched,
a.name_matched,
a.name_matched_author,
a.higher_plant_group,
a.taxonomic_status,
a.scrubbed_family,
a.scrubbed_genus,
a.scrubbed_specific_epithet,
a.scrubbed_species_binomial,
a.scrubbed_taxon_name_no_author,
a.scrubbed_author,
a.scrubbed_taxon_name_with_author,
a.scrubbed_species_binomial_with_morphospecies,
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
FROM :src_schema.analytical_stem a JOIN :target_schema.view_full_occurrence_individual_dev b
ON a.taxonobservation_id=b.taxonobservation_id
LIMIT 1000
;


DROP INDEX IF EXISTS vfoi_dev_taxonobservation_id_idx;

-- Commit & release share lock on original table
COMMIT;