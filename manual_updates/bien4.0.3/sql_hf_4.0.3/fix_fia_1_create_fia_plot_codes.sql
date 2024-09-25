-- ----------------------------------------------------------------
-- Create table of corrected FIA plot codes
-- Parameter reclim for testing only
-- ----------------------------------------------------------------

SET search_path TO :sch;

--
-- Create the table
-- 

DROP TABLE IF EXISTS fia_plot_codes;
CREATE TABLE fia_plot_codes AS
SELECT 
taxonobservation_id,
plot_name,
country_verbatim,
state_province_verbatim,
county_verbatim,
country,
state_province,
county,
CAST(NULL AS text) AS state_code,
CAST(NULL AS text) AS county_code,
plot_name AS plot_name_new,
CAST(0 AS smallint) AS plot_name_changed
FROM view_full_occurrence_individual
WHERE datasource='FIA'
:reclim
;

CREATE INDEX ON fia_plot_codes (country);
CREATE INDEX ON fia_plot_codes (state_province);
CREATE INDEX ON fia_plot_codes (county);

--
-- Populate standard state and county codes
--

UPDATE fia_plot_codes a
SET state_code=b.state_province_code
FROM state_province b
WHERE a.country=b.country
AND a.state_province=b.state_province_std
;
UPDATE fia_plot_codes a
SET county_code=b.county_parish_code
FROM county_parish b
WHERE a.country=b.country
AND a.state_province=b.state_province
AND a.county=b.county_parish_std
;

CREATE INDEX ON fia_plot_codes (state_code);
CREATE INDEX ON fia_plot_codes (county_code);
CREATE INDEX ON fia_plot_codes (state_province_verbatim);
CREATE INDEX ON fia_plot_codes (county_verbatim);
CREATE INDEX ON fia_plot_codes (plot_name_changed);

-- 
-- Form the concatenated plot codes
-- 

-- State code + county code + plot code
UPDATE fia_plot_codes
SET plot_name_new=CONCAT_WS('.',state_code,county_code,plot_name),
plot_name_changed=1
WHERE state_code IS NOT NULL AND county_code IS NOT NULL
;

-- State code + verbatim county name + plot code
UPDATE fia_plot_codes
SET plot_name_new=CONCAT_WS('.',
state_code,
REPLACE(county_verbatim,' ',''),
plot_name
),
plot_name_changed=1
WHERE state_code IS NOT NULL 
AND county_code IS NULL
AND county_verbatim IS NOT NULL AND county_verbatim<>'' 
AND plot_name_changed=0
;

-- Verbatim state name + verbatim county name + plot code
UPDATE fia_plot_codes
SET plot_name_new=CONCAT_WS('.',
REPLACE(state_province_verbatim,' ',''),
REPLACE(county_verbatim,' ',''),
plot_name
),
plot_name_changed=1
WHERE state_code IS NULL 
AND county_code IS NULL
AND state_province_verbatim IS NOT NULL AND state_province_verbatim<>'' 
AND county_verbatim IS NOT NULL AND county_verbatim<>'' 
AND plot_name_changed=0
;

-- State code + plot code
UPDATE fia_plot_codes
SET plot_name_new=CONCAT_WS('.',
state_code,
plot_name
),
plot_name_changed=1
WHERE state_code IS NOT NULL 
AND county_code IS NULL
AND ( county_verbatim IS NULL OR county_verbatim='' )
AND plot_name_changed=0
;

-- Verbatim state name + plot code
UPDATE fia_plot_codes
SET plot_name_new=CONCAT_WS('.',
REPLACE(state_province_verbatim,' ',''),
plot_name
),
plot_name_changed=1
WHERE state_code IS NULL 
AND state_province_verbatim IS NOT NULL AND state_province_verbatim<>''  
AND county_code IS NULL
AND ( county_verbatim IS NULL OR county_verbatim='' )
AND plot_name_changed=0
;

-- 
-- Add primary key for joining back to vfoi
-- 
ALTER TABLE fia_plot_codes ADD PRIMARY KEY ( taxonobservation_id );

