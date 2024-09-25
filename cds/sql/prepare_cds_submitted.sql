-- ---------------------------------------------------------
-- Extract table of all unique geocoordinates from
-- vfoi and agg_traits in preparation for scrubbing with
-- CDS
-- ---------------------------------------------------------

SET search_path TO :sch;

--
-- Fix plot_metadata; troubleshoot later
-- 

-- Make sure latlong_verbatim is empty string, not NULL,
-- so it can be used as foreign key
UPDATE plot_metadata
SET latlong_verbatim=''
WHERE TRIM(latlong_verbatim)='' OR latlong_verbatim IS NULL
;
-- Populate with resolved lat/long, if any
UPDATE plot_metadata
SET latlong_verbatim=CONCAT_WS(', ',
latitude, 
longitude
)
WHERE latlong_verbatim=''
AND (latitude IS NOT NULL OR longitude IS NOT NULL)
;

--
-- Create cds_submitted & populate
-- 

DROP TABLE IF EXISTS cds_submitted;
CREATE TABLE cds_submitted (
latlong_verbatim TEXT DEFAULT '',
latitude_verbatim TEXT DEFAULT '',
longitude_verbatim TEXT DEFAULT ''
);

INSERT INTO cds_submitted (
latlong_verbatim,
latitude_verbatim,
longitude_verbatim
)
SELECT DISTINCT
latlong_verbatim,
latitude::text,
longitude::text
FROM view_full_occurrence_individual_dev
WHERE latlong_verbatim<>'' AND (latitude IS NOT NULL OR longitude IS NOT NULL)
;

INSERT INTO cds_submitted (
latlong_verbatim,
latitude_verbatim,
longitude_verbatim
)
SELECT DISTINCT
latlong_verbatim,
latitude::text,
longitude::text
FROM plot_metadata
WHERE latlong_verbatim<>'' AND (latitude IS NOT NULL OR longitude IS NOT NULL)
;

INSERT INTO cds_submitted (
latlong_verbatim,
latitude_verbatim,
longitude_verbatim
)
SELECT DISTINCT
latlong_verbatim,
latitude::text,
longitude::text
FROM agg_traits
WHERE latlong_verbatim<>'' AND (latitude IS NOT NULL OR longitude IS NOT NULL)
;

INSERT INTO cds_submitted (
latlong_verbatim,
latitude_verbatim,
longitude_verbatim
)
SELECT DISTINCT
latlong_verbatim,
TRIM(lat_text),
TRIM(long_text)
FROM ih
WHERE latlong_verbatim<>'' AND (lat_text IS NOT NULL OR long_text IS NOT NULL)
;

--
-- Populate mis-formed coordinates that couldn't be parsed to lat/long
-- by copying latlong_verbatim to latitude column. This will
-- include them in the CDS input. CDS can handle them.
--

UPDATE cds_submitted
SET 
latitude_verbatim=latlong_verbatim,
longitude_verbatim=''
WHERE (
latitude_verbatim='' OR latitude_verbatim IS NULL
OR longitude_verbatim='' OR longitude_verbatim IS NULL
)
AND latlong_verbatim<>'' AND latlong_verbatim IS NOT NULL
;

-- Finally, delete any empty/null values of latlong_verbatim
-- If they haven't been fixed in original table, it is too late to 
-- fix them here, and they will cause problems on re-import
DELETE FROM cds_submitted 
WHERE  latlong_verbatim='' OR latlong_verbatim IS NULL
;

DROP TABLE IF EXISTS cds_submitted_temp;
CREATE TABLE cds_submitted_temp (LIKE cds_submitted);

-- Just insert PK to eliminate duplicates due to slight differences
-- in padding whitespace. This is faster than trimming extract
-- from each table. Critical to avoid PK anomalies on update!
INSERT INTO cds_submitted_temp (
latlong_verbatim,
latitude_verbatim,
longitude_verbatim
)
SELECT DISTINCT
latlong_verbatim,
TRIM(latitude_verbatim),
TRIM(longitude_verbatim)
FROM cds_submitted
;

ALTER TABLE cds_submitted_temp ADD PRIMARY KEY (latlong_verbatim);

DROP TABLE cds_submitted;
ALTER TABLE cds_submitted_temp RENAME TO cds_submitted;