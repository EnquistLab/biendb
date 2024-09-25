-- -----------------------------------------------------------------
-- Creates and populates tables state_province and county_parish in
-- database geoscrub
-- -----------------------------------------------------------------

DROP TABLE IF EXISTS state_province;
CREATE TABLE state_province AS (
SELECT geonameid,
CAST(NULL AS TEXT) AS country,
countrycode,
name AS state_province,
asciiname,
admin1code,
featureclass,
featurecode,
latitude,
longitude
FROM geonames
WHERE featureclass='A' AND featurecode='ADM1'
ORDER BY countrycode, admin1code
);

ALTER TABLE state_province ADD PRIMARY KEY (geonameid);
CREATE INDEX ON state_province (state_province);
CREATE INDEX ON state_province (countrycode);
CREATE INDEX ON state_province (asciiname);
CREATE INDEX ON state_province (admin1code);

UPDATE state_province a
SET country=b.country
FROM countries b
WHERE a.countrycode=b.iso
;

CREATE INDEX ON state_province (country);

DROP TABLE IF EXISTS county_parish;
CREATE TABLE county_parish AS (
SELECT geonameid,
CAST(NULL AS TEXT) AS country,
countrycode,
CAST(NULL AS TEXT) AS state_province,
admin1code,
name AS county_parish,
asciiname,
admin2code,
featureclass,
featurecode,
latitude,
longitude
FROM geonames
WHERE featureclass='A' AND featurecode='ADM2'
ORDER BY countrycode, admin1code, name
);

ALTER TABLE county_parish ADD PRIMARY KEY (geonameid);
CREATE INDEX ON county_parish (county_parish);
CREATE INDEX ON county_parish (countrycode);
CREATE INDEX ON county_parish (asciiname);
CREATE INDEX ON county_parish (admin2code);
CREATE INDEX ON county_parish (admin1code);

-- Populate state_province name to make tale more readable
UPDATE county_parish a
SET 
state_province=b.state_province,
country=b.country
FROM state_province b
WHERE a.countrycode=b.countrycode
AND a.admin1code=b.admin1code
;

CREATE INDEX ON county_parish (state_province);
CREATE INDEX ON county_parish (country);


