-- -------------------------------------------------------------------------
-- Make development copy of plot_metadata and inset non-FIA and updated
-- FIA records
-- -------------------------------------------------------------------------

SET search_path to :sch;

DROP TABLE IF EXISTS plot_metadata_dev;
CREATE TABLE plot_metadata_dev ( LIKE plot_metadata INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES );

-- 
-- Insert non-FIA records, reusing existing PKs
-- 

INSERT INTO plot_metadata_dev 
SELECT * 
FROM plot_metadata
WHERE datasource<>'FIA'
:reclim
;

-- 
-- Make PK auto-increment and set next value
-- 
CREATE SEQUENCE plot_metadata_dev_plot_metadata_id_seq;

ALTER TABLE plot_metadata_dev ALTER COLUMN plot_metadata_id SET DEFAULT nextval('plot_metadata_dev_plot_metadata_id_seq');

ALTER TABLE plot_metadata_dev ALTER COLUMN plot_metadata_id SET NOT NULL;

ALTER SEQUENCE plot_metadata_dev_plot_metadata_id_seq OWNED BY plot_metadata_dev.plot_metadata_id;

SELECT setval('plot_metadata_dev_plot_metadata_id_seq', COALESCE((
SELECT MAX(plot_metadata_id)+1 FROM plot_metadata_dev), 
1),false);

-- 
-- Insert new FIA plot recoreds
-- 

DROP INDEX IF EXISTS vfoi_dev_datasource_idx;
CREATE INDEX vfoi_dev_datasource_idx ON vfoi_dev (datasource);

-- WARNING: Hard-wired. Note use of fixed FK value from table datasource
-- Parameter :reclim for testing only
INSERT INTO plot_metadata_dev (
datasource,
dataset,
dataowner,
plot_name,
plot_name_full,
country_verbatim,
state_province_verbatim,
county_verbatim,
country,
state_province,
county,
latlong_verbatim,
latitude,
longitude,
georef_sources,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
is_new_world,
event_date,
slope_aspect_deg,
slope_gradient_deg,
sampling_protocol,
datasource_id,
abundance_measurement,
methodology_reference
)
SELECT DISTINCT
'FIA',
'U.S. Forest Inventory and Analysis (FIA) National Program',
'Greg Reams',
plot_name,
plot_name,
country_verbatim,
state_province_verbatim,
county_verbatim,
country,
state_province,
county,
latlong_verbatim,
latitude,
longitude,
georef_sources,
is_in_country,
is_in_state_province,
is_in_county,
is_geovalid,
is_new_world,
event_date,
slope_aspect_deg,
slope_gradient_deg,
'US Forest Inventory and Analysis Sampling Protocol',
65,
'individuals',
'http://www.fia.fs.fed.us/library/field-guides-methods-proc/'
FROM vfoi_dev
WHERE datasource='FIA'
:reclim
;

-- Keep the index on datasource, needed for next step
-- DROP INDEX IF EXISTS vfoi_dev_datasource_idx;
