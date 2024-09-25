--
-- Revokes all privileges on schema :sch for role :usr in
-- database :db
--  
-- Connect to the database for following commands
\c :"db"

REVOKE ALL ON ALL TABLES IN SCHEMA :"sch" FROM :"usr";
REVOKE ALL PRIVILEGES ON SCHEMA :"sch" FROM :"usr";
ALTER DEFAULT PRIVILEGES IN SCHEMA :"sch" REVOKE ALL PRIVILEGES ON TABLES FROM :"usr";