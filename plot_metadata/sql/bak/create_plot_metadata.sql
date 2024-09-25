-- 
--  Create table plot_metadata
--

SET search_path TO :dev_schema;

-- EXTRACT plot codes and existing metadata from 
-- vfoi to first temporary table, without DISTINCT
DROP TABLE IF EXISTS existing_plot_metadata_temp;
CREATE TABLE existing_plot_metadata_temp AS 
SELECT 
datasource,
dataset,
dataowner,
CAST(NULL AS TEXT) AS primary_dataowner_email, 
plot_name,
CAST(NULL AS TEXT) AS plot_name_full,
CAST(country AS TEXT) AS country_verbatim,
CAST(state_province AS TEXT) AS state_province_verbatim,
CAST(county AS TEXT) AS county_verbatim,
country,
state_province,
county,
locality,
CAST(NULL AS TEXT) AS latlong_verbatim,
latitude,
longitude,
CAST(NULL AS TEXT) AS "geodeticdatum",
coord_uncertainty_m,
CAST(NULL AS TEXT) AS "coord_uncertainty_verbatim",
CAST(NULL AS numeric) AS "coord_max_uncertainty_km",
georef_sources,
georef_protocol,
CAST(NULL AS smallint) AS "is_centroid",
CAST(NULL AS smallint) AS "is_in_country",
CAST(NULL AS smallint) AS "is_in_state_province",
CAST(NULL AS smallint) AS "is_in_county",
is_geovalid,
is_new_world,
event_date,
CAST(NULL AS TEXT) AS "event_date_accuracy",
elevation_m,
slope_aspect_deg,
slope_gradient_deg,
temperature_c,
precip_mm*1000 AS precip_mm,
community_concept_name,
plot_area_ha,
sampling_protocol
FROM view_full_occurrence_individual_dev
WHERE observation_type='plot'
;

-- Index second temporary table
CREATE INDEX existing_plot_metadata_temp_datasource_idx ON existing_plot_metadata_temp USING btree (datasource);
CREATE INDEX existing_plot_metadata_temp_dataset_idx ON existing_plot_metadata_temp USING btree (dataset);
CREATE INDEX existing_plot_metadata_temp_plot_name_idx ON existing_plot_metadata_temp USING btree (plot_name);

-- 
-- Create table and extract just distinct combinations
-- of datasource, dataset and plot code
-- 
DROP TABLE IF EXISTS plot_metadata;
CREATE TABLE plot_metadata ( 
LIKE existing_plot_metadata_temp INCLUDING DEFAULTS
);

INSERT INTO plot_metadata (
datasource,
dataset,
plot_name
)
SELECT DISTINCT
datasource,
dataset,
plot_name
FROM existing_plot_metadata_temp 
WHERE plot_name IS NOT NULL
;

ALTER TABLE plot_metadata
ADD COLUMN plot_metadata_id SERIAL PRIMARY KEY NOT NULL,
ADD COLUMN datasource_id BIGINT DEFAULT NULL,
ADD COLUMN datasource_plot_id INTEGER DEFAULT NULL,
ADD COLUMN abundance_measurement VARCHAR(100) DEFAULT NULL,
ADD COLUMN abundance_measurement_description VARCHAR(100) DEFAULT NULL,
ADD COLUMN has_strata VARCHAR(25) DEFAULT NULL,
ADD COLUMN has_stem_data VARCHAR(25) DEFAULT NULL,
ADD COLUMN methodology_reference TEXT DEFAULT NULL,
ADD COLUMN methodology_description TEXT DEFAULT NULL,
ADD COLUMN stem_diam_min NUMERIC DEFAULT NULL,
ADD COLUMN stem_diam_min_units VARCHAR(25) DEFAULT NULL,
ADD COLUMN stem_diam_max NUMERIC DEFAULT NULL,
ADD COLUMN stem_diam_max_units VARCHAR(25) DEFAULT NULL,
ADD COLUMN stem_measurement_height NUMERIC DEFAULT NULL,
ADD COLUMN stem_measurement_height_units VARCHAR(25) DEFAULT NULL,
ADD COLUMN growth_forms_included_all VARCHAR(25) DEFAULT NULL,
ADD COLUMN growth_forms_included_trees VARCHAR(25) DEFAULT NULL,
ADD COLUMN growth_forms_included_shrubs VARCHAR(25) DEFAULT NULL,
ADD COLUMN growth_forms_included_lianas VARCHAR(25) DEFAULT NULL,
ADD COLUMN growth_forms_included_herbs VARCHAR(25) DEFAULT NULL,
ADD COLUMN growth_forms_included_epiphytes VARCHAR(25) DEFAULT NULL,
ADD COLUMN growth_forms_included_notes VARCHAR(250) DEFAULT NULL,
ADD COLUMN taxa_included_all VARCHAR(25) DEFAULT NULL,
ADD COLUMN taxa_included_seed_plants VARCHAR(25) DEFAULT NULL,
ADD COLUMN taxa_included_ferns_lycophytes VARCHAR(25) DEFAULT NULL,
ADD COLUMN taxa_included_bryophytes VARCHAR(25) DEFAULT NULL,
ADD COLUMN taxa_included_exclusions VARCHAR(250) DEFAULT NULL
;
        
-- Add basic indexes needed for further updates
CREATE INDEX plot_metadata_datasource_idx ON plot_metadata USING btree (datasource);
CREATE INDEX plot_metadata_dataset_idx ON plot_metadata USING btree (dataset);
CREATE INDEX plot_metadata_plot_name_idx ON plot_metadata USING btree (plot_name);

-- Now create a single FK in original table to speed up joins
ALTER TABLE existing_plot_metadata_temp
ADD COLUMN plot_metadata_id INTEGER DEFAULT NULL;

-- Join on all three columns
UPDATE existing_plot_metadata_temp a
SET plot_metadata_id=b.plot_metadata_id
FROM plot_metadata b
WHERE a.datasource=b.datasource
AND a.dataset=b.dataset
AND a.plot_name=b.plot_name
;
-- Full JOIN on all two columns
-- in case dataset is null
UPDATE existing_plot_metadata_temp a
SET plot_metadata_id=b.plot_metadata_id
FROM plot_metadata b
WHERE a.datasource=b.datasource
AND a.plot_name=b.plot_name
AND a.plot_metadata_id IS NULL
;

-- Index the FK
CREATE INDEX existing_plot_metadata_temp_plot_metadata_id_idx 
ON existing_plot_metadata_temp USING btree (plot_metadata_id);