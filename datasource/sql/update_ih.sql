-- --------------------------------------------------
-- Adds columns to ih to hold scrubbed political divisions
-- and decimal latitude and longitude
-- --------------------------------------------------

SET search_path TO :dev_schema;

ALTER TABLE ih
ADD COLUMN acronym TEXT,
ADD COLUMN fk_gnrs_id BIGINT,
ADD COLUMN poldiv_full TEXT,
ADD COLUMN country_verbatim TEXT,
ADD COLUMN state_province_verbatim TEXT,
ADD COLUMN country TEXT,
ADD COLUMN state_province TEXT,
ADD COLUMN latlong_verbatim TEXT,
ADD COLUMN lat_text TEXT,
ADD COLUMN long_text TEXT,
ADD COLUMN lat NUMERIC,
ADD COLUMN long NUMERIC
;

UPDATE ih
SET 
acronym="specimen_duplicate_institutions",
country_verbatim=TRIM(COALESCE("*AddPhysCountry",'')),
state_province_verbatim=TRIM(COALESCE("*AddPhysState",'')),
latlong_verbatim=TRIM(COALESCE("*AddEmuUserId"))
;

-- Correct some errors
UPDATE ih
SET country_verbatim='U.S.A'
WHERE (country_verbatim IS NULL OR country_verbatim='')
AND state_province_verbatim IN ('Georgia','Montana','New York','TX')
;
UPDATE ih
SET country_verbatim='Laos',
state_province_verbatim=NULL
WHERE (country_verbatim IS NULL OR country_verbatim='')
AND state_province_verbatim='Laos'
;
UPDATE ih
SET country_verbatim='Reunion',
state_province_verbatim=NULL 
WHERE acronym IN ('REU','STCR')
;
UPDATE ih
SET country_verbatim='Serbia',
state_province_verbatim=NULL
WHERE country_verbatim='Serbia and Montenegro'
;
UPDATE ih
SET country_verbatim='Sao tome e principe',
state_province_verbatim=NULL
WHERE acronym='STPH'
;

-- Populate poldiv fk in preparation for GNRS
UPDATE ih
SET poldiv_full=CONCAT_WS('@',
country_verbatim,
state_province_verbatim
)
;

-- Correct delimiter error & parse lat and long
UPDATE ih
SET latlong_verbatim=REPLACE(latlong_verbatim, ', ,', ', ')
WHERE latlong_verbatim LIKE '%, ,%'
;
UPDATE ih
SET 
lat_text=split_part(latlong_verbatim,',', 1),
long_text=split_part(latlong_verbatim,',', 2)
;

-- Update url to new format
ALTER TABLE ih ADD COLUMN url_old TEXT DEFAULT NULL;
UPDATE ih SET url_old="*url";
UPDATE ih
SET "*url"=REPLACE("*url",'ih/','ih/herbarium_details.php')
;

-- Extract decimal latitude and longitude
UPDATE ih
SET 
lat=
CASE
WHEN public.is_numeric(lat_text) THEN lat_text::numeric
ELSE null
END,
long=
CASE
WHEN public.is_numeric(long_text) THEN long_text::numeric
ELSE null
END
;

-- Flag any bad values of lat or long and delete all bad or null records
UPDATE ih
SET 
lat=
CASE
WHEN lat>90 OR lat<-90 THEN NULL
ELSE lat
END,
long=
CASE
WHEN long>180 OR long<-180 THEN NULL
ELSE long
END
;
DELETE FROM ih
WHERE lat IS NULL OR long IS NULL
;

-- Index the final table
DROP INDEX IF EXISTS ih_acronym_idx;
DROP INDEX IF EXISTS ih_fk_gnrs_id_idx;
DROP INDEX IF EXISTS ih_poldiv_full_idx;
DROP INDEX IF EXISTS ih_country_verbatim_idx;
DROP INDEX IF EXISTS ih_state_province_verbatim_idx;
DROP INDEX IF EXISTS ih_country_idx;
DROP INDEX IF EXISTS ih_state_province_idx;
DROP INDEX IF EXISTS ih_lat_idx;
DROP INDEX IF EXISTS ih_long_idx;

CREATE INDEX ih_acronym_idx ON ih (acronym);
CREATE INDEX ih_fk_gnrs_id_idx ON ih (fk_gnrs_id);
CREATE INDEX ih_poldiv_full_idx ON ih (poldiv_full);
CREATE INDEX ih_country_verbatim_idx ON ih (country_verbatim);
CREATE INDEX ih_state_province_verbatim_idx ON ih (state_province_verbatim);
CREATE INDEX ih_country_idx ON ih (country);
CREATE INDEX ih_state_province_idx ON ih (state_province);
CREATE INDEX ih_lat_idx ON ih (lat);
CREATE INDEX ih_long_idx ON ih (long);