-- 
-- Adds count of all observations to table bien_summary_public
-- This is first count, so adds new record rather than updating
--

SET search_path TO :dev_schema;

INSERT INTO bien_summary_public (
db_version,
summary_timestamp
)
SELECT 
db_version, 
now()::timestamp::date
FROM bien_metadata
WHERE bien_metadata_id=(
SELECT MAX(bien_metadata_id) FROM bien_metadata
)
;
