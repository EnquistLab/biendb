-- ---------------------------------------------------------
-- Applies tnrs results to table agg_traits
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :sch;

DROP TABLE IF EXISTS agg_traits_temp;
ALTER TABLE agg_traits RENAME TO agg_traits_temp;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

-- Create any indexes as needed
DROP INDEX IF EXISTS agg_traits_temp_name_submitted_idx;
CREATE INDEX agg_traits_temp_name_submitted_idx ON agg_traits_temp (name_submitted);

-- Generate the new table from the temp copy, adding and populating 
-- new columns in the positions desired. Be sure to copy ALL 
-- existing columns in source table, in addition to new or updated
-- columns.
CREATE TABLE agg_traits AS 
SELECT 
a.id,
a.traits_id,
a.bien_taxonomy_id,
a.taxon_id,
a.family_taxon_id,
a.genus_taxon_id,
a.species_taxon_id,
b.tnrs_id AS fk_tnrs_id,
a.verbatim_family,
a.verbatim_scientific_name,
case
when a.name_submitted='' then null
else a.name_submitted
end,
b.family_matched,
b.name_matched,
b.name_matched_author,
b.tnrs_name_matched_score,
a.higher_plant_group,
b.tnrs_warning,
b.matched_taxonomic_status,
b.scrubbed_taxonomic_status,
b.scrubbed_family,
b.scrubbed_genus,
b.scrubbed_specific_epithet,
b.scrubbed_species_binomial,
b.scrubbed_taxon_name_no_author,
b.scrubbed_taxon_canonical,
b.scrubbed_author,
b.scrubbed_taxon_name_with_author,
b.scrubbed_species_binomial_with_morphospecies,
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
a.centroid_likelihood,
a.centroid_max_uncertainty_km,
a.centroid_type,
a.is_in_country,
a.is_in_state_province,
a.is_in_county,
a.locality_description,
a.latlong_verbatim,
a.latitude,
a.min_latitude,
a.max_latitude,
a.longitude,
a.min_longitude,
a.max_longitude,
a.coord_uncertainty_verbatim,
a.coord_max_uncertainty_km,
a.georef_sources,
a.georef_protocol,
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
a.isintroduced,
a.is_cultivated_in_region,
a.is_cultivated_taxon,
a.is_cultivated_observation,
a.is_cultivated_observation_basis
FROM agg_traits_temp a LEFT JOIN tnrs b
ON a.name_submitted=b.name_submitted_verbatim
;

-- Drop the temp table
DROP TABLE IF EXISTS agg_traits_temp;

COMMIT;