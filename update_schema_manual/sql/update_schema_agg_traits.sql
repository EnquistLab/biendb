-- ---------------------------------------------------------
-- Update schema of agg_traits, preserving unchanged columns
-- and all existing data
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :sch;

DROP TABLE IF EXISTS agg_traits_temp;
ALTER TABLE agg_traits RENAME TO agg_traits_temp;

-- Or adjust work_mem, but research carefully
SET LOCAL temp_buffers = '3000MB';  -- just for this transaction

-- Create any indexes as needed
-- DROP INDEX IF EXISTS tbl_col_idx;
-- CREATE INDEX tbl_col_idx ON tbl (col);

-- Generate the new table from the temp copy, adding and populating 
-- new columns in the positions desired. Be sure to copy ALL 
-- existing columns in source table, in addition to new or updated
-- columns.
CREATE TABLE agg_traits AS 
SELECT 
id,
traits_id,
bien_taxonomy_id,
taxon_id,
family_taxon_id,
genus_taxon_id,
species_taxon_id,
fk_tnrs_id,
verbatim_family,
verbatim_scientific_name,
name_submitted,
family_matched,
name_matched,
name_matched_author,
tnrs_name_matched_score,
higher_plant_group,
tnrs_warning,
matched_taxonomic_status,
CAST(null AS text) AS match_summary,
scrubbed_taxonomic_status,
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
scrubbed_taxon_canonical,
scrubbed_author,
scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies,
trait_name,
trait_value,
unit,
method,
region,
country_verbatim,
state_province_verbatim,
county_verbatim,
poldiv_full,
fk_gnrs_id,
country,
state_province,
county,
CAST(null AS bigint) AS fk_centroid_id,
CAST(null AS smallint) AS is_centroid,
CAST(null AS numeric) AS centroid_likelihood,
CAST(null AS text) AS centroid_poldiv,
CAST(null AS text) AS centroid_type,
is_in_country,
is_in_state_province,
is_in_county,
locality_description,
latlong_verbatim,
CAST(latitude AS double precision) AS latitude,
CAST(min_latitude AS double precision) AS min_latitude,
CAST(max_latitude AS double precision) AS max_latitude,
CAST(longitude AS double precision) AS longitude,
CAST(min_longitude AS double precision) AS min_longitude,
CAST(max_longitude AS double precision) AS max_longitude,
coord_uncertainty_verbatim,
coord_max_uncertainty_km,
georef_sources,
georef_protocol,
is_geovalid,
is_new_world,
elevation_verbatim,
elevation_m,
elevation_min_m,
elevation_max_m,
source,
url_source,
source_citation,
source_id,
visiting_date_verbatim,
visiting_date,
visiting_date_accuracy,
reference_number,
access,
project_pi,
project_pi_contact,
observation,
authorship,
authorship_contact,
citation_bibtex,
plant_trait_files,
is_experiment,
observation_context,
observation_date_verbatim,
observation_date,
observation_date_accuracy,
source_locality,
is_individual_trait,
is_species_trait,
is_trait_value_valid,
temporary_taxonobservation_id,
taxonobservation_id,
is_individual_measurement,
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
is_cultivated_taxon,
is_cultivated_observation,
is_cultivated_observation_basis
FROM agg_traits_temp
;

-- Drop the temp table
DROP TABLE IF EXISTS agg_traits_temp;

COMMIT;