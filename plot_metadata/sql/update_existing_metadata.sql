-- 
-- Add existing metadata from analytical table vfoi
-- Done as separate step to avoid duplicate plot records
-- 

SET search_path TO :dev_schema;

-- Update just dataowner, plot area and methodology
UPDATE plot_metadata AS a
SET 
dataowner=b.dataowner,
methodology_description=b.sampling_protocol,
plot_area_ha=b.plot_area_ha
FROM (
SELECT DISTINCT
plot_metadata_id,
datasource,
plot_name,
dataowner,
sampling_protocol,
plot_area_ha
FROM existing_plot_metadata_temp 
) AS b
WHERE a.plot_metadata_id=b.plot_metadata_id
;

-- Transfer methodology description which are names for standard protocols
UPDATE plot_metadata
SET sampling_protocol=
CASE
WHEN methodology_description='Point-intercept' THEN 'Point-intercept'
WHEN methodology_description='CVS Protocol.  Pines >=2.5 cm DBH supersampled at 125%' THEN 'Carolina Vegetation Survey Standard Sampling Method (Variant; see methodology_description)'
WHEN methodology_description LIKE 'Carolina Vegetation Survey Standard Sampling Method%' THEN 'Carolina Vegetation Survey Standard Sampling Method'
WHEN methodology_description LIKE '0.01 ha, stems >= 10 cm dbh%' THEN '0.01 ha tree plot, stems >= 10 cm dbh'
WHEN methodology_description='1 ha, stems >= 10 cm dbh' THEN '1 ha tree plot, stems >= 10 cm dbh'
WHEN methodology_description='0.1 ha  transect, stems >= 2.5 cm dbh' THEN '0.1 ha  transect, stems >= 2.5 cm dbh'
ELSE NULL
END
WHERE methodology_description IS NOT NULL
;

UPDATE plot_metadata
SET methodology_reference='http://www.bio.unc.edu/faculty/peet/lab/CVS/'
WHERE sampling_protocol LIKE 'Carolina Vegetation Survey Standard Sampling Method%';

-- Update remaining fields
UPDATE plot_metadata AS a
SET 
country_verbatim=b.country_verbatim,
state_province_verbatim=b.state_province_verbatim,
county_verbatim=b.county_verbatim,
locality=b.locality,
latitude=b.latitude,
longitude=b.longitude,
coord_uncertainty_m=b.coord_uncertainty_m,
georef_sources=b.georef_sources,
georef_protocol=b.georef_protocol,
event_date=b.event_date,
elevation_m=b.elevation_m,
slope_aspect_deg=b.slope_aspect_deg,
slope_gradient_deg=b.slope_gradient_deg,
temperature_c=b.temperature_c,
precip_mm=b.precip_mm,
community_concept_name=b.community_concept_name
FROM (
SELECT DISTINCT
plot_metadata_id,
country_verbatim,
state_province_verbatim,
county_verbatim,
locality,
latitude,
longitude,
coord_uncertainty_m,
georef_sources,
georef_protocol,
event_date,
elevation_m,
slope_aspect_deg,
slope_gradient_deg,
temperature_c,
precip_mm,
community_concept_name
FROM existing_plot_metadata_temp 
) AS b
WHERE a.plot_metadata_id=b.plot_metadata_id
;

