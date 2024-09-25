-- ---------------------------------------------------------
-- Copy table from core schema to development schema
-- Data only, no indexes
-- ---------------------------------------------------------

BEGIN;

SET search_path TO :dev_schema;

LOCK TABLE :core_schema.agg_traits IN SHARE MODE;

-- Copy the table & data
DROP TABLE IF EXISTS :dev_schema.agg_traits;
CREATE TABLE :dev_schema.agg_traits AS
SELECT 
id,
traits_id,
CAST(NULL AS BIGINT) AS bien_taxonomy_id,
CAST(NULL AS BIGINT) AS taxon_id,
CAST(NULL AS BIGINT) AS family_taxon_id,
CAST(NULL AS BIGINT) AS genus_taxon_id,
CAST(NULL AS BIGINT) AS species_taxon_id,
fk_tnrs_user_id,
verbatim_family,
verbatim_scientific_name,
TRIM(CONCAT_WS(' ',verbatim_family, verbatim_scientific_name)) AS name_submitted,
family_matched,
name_matched,
name_matched_author,
CAST(NULL AS NUMERIC) AS tnrs_name_matched_score,
tnrs_warning,
matched_taxonomic_status,
scrubbed_taxonomic_status,
CAST(higher_plant_group AS TEXT) AS higher_plant_group,
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
country AS country_verbatim,
stateprovince AS state_province_verbatim,
lower_political AS lower_political_verbatim,
CAST('' AS TEXT) AS poldiv_full,
CAST(NULL AS BIGINT) AS fk_gnrs_id,
CAST(NULL AS TEXT) AS country,
CAST(NULL AS TEXT) AS stateprovince,
CAST(NULL AS TEXT) AS county,
locality_description,
CAST(CONCAT_WS(', ',latitude,longitude) AS TEXT) AS latlong_verbatim,
latitude,
longitude,
min_latitude,
max_latitude,
elevation,
CAST(NULL AS TEXT) AS coord_uncertainty_verbatim,
CAST(NULL AS NUMERIC) AS coord_max_uncertainty_km,
CAST(NULL AS TEXT) AS georef_sources,
CAST(NULL AS TEXT) AS georef_protocol,
CAST(NULL AS SMALLINT) AS is_centroid,
CAST(NULL AS SMALLINT) AS is_in_country,
CAST(NULL AS SMALLINT) AS is_in_state_province,
CAST(NULL AS SMALLINT) AS is_in_county,
CAST(NULL AS SMALLINT) AS is_geovalid,
CAST(NULL AS SMALLINT) AS is_new_world,
source,
url_source,
source_citation,
source_id,
visiting_date,
reference_number,
access,
project_pi,
project_pi_contact,
observation,
authorship,
authorship_contact,
citation_bibtex,
plant_trait_files,
CAST(NULL AS SMALLINT) AS is_embargoed_observation,
CAST(NULL AS BIGINT) AS nsr_id,
CAST(NULL AS TEXT) AS native_status_country,
CAST(NULL AS TEXT) AS native_status_state_province,
CAST(NULL AS TEXT) AS native_status_county_parish,
CAST(NULL AS TEXT) AS native_status,
CAST(NULL AS TEXT) AS native_status_reason,
CAST(NULL AS TEXT) AS native_status_sources,
CAST(NULL AS SMALLINT) AS isintroduced
FROM :core_schema.agg_traits
:limit
;

-- Commit & release share lock on original table
COMMIT;
