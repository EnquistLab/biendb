-- ---------------------------------------------------------
-- Update nsr results columns in table vfoi
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :sch;

DROP TABLE IF EXISTS agg_traits_temp;
ALTER TABLE agg_traits RENAME TO agg_traits_temp;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

-- Create any indexes needed here:
DROP INDEX IF EXISTS agg_traits_temp_id_idx;
CREATE UNIQUE INDEX agg_traits_temp_id_idx ON agg_traits_temp (id);

--
-- Generate the new table from the temp copy, adding and populating 
-- new columns in the positions desired. Be sure to copy ALL 
-- existing columns in source table, in addition to new or updated
-- columns.
CREATE TABLE agg_traits AS 
SELECT 
a.id,
a.id_verbatim,
a.traits_id,
a.bien_taxonomy_id,
a.taxon_id,
a.family_taxon_id,
a.genus_taxon_id,
a.species_taxon_id,
a.fk_tnrs_id,
a.verbatim_family,
a.verbatim_scientific_name,
a.name_submitted,
a.family_matched,
a.name_matched,
a.name_matched_author,
a.tnrs_name_matched_score,
a.higher_plant_group,
a.tnrs_warning,
a.matched_taxonomic_status,
a.match_summary,
a.scrubbed_taxonomic_status,
a.scrubbed_family,
a.scrubbed_genus,
a.scrubbed_specific_epithet,
a.scrubbed_species_binomial,
a.scrubbed_taxon_name_no_author,
a.scrubbed_taxon_canonical,
a.scrubbed_author,
a.scrubbed_taxon_name_with_author,
a.scrubbed_species_binomial_with_morphospecies,
a.trait_name,
a.trait_value,
a.unit,
a.method,
a.region,
a.country_verbatim,
a.state_province_verbatim,
a.county_verbatim,
a.poldiv_full,
a.fk_gnrs_id,
a.country,
a.state_province,
a.county,
a.gid_0,
a.gid_1,
a.gid_2,
a.locality_description,
a.latlong_verbatim,
a.latitude,
a.min_latitude,
a.max_latitude,
a.longitude,
a.latlong_text,
a.min_longitude,
a.max_longitude,
a.coord_uncertainty_verbatim,
a.coord_max_uncertainty_km,
a.georef_sources,
a.georef_protocol,
a.fk_cds_id,
a.is_centroid,
a.centroid_dist_km,
a.centroid_dist_relative,
a.centroid_likelihood,
a.centroid_poldiv,
a.centroid_type,
a.coordinate_inherent_uncertainty_m,
a.is_invalid_latlong,
a.invalid_latlong_reason,
a.is_in_country,
a.is_in_state_province,
a.is_in_county,
a.is_geovalid,
a.is_new_world,
a.elevation_verbatim,
a.elevation_m,
a.elevation_min_m,
a.elevation_max_m,
a.source,
a.url_source,
a.source_citation,
a.source_id,
a.visiting_date_verbatim,
a.visiting_date,
a.visiting_date_accuracy,
a.reference_number,
a.access,
a.project_pi,
a.project_pi_contact,
a.observation,
a.authorship,
a.authorship_contact,
a.citation_bibtex,
a.plant_trait_files,
a.is_experiment,
a.observation_context,
a.observation_date_verbatim,
a.observation_date,
a.observation_date_accuracy,
a.source_locality,
a.is_individual_trait,
a.is_species_trait,
a.is_trait_value_valid,
a.temporary_taxonobservation_id,
a.taxonobservation_id,
a.is_individual_measurement,
a.is_embargoed_observation,
a.nsr_id,
a.native_status_country,
a.native_status_state_province,
a.native_status_county_parish,
a.native_status,
a.native_status_reason,
a.native_status_sources,
-- a.isintroduced,
a.is_cultivated_in_region,
a.is_cultivated_taxon,
a.cods_proximity_id,
b.id AS cods_keyword_id,
CASE
WHEN b.is_cultivated_observation=1 THEN 1
ELSE a.is_cultivated_observation
END
AS is_cultivated_observation,
CASE
WHEN b.is_cultivated_observation=1 THEN TRIM(CONCAT_WS(' ', a.is_cultivated_observation_basis, b.is_cultivated_observation_reason))
ELSE a.is_cultivated_observation_basis
END
AS is_cultivated_observation_basis, 
a.geom
FROM agg_traits_temp a LEFT JOIN 
(
SELECT id, tbl_id, is_cultivated_observation, is_cultivated_observation_reason
FROM cods_keyword 
WHERE tbl_name='agg_traits'
) b
ON a.id=b.tbl_id
;

-- Drop the temp table
DROP TABLE IF EXISTS agg_traits_temp;

COMMIT;