-- ---------------------------------------------------------
-- Populate column is_geovalid in table agg_traits
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
id,
id_verbatim,
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
match_summary,
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
gid_0,
gid_1,
gid_2,
locality_description,
latlong_verbatim,
latitude,
min_latitude,
max_latitude,
longitude,
min_longitude,
max_longitude,
coord_uncertainty_verbatim,
coord_max_uncertainty_km,
georef_sources,
georef_protocol,
fk_cds_id,
is_centroid,
centroid_dist_km,
centroid_dist_relative,
centroid_likelihood,
centroid_poldiv,
centroid_type,
coordinate_inherent_uncertainty_m,
is_invalid_latlong,
invalid_latlong_reason,
is_in_country,
is_in_state_province,
is_in_county,
CASE
WHEN latitude IS NOT NULL AND longitude IS NOT NULL 
AND (
is_in_country=1 
AND (is_in_state_province=1 OR is_in_state_province IS NULL)
AND (is_in_county=1 OR is_in_county IS NULL)
)
AND is_invalid_latlong=0
THEN 1::smallint
ELSE 0::smallint
END 
AS is_geovalid,
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
is_cultivated_observation_basis,
geom
FROM agg_traits_temp
;

;

-- Drop the temp table
DROP TABLE IF EXISTS agg_traits_temp;

COMMIT;