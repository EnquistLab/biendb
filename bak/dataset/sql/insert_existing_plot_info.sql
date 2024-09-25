-- 
-- Inserts existing information from plot_metadata
--

SET search_path TO :dev_schema;

-- Set default access condition as acknowledge
-- Will change this later for individual plot data sources
INSERT INTO datasource (
proximate_provider_name,
source_name,
source_fullname,
source_type,
observation_type,
is_herbarium,
access_conditions,
access_level
)
SELECT DISTINCT
datasource,
dataset,
dataset,
'data owner',
'plot',
0,
'acknowledge',
'public'
FROM plot_metadata;

CREATE INDEX ON datasource (proximate_provider_name);
CREATE INDEX ON datasource (source_name);

-- Do the following separately to avoid duplicate records
UPDATE datasource AS a
SET
primary_contact_fullname=dataowner,
primary_contact_email=primary_dataowner_email
FROM plot_metadata b
WHERE a.proximate_provider_name=b.datasource
AND a.source_name=b.dataset
;

-- Update access levels for non-public data
UPDATE datasource
SET access_level='private',
access_conditions='contact authors'
WHERE proximate_provider_name='Madidi'
;


-- Update datasource with known locality errors added
UPDATE datasource
SET locality_error_added=TRUE,
locality_error_details='Fuzzing and swapping. Fuzzing: random error up to +/- 1 mi added to coordinates. Swapping: localities swapped between <=20% of private plots within a county; plots on public lands not swapped. Exact amount of fuzzing error and whether or not locality has been swapped is not known for individual plots'
WHERE proximate_provider_name='FIA'
;
UPDATE datasource
SET locality_error_added=TRUE,
locality_error_details='Reduced precision, selected plots only. Coordinate precision as been reduced to protect endangered species and/or hide locality of private land. Reduction in precision for each plot, if any, is indicated in column coord_uncertainty_m'
WHERE proximate_provider_name='VegBank'
;
UPDATE datasource
SET locality_error_added=TRUE,
locality_error_details='Reduced precision, selected plots only. Coordinate precision as been reduced to protect endangered species and/or hide locality of private land. Reduction in precision for each plot, if any, is indicated in column coord_uncertainty_m'
WHERE proximate_provider_name='CVS'
;


