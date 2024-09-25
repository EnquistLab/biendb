-- 
-- Insert database version info
--

SET search_path TO :dev_schema;

INSERT INTO bien_summary (
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
