-- ---------------------------------------------------------
-- Update by batches
-- 
-- NOTE: all fields involved in joins or where clauses must
-- be indexed or this will be excruciatingly slow. Recommend
-- running vacuum analyze on both tables (after adding columns 
-- and indexes). Also ensure that "gbifID" is the primary key 
-- of table "GBIF".occurrence
-- ---------------------------------------------------------

set search_path to :SCH;

:WORK_MEM_SET

WITH cte AS (
   SELECT :PK          -- pk column
   FROM :TBL
   WHERE updated is NULL
   LIMIT :BATCHSIZE  
   )
UPDATE :TBL a
SET    updated = 'pending' 
FROM   cte
WHERE  a.:"PK"  = cte.:"PK"
;

UPDATE :TBL a
SET 
datasetkey=b."datasetKey",
updated='done'
FROM "GBIF".occurrence b
WHERE a.catalog_number=b."gbifID"
AND a.updated='pending'
;

-- Mark record missed
UPDATE :TBL a
SET updated='failed'
WHERE updated='pending'
;

:WORK_MEM_RESET
