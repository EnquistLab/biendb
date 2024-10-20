-- ---------------------------------------------------------
-- Copy table from core schema to development schema,
-- omitting unused columns, adding new columns & reordering
-- existing columns. New columns are empty placeholders; they 
-- will be re-created and populated in later "CREATE TABLE AS"
-- operations
-- ---------------------------------------------------------

-- SET search_path TO analytical_db_dev, postgis;
-- postgis included to enable geospatial columns
SET search_path TO :target_schema, postgis;

BEGIN;

LOCK TABLE :src_schema.view_full_occurrence_individual IN SHARE MODE;

-- Adjust work_mem, but research carefully
-- SET LOCAL work_mem = '500 MB';  -- just for this transaction
SET temp_buffers = '3000MB';

-- Generate the first temp table, adding and populating the
-- new columns in position desired. Be sure to copy ALL 
-- existing columns in source table, unless you want to remove
-- one or more columns
-- Note: CASTing an existing column as itself removes existing
-- type cast. This is necessary to make tables portable to other
-- databases. And these constraints no longer needed for analytical
-- database (e.g., "CAST(higher_plant_group AS TEXT) AS higher_plant_group")
-- FK fk_vfoi_staging_taxonobservation_id is FK for joining to staging table,
-- plots only, for inserting stem data
DROP TABLE IF EXISTS :target_schema.view_full_occurrence_individual_dev;
CREATE TABLE :target_schema.view_full_occurrence_individual_dev AS 
SELECT 
taxonobservation_id,
CAST(CASE WHEN datasource IN ('NVS','SALVIAS','TEAM','FIA','Madidi','CTFS','CVS','VegBank') THEN 'plot' ELSE 'specimen' END AS VARCHAR(20)) AS observation_type,
CAST(NULL AS BIGINT) AS plot_metadata_id,
CAST(NULL AS BIGINT) AS datasource_id,
datasource,
CAST(NULL AS TEXT) AS dataset,
CAST(NULL AS TEXT) AS dataowner,
country AS country_verbatim,
state_province AS state_province_verbatim,
county AS county_verbatim,
CAST(NULL AS text) AS poldiv_full,
CAST(NULL AS BIGINT) AS fk_gnrs_id,
CAST(NULL AS TEXT) AS country,
CAST(NULL AS TEXT) AS state_province,
CAST(NULL AS TEXT) AS county,
locality,
CAST(CONCAT_WS(', ',latitude,longitude) AS TEXT) AS latlong_verbatim,
-- Casting to text then numeric avoids truncating decimals
CAST(latitude::text AS NUMERIC) AS latitude,
CAST(longitude::text AS NUMERIC) AS longitude,
CAST(NULL AS TEXT) AS geodeticdatum,
coord_uncertainty_m,
CAST(NULL AS TEXT) AS coord_uncertainty_verbatim,
CAST(NULL AS NUMERIC) AS coord_max_uncertainty_km,
CAST(georef_sources AS TEXT) AS georef_sources,
georef_protocol,
CAST(NULL AS bigint) AS fk_centroid_id,
CAST(NULL AS SMALLINT) AS is_centroid,
CAST(NULL AS NUMERIC) AS centroid_likelihood,
CAST(NULL AS text) AS centroid_poldiv,
CAST(NULL AS text) AS centroid_type,
CAST(NULL AS SMALLINT) AS is_in_country,
CAST(NULL AS SMALLINT) AS is_in_state_province,
CAST(NULL AS SMALLINT) AS is_in_county,
CAST(NULL AS SMALLINT) AS is_geovalid,
CAST(NULL AS SMALLINT) AS is_new_world,
project_id,
project_contributors,
location_id,
plot_name,
subplot,
is_location_cultivated,
locationevent_id,
CAST(NULL AS TEXT) AS event_date_verbatim,
event_date,
CAST(NULL AS TEXT) AS event_date_accuracy,
CAST(NULL AS TEXT) AS elevation_verbatim,
CAST(elevation_m AS numeric) AS elevation_m,
CAST(NULL AS numeric) AS elevation_min_m,
CAST(NULL AS numeric) AS elevation_max_m,
CAST(slope_aspect_deg AS numeric(4,1)) AS slope_aspect_deg,
CAST(slope_gradient_deg AS numeric(4,1)) AS slope_gradient_deg,
plot_area_ha,
sampling_protocol,
CAST(temperature_c AS numeric(4,1)) AS temperature_c,
CAST(precip_mm AS numeric(6,1))*1000 AS precip_mm,
stratum_name,
CAST(NULL AS TEXT) AS vegetation_verbatim,
community_concept_name,
observation_contributors,
custodial_institution_codes,
collection_code,
catalog_number,
occurrence_id,
recorded_by,
record_number,
CAST(NULL AS TEXT) AS date_collected_verbatim,
date_collected,
CAST(NULL AS TEXT) AS date_collected_accuracy,
identified_by,
CAST(NULL AS TEXT) AS date_identified_verbatim,
date_identified,
CAST(NULL AS TEXT) AS date_identified_accuracy,
identification_remarks,
CAST(NULL AS BIGINT) AS bien_taxonomy_id,
CAST(NULL AS BIGINT) AS taxon_id,
CAST(NULL AS BIGINT) AS family_taxon_id,
CAST(NULL AS BIGINT) AS genus_taxon_id,
CAST(NULL AS BIGINT) AS species_taxon_id,
verbatim_family,
verbatim_scientific_name,
TRIM(CONCAT_WS(' ',verbatim_family, verbatim_scientific_name)) AS name_submitted,
CAST(NULL AS BIGINT) AS fk_tnrs_id,
family_matched,
name_matched,
name_matched_author,
CAST(NULL AS NUMERIC(3,2)) AS tnrs_name_matched_score,
CAST(NULL AS TEXT) AS tnrs_warning,
taxonomic_status AS matched_taxonomic_status,
CAST(NULL AS TEXT) AS match_summary,
CAST(NULL AS TEXT) AS scrubbed_taxonomic_status,
CAST(higher_plant_group AS TEXT) AS higher_plant_group,
scrubbed_family,
scrubbed_genus,
scrubbed_specific_epithet,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author,
CAST(NULL AS TEXT) AS scrubbed_taxon_canonical,
scrubbed_author,
scrubbed_taxon_name_with_author,
scrubbed_species_binomial_with_morphospecies,
CAST(growth_form AS TEXT) AS growth_form,
reproductive_condition,
occurrence_remarks,
taxon_observation_id,
taxon_name_usage_concept_author_code,
plantobservation_id,
aggregate_organism_observation_id,
individual_organism_observation_id,
individual_id,
individual_count,
CAST(NULL AS NUMERIC(5,2)) AS stem_height_m,
CAST(cover_percent AS NUMERIC(5,2))  AS cover_percent,
CAST(NULL AS TEXT) AS cites,
CAST(NULL AS TEXT) AS iucn,
CAST(NULL AS TEXT) AS usda_federal,
CAST(NULL AS TEXT) AS usda_state,
CAST(NULL AS SMALLINT) AS is_embargoed_observation,
CAST(NULL AS geometry(Point,4326)) AS geom,
CAST(NULL AS BIGINT) AS nsr_id,
CAST(NULL AS TEXT) AS native_status_country,
CAST(NULL AS TEXT) AS native_status_state_province,
CAST(NULL AS TEXT) AS native_status_county_parish,
CAST(NULL AS TEXT) AS native_status,
CAST(NULL AS TEXT) AS native_status_reason,
CAST(NULL AS TEXT) AS native_status_sources,
CAST(NULL AS SMALLINT) AS isintroduced,
CAST(NULL AS SMALLINT) AS is_cultivated_in_region,
CAST(NULL AS SMALLINT) AS is_cultivated_taxon,
CAST(NULL AS SMALLINT) AS is_cultivated_observation,
CAST(NULL AS TEXT) AS is_cultivated_observation_basis,
CAST(NULL AS TEXT) AS citation_verbatim,
CAST(NULL AS TEXT) AS citation,
CAST(0 AS SMALLINT) AS is_new,
CAST(NULL AS BIGINT) AS fk_vfoi_staging_taxonobservation_id
FROM :src_schema.view_full_occurrence_individual
:where 
:limit
;

-- Set values for new columns here if applicable
ALTER TABLE ONLY :target_schema.view_full_occurrence_individual_dev ALTER COLUMN is_new SET DEFAULT 1;

-- Commit & release share lock on original table
COMMIT;