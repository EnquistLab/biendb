-- -------------------------------------------------------------
-- Appends to datasource from staging table
-- 
-- Includes all columns except the (auto-increment) primary
-- key datasource_id and recursive FK proximate_provider_id
-- -------------------------------------------------------------

SET search_path TO :sch;

-- Index the join columns, dropping in case they already exist
DROP INDEX IF EXISTS datasource_source_name_idx;
DROP INDEX IF EXISTS datasource_proximate_provider_name_idx;
DROP INDEX IF EXISTS plot_metadata_staging_datasource_idx;
DROP INDEX IF EXISTS plot_metadata_staging_dataset_idx;

CREATE INDEX datasource_source_name_idx ON datasource (source_name);
CREATE INDEX datasource_proximate_provider_name_idx ON datasource (proximate_provider_name);
CREATE INDEX plot_metadata_staging_datasource_idx ON plot_metadata_staging (datasource);
CREATE INDEX plot_metadata_staging_dataset_idx ON plot_metadata_staging (dataset);


INSERT INTO plot_metadata (
datasource_id,
datasource_plot_id,
datasource,
dataset,
dataowner,
primary_dataowner_email,
plot_name,
plot_name_full,
country_verbatim,
state_province_verbatim,
county_verbatim,
country,
state_province,
county,
locality,
latlong_verbatim,
latitude,
longitude,
geodeticdatum,
coord_uncertainty_m,
coord_uncertainty_verbatim,
coord_max_uncertainty_km,
georef_sources,
georef_protocol,
is_centroid,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
is_new_world,
event_date,
event_date_accuracy,
elevation_m,
slope_aspect_deg,
slope_gradient_deg,
temperature_c,
precip_mm,
community_concept_name,
plot_area_ha,
sampling_protocol,
abundance_measurement,
abundance_measurement_description,
has_strata,
has_stem_data,
methodology_reference,
methodology_description,
stem_diam_min,
stem_diam_min_units,
stem_diam_max,
stem_diam_max_units,
stem_measurement_height,
stem_measurement_height_units,
growth_forms_included_all,
growth_forms_included_trees,
growth_forms_included_shrubs,
growth_forms_included_lianas,
growth_forms_included_herbs,
growth_forms_included_epiphytes,
growth_forms_included_notes,
taxa_included_all,
taxa_included_seed_plants,
taxa_included_ferns_lycophytes,
taxa_included_bryophytes,
taxa_included_exclusions
)
SELECT
b.datasource_id,
a.datasource_plot_id,
a.datasource,
a.dataset,
a.dataowner,
primary_dataowner_email,
plot_name,
plot_name_full,
country_verbatim,
state_province_verbatim,
county_verbatim,
country,
state_province,
county,
locality,
latlong_verbatim,
latitude,
longitude,
geodeticdatum,
coord_uncertainty_m,
coord_uncertainty_verbatim,
coord_max_uncertainty_km,
georef_sources,
georef_protocol,
is_centroid,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
is_new_world,
event_date,
event_date_accuracy,
elevation_m,
slope_aspect_deg,
slope_gradient_deg,
temperature_c,
precip_mm,
community_concept_name,
plot_area_ha,
sampling_protocol,
abundance_measurement,
abundance_measurement_description,
has_strata,
has_stem_data,
methodology_reference,
methodology_description,
stem_diam_min,
stem_diam_min_units,
stem_diam_max,
stem_diam_max_units,
stem_measurement_height,
stem_measurement_height_units,
growth_forms_included_all,
growth_forms_included_trees,
growth_forms_included_shrubs,
growth_forms_included_lianas,
growth_forms_included_herbs,
growth_forms_included_epiphytes,
growth_forms_included_notes,
taxa_included_all,
taxa_included_seed_plants,
taxa_included_ferns_lycophytes,
taxa_included_bryophytes,
taxa_included_exclusions
FROM plot_metadata_staging a JOIN datasource b
ON a.datasource=b.proximate_provider_name AND a.dataset=b.source_name
;

