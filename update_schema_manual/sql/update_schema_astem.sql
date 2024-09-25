-- ---------------------------------------------------------
-- Update schema of analytical_stem, preserving unchanged columns
-- and all existing data
-- ---------------------------------------------------------

-- ---------------------------------------------------------
-- Update starndard political division columns in table vfoi 
-- with results of GNRS validations
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :sch;

DROP TABLE IF EXISTS analytical_stem_temp;
ALTER TABLE analytical_stem_dev RENAME TO analytical_stem_temp;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

-- Create any indexes as needed
-- DROP INDEX IF EXISTS tbl_col_idx;
-- CREATE INDEX tbl_col_idx ON tbl (col);

--
-- Generate the new table from the temp copy, adding and populating 
-- new columns in the positions desired. Be sure to copy ALL 
-- existing columns in source table, in addition to new or updated
-- columns.
CREATE TABLE analytical_stem_dev AS 
SELECT 
analytical_stem_id,
taxonobservation_id,
plot_metadata_id,
datasource_id,
datasource,
dataset,
CAST (NULL AS text) AS dataowner,
country_verbatim,
state_province_verbatim,
county_verbatim,
CAST (NULL AS text) AS poldiv_full,
CAST (NULL AS bigint) AS fk_gnrs_id,
country,
state_province,
county,
locality,
latlong_verbatim,
latitude::numeric,
longitude::numeric,
CAST (NULL AS text) AS geodeticdatum,
coord_uncertainty_m,
coord_uncertainty_verbatim,
coord_max_uncertainty_km,
georef_sources,
georef_protocol,
CAST (NULL AS bigint) AS fk_centroid_id,
CAST (NULL AS smallint) AS is_centroid,
CAST (NULL AS numeric) AS centroid_likelihood,
CAST (NULL AS text) AS centroid_poldiv,
CAST (NULL AS text) AS centroid_type,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
is_new_world,
project_id,
project_contributors,
location_id,
plot_name,
subplot,
is_location_cultivated,
locationevent_id,
CAST (NULL AS text) AS event_date_verbatim,
event_date,
event_date_accuracy,
elevation_verbatim,
elevation_m::numeric,
elevation_min_m,
elevation_max_m,
slope_aspect_deg::numeric(4,1),
slope_gradient_deg::numeric(4,1),
plot_area_ha,
sampling_protocol,
temperature_c::numeric(4,1),
precip_mm::numeric(4,1),
stratum_name,
vegetation_verbatim,
community_concept_name,
observation_contributors,
custodial_institution_codes,
collection_code,
catalog_number,
occurrence_id,
recorded_by,
record_number,
CAST (NULL AS text) AS date_collected_verbatim,
date_collected,
date_collected_accuracy,
identified_by,
CAST (NULL AS text) AS date_identified_verbatim,
date_identified,
date_identified_accuracy,
identification_remarks,
bien_taxonomy_id,
taxon_id,
family_taxon_id,
genus_taxon_id,
species_taxon_id,
verbatim_family,
verbatim_scientific_name,
name_submitted,
CAST (NULL AS bigint) AS fk_tnrs_id,
family_matched,
name_matched,
name_matched_author,
tnrs_name_matched_score::numeric(3,2),
tnrs_warning,
matched_taxonomic_status,
CAST (NULL AS text) AS match_summary,
CAST (NULL AS text) AS scrubbed_taxonomic_status,
higher_plant_group,
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical,
scrubbed_author,
scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies,
growth_form,
reproductive_condition,
occurrence_remarks,
taxon_observation_id,
taxon_name_usage_concept_author_code,
plantobservation_id,
aggregate_organism_observation_id,
individual_organism_observation_id,
individual_id,
individual_count,
tag,
relative_x_m,
relative_y_m,
stem_code,
stem_dbh_cm_verbatim,
stem_dbh_cm,
stem_height_m_verbatim,
stem_height_m,
cover_percent::numeric(5,2),
is_embargoed_observation,
nsr_id,
native_status_country,
native_status_state_province,
native_status_county_parish,
native_status,
native_status_reason,
native_status_sources,
isintroduced,
is_cultivated_in_region,
is_cultivated_taxon::smallint,
is_cultivated_observation::smallint,
is_cultivated_observation_basis,
citation_verbatim,
citation
FROM analytical_stem_temp 
;

-- Drop the temp table
DROP TABLE IF EXISTS analytical_stem_temp;

COMMIT;