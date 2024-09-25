-- -------------------------------------------------------------
-- Prepare table of herbarium coordinates
-- -------------------------------------------------------------

SET search_path TO :sch;

-- Create table of herbarium coordinates
DROP TABLE IF EXISTS cultobs_herbaria;
CREATE TABLE cultobs_herbaria AS 
SELECT "*NamOrganisation" AS herb_name,
acronym,
country,
state_province,
lat,
long
FROM ih
WHERE lat IS NOT NULL AND long IS NOT NULL
AND country IS NOT NULL
;

-- Temporary fix for stupid apostrophes state names, mostly Russia
-- Need to fix this permanently in GNRS
UPDATE cultobs_herbaria
SET state_province=REPLACE(state_province,'''','')
WHERE state_province LIKE '%''%'
;

-- Flag any bad values of lat or long and delete all bad or null records
-- May not be necessary but just in case
UPDATE cultobs_herbaria
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
DELETE FROM cultobs_herbaria
WHERE lat IS NULL OR long IS NULL
;


-- Index the final table
DROP INDEX IF EXISTS herbaria_acronym_idx;
DROP INDEX IF EXISTS herbaria_country_idx;
DROP INDEX IF EXISTS herbaria_state_province_idx;
DROP INDEX IF EXISTS herbaria_lat_idx;
DROP INDEX IF EXISTS herbaria_long_idx;

CREATE INDEX herbaria_acronym_idx ON cultobs_herbaria (acronym);
CREATE INDEX herbaria_country_idx ON cultobs_herbaria (country);
CREATE INDEX herbaria_state_province_idx ON cultobs_herbaria (state_province);
CREATE INDEX herbaria_lat_idx ON cultobs_herbaria (lat);
CREATE INDEX herbaria_long_idx ON cultobs_herbaria (long);