-- ----------------------------------------------------------------------
-- Add columns to hold provider-supplied dataset IDs
-- ----------------------------------------------------------------------

SET search_path TO :SCH;

ALTER TABLE :TBL
DROP COLUMN IF EXISTS datasetkey,
DROP COLUMN IF EXISTS updated
;
ALTER TABLE :TBL
ADD COLUMN datasetkey text, 
ADD COLUMN updated text default null
;

:WORK_MEM_SET

UPDATE :TBL a
SET updated='na'
WHERE datasource<>'GBIF'
;

DROP INDEX IF EXISTS :IDX_NAME;
CREATE INDEX :IDX_NAME ON :"TBL"(updated);

-- vacuum analyze :TBL;

:WORK_MEM_RESET
