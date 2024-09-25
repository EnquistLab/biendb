-- ------------------------------------------------------------------
-- Standlone SQL code to test adding & populating column datasetkey 
-- in table vfoi
-- 
-- Both vfoi and "GBIF".occurrence must be indexed for any columns
-- involved in joins or where criteria. Also run vacuum analyze on
-- both
-- ------------------------------------------------------------------

-- Make database and schema parameters in final script
\c vegbien
set search_path to analytical_db;

-- Make temporary test table
drop table if exists vfoi_test;
create table vfoi_test as select * from view_full_occurrence_individual limit 100;

-- Make sure we have a mix of sources
--select datasource, count(*) from vfoi_test group by datasource;

ALTER TABLE vfoi_test
ADD COLUMN datasetkey text, 
ADD COLUMN updated text default null
;

-- Mark non-applicable records
UPDATE vfoi_test a
SET updated='na'
WHERE datasource<>'GBIF'
;

DROP INDEX IF EXISTS vfoi_test_updated_idx;
CREATE INDEX vfoi_test_updated_idx ON vfoi_test(updated);


--
-- Repeat the next three queries until the last query returns FALSE ('f')
--

-- Use common table expression to mark batch of records to be updated
WITH cte AS (
   SELECT taxonobservation_id          -- pk column
   FROM vfoi_test
   WHERE updated is NULL
   LIMIT 10   -- Make this parameter :BATCHSIZE in final script
   )
UPDATE vfoi_test a
SET    updated = 'pending' 
FROM   cte
WHERE  a.taxonobservation_id = cte.taxonobservation_id
;

-- Run the update on the marked batch of records
UPDATE vfoi_test a
SET datasetkey=b."datasetKey",
updated='done'
FROM "GBIF".occurrence b
WHERE a.catalog_number=b."gbifID"
AND updated='pending'
;

-- Returns 't' if all records updated, 'f' if non-updated records remaining
SELECT NOT EXISTS (
SELECT taxonobservation_id FROM vfoi_test WHERE updated IS NULL LIMIT 1
) AS done
;

/* 
-- More granular inspection of update progress
select datasource, updated, count(*) from vfoi_test group by datasource, updated;
 */
 
-- Remove the temporary column
ALTER TABLE vfoi_test
DROP COLUMN updated
;




