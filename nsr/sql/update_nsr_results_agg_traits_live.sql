-- ---------------------------------------------------------
-- Update nsr results columns to copy of table agg_traits
-- For use on live production database
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :sch;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

--
-- Generate the new table from the temp copy, adding and populating 
-- new columns in the positions desired. Be sure to copy ALL 
-- existing columns in source table, in addition to new or updated
-- columns.
DROP TABLE IF EXISTS agg_traits_new;
CREATE TABLE agg_traits_new AS 
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
a.continent,
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
c.id AS nsr_id,
c.native_status_country,
c.native_status_state_province,
c.native_status_county_parish,
c.native_status,
c.native_status_reason,
c.native_status_sources,
c.isintroduced::smallint as is_introduced,
c.is_cultivated_in_region,
a.is_cultivated_taxon,
a.cods_proximity_id,
a.cods_keyword_id,
a.is_cultivated_observation,
a.is_cultivated_observation_basis,
a.geom
FROM (
SELECT * FROM agg_traits 
:sql_limit
) a 
LEFT JOIN 
(
SELECT tbl_id, fk_taxon_poldiv
FROM nsr_submitted_raw 
WHERE tbl_name='agg_traits'
) b
ON a.id=b.tbl_id
LEFT JOIN nsr c
ON b.fk_taxon_poldiv=c.taxon_poldiv
;

COMMIT;