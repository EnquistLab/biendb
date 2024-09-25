-- 
-- Reset db release & retirement dates for new and old dbs
--

SET search_path TO :sch;

-- Set release date for new database
UPDATE bien_metadata
SET db_release_date=now()::timestamp::date
WHERE bien_metadata_id=(
SELECT MAX(bien_metadata_id) FROM bien_metadata
);

-- Set retirement date for previous database
UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE db_version=:'ver'
;