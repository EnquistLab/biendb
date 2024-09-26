-- ---------------------------------------------------------------
-- Diagnose & fix source of duplicate values of candidate key
-- "latlong_verbatim" in table "cds"
--
-- BIEN DB 4.2. Implemented during initial construction of DB, as 
-- part of pipeline step 2. Fixed pipeline as well.
-- ---------------------------------------------------------------

set search_path to analytical_db_dev;

--
-- Diagnosis
--

-- Confirm key column not unique
SELECT NOT EXISTS (
SELECT latlong_verbatim, COUNT(*) 
FROM cds 
GROUP BY latlong_verbatim HAVING COUNT(*)>1 
LIMIT 1
) AS is_unique
;
/*
is_unique 
-------------
 f
(1 row)
*/\

-- Examine a few offending values
SELECT latlong_verbatim, COUNT(*) 
FROM cds 
GROUP BY latlong_verbatim 
HAVING COUNT(*)>1
LIMIT 12
;
/*
 latlong_verbatim | count 
------------------+-------
                  |   115
(1 row)
Aha! key violation are all due to NULLs
*/


--
-- Add the following lines to cds/sql/alter_cds.sql
--

-- Populate latlong_verbatim directly if either latitude_verbatim
-- or longitude_verbatim is null
UPDATE cds
SET latlong_verbatim=CONCAT_WS(', ',latitude_verbatim, longitude_verbatim)
WHERE latlong_verbatim='' OR latlong_verbatim IS NULL
;

-- Remove any remaining rows with NULL/empty values of
-- latlong_verbatim. These will cause crash due to PK violation
-- when attempting to update original tables.
DELETE FROM cds
WHERE latlong_verbatim='' OR latlong_verbatim IS NULL
;

SELECT NOT EXISTS (
SELECT latlong_verbatim, COUNT(*) 
FROM cds 
GROUP BY latlong_verbatim HAVING COUNT(*)>1 
LIMIT 1
) AS is_unique
;
/*
is_unique 
-------------
 t
(1 row)
*/

-- Also added code to cds/sql/prepare_cds_submitted.sql to avoid
-- introducing duplicate values in the first place. All probably 
-- came from plot_metadata.
