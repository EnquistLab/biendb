-- --------------------------------------------------
-- Copies table ih from schema herbaria to dev schema
-- --------------------------------------------------

SET search_path TO :dev_schema;

-- --------------------------------------------------
-- Copies datasource to public schema
-- Replaces previous version if already exists
-- --------------------------------------------------

BEGIN;

-- Drop original table
DROP TABLE IF EXISTS ih;
CREATE TABLE ih ( 
LIKE :src_schema.ih 
INCLUDING DEFAULTS 
INCLUDING CONSTRAINTS 
INCLUDING INDEXES 
);	

INSERT INTO ih
SELECT * FROM :src_schema.ih;

COMMIT;