-- ---------------------------------------------------------
-- Update vfoi by batches
-- ---------------------------------------------------------

set search_path to analytical_db;

UPDATE vfoi_test
SET updated='pending' 
WHERE taxonobservation_id IN (
SELECT taxonobservation_id
FROM vfoi_test
WHERE datasource='GBIF'
AND catalog_number IS NOT NULL
AND provider_dataset_id IS NULL
AND updated is null
LIMIT :batchsize
)
;

UPDATE vfoi_test a
SET update=1
WHERE datasource<>'GBIF'
;



UPDATE vfoi_test a
SET datasetkey=b."datasetKey",
updated=1
FROM "GBIF".occurrence b
WHERE a.catalog_number=b."gbifID"
AND updated is null
LIMIT 10
;


LIMIT :batchsize
;

UPDATE vfoi_test
SET updated='failed'
WHERE updated='pending'
;