-- --------------------------------------------------------
-- Correct known issues in raw data prior to submitting 
-- names to TNRS
-- --------------------------------------------------------

set search_path to :sch;

-- Correct bad dates
-- Easy hard-coded fixes that won't be caught by the date-
-- correction scrtipt correct_raw_ymd.sql
-- Avoid making correction here that will be fixed by correct_raw_ymd
-- as corrections at this stage will affect what gets stored in 
-- visiting_date_verbatim
UPDATE traits_raw
SET visiting_date=
case
WHEN visiting_date LIKE '%/%' THEN replace(visiting_date,'/','-')
when visiting_date='22-May-09' then '2009-May-22'
when visiting_date='3-Nov-10' then '2010-Nov-03'
when visiting_date='10-Jun-09' then '10-Jun-2009'
when visiting_date='15-Jun-09' then '15-Jun-2009'
when visiting_date='1-Jul-09' then '1-Jul-2009'
when visiting_date='24-Sep-09' then '24-Sep-2009'
when visiting_date='3-Dec-09' then '3-Dec-2009'
when visiting_date='6-Mar-09' then '6-Mar-2009'
else visiting_date
end
WHERE visiting_date IS NOT NULL
;

UPDATE traits_raw
SET observation_date=replace(observation_date,'/','-')
WHERE observation_date IS NOT NULL
AND observation_date LIKE '%/%'
;

-- Correct some particularly bad elevations
-- There corrections will allow generic script to parse
UPDATE traits_raw
SET elevation_m=trim(replace(elevation_m,'between',''))
WHERE elevation_m ILIKE '%between%'
;
UPDATE traits_raw
SET elevation_m=replace(elevation_m,' and ','-')
WHERE elevation_m ILIKE '% and %'
;

-- Standardize delimiters for splitting to array
UPDATE traits_raw
SET authorship=replace(authorship,'/',';')
WHERE authorship LIKE '%/%'
;
UPDATE traits_raw
SET authorship=replace(authorship,'&',';')
WHERE authorship LIKE '%&%'
;
UPDATE traits_raw
SET authorship=replace(authorship,',',';')
WHERE authorship LIKE '%,%'
;