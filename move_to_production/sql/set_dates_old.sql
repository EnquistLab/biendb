-- 
-- Reset db retired date for previous database to today's date
--

SET search_path TO :sch;

UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE db_version=:'ver'
;