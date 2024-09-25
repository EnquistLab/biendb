--
-- Adds missing stem data
-- Assumes schema already updated for analytical_stem_dev
-- 

-- Create new astaging tables
DROP TABLE IF EXISTS vfoi_staging;
CREATE TABLE vfoi_staging (LIKE view_full_occurrence_individual_dev);
ALTER TABLE vfoi_staging ALTER taxonobservation_id DROP NOT NULL;
ALTER TABLE vfoi_staging ADD COLUMN vfoi_staging_id BIGSERIAL PRIMARY KEY;

DROP TABLE IF EXISTS analytical_stem_staging;
CREATE TABLE analytical_stem_staging (LIKE analytical_stem_dev);
ALTER TABLE analytical_stem_staging ADD COLUMN vfoi_staging_id BIGINT NOT NULL;
CREATE INDEX ON analytical_stem_staging (vfoi_staging_id);

-- Drop autoincrement on PK 
ALTER TABLE vfoi_staging DROP COLUMN vfoi_staging_id;
ALTER TABLE vfoi_staging ADD COLUMN vfoi_staging_id BIGINT PRIMARY KEY;

-- Insert observations to vfoi_staging
-- Note use of the artificial PK "id" as identifier for individual as well,
-- in column "individual_id"
-- Also note reuse of PK from raw data as PK vfoi_staging_id
INSERT INTO vfoi_staging (
vfoi_staging_id,
observation_type,
plot_metadata_id,
datasource_id,
datasource,
dataset,
dataowner,
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
geodeticDatum,
coord_uncertainty_m,
coord_uncertainty_verbatim,
coord_max_uncertainty_km,
georef_sources,
georef_protocol,
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
event_date,
event_date_accuracy,
elevation_verbatim,
elevation_m,
elevation_min_m,
elevation_max_m,
slope_aspect_deg,
slope_gradient_deg,
plot_area_ha,
sampling_protocol,
temperature_c,
precip_mm,
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
date_collected,
date_collected_accuracy,
identified_by,
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
fk_tnrs_id,
family_matched,
name_matched,
name_matched_author,
tnrs_name_matched_score,
tnrs_warning,
matched_taxonomic_status,
scrubbed_taxonomic_status,
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
stem_height_m,
cover_percent,
cites,
iucn,
usda_federal,
usda_state,
is_embargoed_observation,
geom,
nsr_id,
native_status_country,
native_status_state_province,
native_status_county_parish,
native_status,
native_status_reason,
native_status_sources,
isintroduced,
is_cultivated_in_region,
citation_verbatim,
citation,
is_new,
is_cultivated_observation,
is_cultivated_observation_basis
) 
SELECT
b.id,
'plot',
NULL,
NULL,
'gillespie',
'gillespie',
'gillespie',
"country",
"state",
"pol2",
NULL,
NULL,
NULL,
"locality_description",
concat_ws(' ',"lat_dec","long_dec"),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
a."plot_code",
"subplot",
NULL,
NULL,
NULL,
NULL,
"elev_m",
CASE 
WHEN "elev_m"='coastal woodland' THEN 0::numeric
WHEN "elev_m"~E'^\\d+$' THEN "elev_m"::numeric 
ELSE null 
END,
NULL,
NULL,
NULL,
NULL,
case
when "plot_area_ha" is null or "plot_area_ha"='' then null
else cast("plot_area_ha" as double precision)
end,
'0.1 ha  transect, stems >= 2.5 cm dbh',
CASE 
WHEN "mean_ann_temp_c"~E'^\\d+$' THEN "mean_ann_temp_c"::numeric ELSE NULL 
END,
CASE 
WHEN "tot_ann_precip_mm"~E'^\\d+$' THEN "tot_ann_precip_mm"::numeric ELSE NULL 
END,
NULL,
trim(concat_ws('; ',"holdridge_life_zone","locality_description")),
array["holdridge_life_zone"],
array['Thomas Gillespie'],
NULL,
NULL,
"id",
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
"family",
"species",
trim(concat_ws(' ',"family","species")),
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
case
when "habit"='T' then 'Tree'
when "habit"='L' then 'Liana'
when "habit"='H' then 'Hemiepiphyte'
when "habit"='S' then 'Shrub'
when "habit"='E' then 'Epiphyte'
when "habit"='P' then 'Parasite'
else "habit"
end,
NULL,
"comments",
NULL,
NULL,
NULL,
NULL,
NULL,
"id",
1,
case
when "height_m"=null or trim("height_m")='' then null
else cast("height_m" as numeric(5,2))
end,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
"plot_notes",
NULL,
1,
0,
'Source database'
FROM gillespie_plot_descriptions_raw a JOIN gillespie_plot_data_raw b
ON a.plot_code=b.plot_code
;


-- Populate fk taxonobservation_id in vfoi_staging
CREATE TABLE vfoi_gillespie AS
SELECT * FROM view_full_occurrence_individual_dev
WHERE datasource='gillespie'
;
CREATE INDEX ON vfoi_gillespie (catalog_number);
CREATE INDEX ON vfoi_staging (catalog_number);

UPDATE vfoi_staging a
SET taxonobservation_id=b.taxonobservation_id
FROM vfoi_gillespie b
WHERE a.catalog_number=b.catalog_number
;
CREATE INDEX ON vfoi_staging (taxonobservation_id);

-- Compare the records
SELECT
a.catalog_number, b.catalog_number,
a.datasource, b.datasource,
a.plot_name, b.plot_name,
a.subplot, b.subplot,
a.verbatim_scientific_name AS taxon_a, b.verbatim_scientific_name AS taxon_b
FROM view_full_occurrence_individual_dev a JOIN vfoi_staging b
ON a.taxonobservation_id=b.taxonobservation_id
LIMIT 12
;

-- Insert stem records to analytical_stem_staging
-- Run: import_gillespies/import.sh
-- commend out everything before: echoi $e -n "-- analytical_stem_staging..."
-- precede this will the following command: sql_limit=""

-- Update taxonobservation_id
UPDATE analytical_stem_staging a
SET taxonobservation_id=b.taxonobservation_id
FROM vfoi_staging b
WHERE a.vfoi_staging_id=b.vfoi_staging_id
;

-- Check the stem staging table
CREATE INDEX ON analytical_stem_staging (taxonobservation_id);

SELECT
a.datasource, b.datasource,
a.plot_name, b.plot_name,
a.subplot, b.subplot,
a.verbatim_scientific_name AS taxon_a, b.verbatim_scientific_name AS taxon_b,
b.stem_dbh_cm
FROM view_full_occurrence_individual_dev a JOIN analytical_stem_staging b
ON a.taxonobservation_id=b.taxonobservation_id
LIMIT 12
;

-- Load from staging to final stem table
INSERT INTO analytical_stem_dev (
taxonobservation_id,
datasource,
individual_id,
individual_count,
tag,
relative_x_m,
relative_y_m,
stem_code,
stem_dbh_cm_verbatim,
stem_dbh_cm,
stem_height_m_verbatim,
stem_height_m
)
SELECT
taxonobservation_id,
datasource,
individual_id,
individual_count,
tag,
relative_x_m,
relative_y_m,
stem_code,
stem_dbh_cm_verbatim,
stem_dbh_cm,
stem_height_m_verbatim,
stem_height_m
FROM analytical_stem_staging
;

-- PK and remaining columns will be populated later

DROP TABLE vfoi_gillespie;