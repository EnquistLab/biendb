-- -----------------------------------------------------------
-- One-time update to makes dates and versions exactly right
-- for new release
-- -----------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE db_version='4.1.1'
;

SET search_path TO analytical_db_dev;

UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE db_version='4.1.1'
;

UPDATE bien_metadata
SET 
db_release_date=now()::timestamp::date
WHERE db_version='4.2'
;
