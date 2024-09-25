-- 
-- Use this script to grant access by database owner "usr" to postgis
-- schemas, if any. Without these permissions, pg_dump or restore
-- operations will fail.
-- 

GRANT USAGE ON SCHEMA topology to :usr;  
GRANT SELECT ON ALL SEQUENCES IN SCHEMA topology TO :usr;  
GRANT SELECT ON ALL TABLES IN SCHEMA topology TO :usr;  

GRANT USAGE ON SCHEMA postgis to :usr;  
GRANT SELECT ON ALL SEQUENCES IN SCHEMA postgis TO :usr;  
GRANT SELECT ON ALL TABLES IN SCHEMA postgis TO :usr;  