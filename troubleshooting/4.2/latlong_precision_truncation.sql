-- Investigate truncation of coordinate precision

set search_path to analytical_db_dev;

-- Make table of problem records
DROP TABLE IF EXISTS temp_latlong_truncation;
CREATE TABLE temp_latlong_truncation AS 
SELECT * FROM (
SELECT taxonobservation_id, datasource, 
latlong_verbatim, latitude, longitude, 
LENGTH(split_part(split_part(latlong_verbatim,',',1),'.',2)) AS latlong_verbatim_lat_pr,
LENGTH(split_part(split_part(latlong_verbatim,',',2),'.',2)) AS latlong_verbatim_long_pr,
LENGTH(split_part(split_part(latitude::text,',',1),'.',2)) AS lat_pr,
LENGTH(split_part(split_part(longitude::text,',',1),'.',2)) AS long_pr
FROM view_full_occurrence_individual_dev 
WHERE latlong_verbatim LIKE '%,%' 
AND latitude IS NOT NULL AND longitude IS NOT NULL
) as a
WHERE latlong_verbatim_lat_pr IS NOT NULL AND latlong_verbatim_long_pr IS NOT NULL
AND (latlong_verbatim_lat_pr<>lat_pr OR latlong_verbatim_long_pr<>long_pr)
;

create index temp_latlong_truncation_datasource_idx on temp_latlong_truncation(datasource);

-- Summarize the scale of the problem

/*
vegbien=# select count(*) from temp_latlong_truncation ;
  count   
----------
 44279599
(1 row)

vegbien=# select datasource, count(*) from temp_latlong_truncation group by datasource;
 datasource  |  count   
-------------+----------
 ACAD        |    44403
 ARIZ        |    79971
 BRIT        |     1095
 chilesp     |    16744
 CTFS        |    11571
 CVS         |   681056
 dryflor     |   192259
 FIA         | 12863980
 GBIF        |      120
 HVAA        |     3668
 JBM         |      211
 Madidi      |   170600
 MO          |  2676465
 NCU         |     5817
 ntt         |  1132466
 NY          |   346773
 QFA         |    41700
 rainbio     |   610145
 REMIB       |   320977
 SALVIAS     |   134311
 schep       |    16208
 SpeciesLink |   649962
 TEAM        |   186548
 TEX         |    31145
 traits      | 23024502
 TRT         |     8769
 TRTE        |      100
 U           |    57188
 UBC         |    65825
 VegBank     |   891033
 WIN         |    13987
(31 rows)
*/

--
-- Query original table, showing CAST issue

set search_path to public;

-- Original values are simply "latitude" and "longitude", both
-- double precision.
-- Note how casting as numeric truncates decimals
SELECT latitude, longitude, 
CAST(CONCAT_WS(', ',latitude,longitude) AS TEXT) AS latlong_verbatim,
CAST(latitude AS NUMERIC) AS lat_numeric, 
CAST(longitude AS  NUMERIC) AS long_numeric
from view_full_occurrence_individual
limit 50
;

-- Solution: cast to text, then numeric!
SELECT latitude, longitude, 
CAST(CONCAT_WS(', ',latitude,longitude) AS TEXT) AS latlong_verbatim,
CAST(latitude AS NUMERIC) AS lat_numeric, 
CAST(longitude AS  NUMERIC) AS long_numeric,
CAST(latitude::text AS NUMERIC) AS lat_numeric2, 
CAST(longitude::text AS NUMERIC) AS long_numeric2
from view_full_occurrence_individual
limit 50
;