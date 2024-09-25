--
-- Grants select permission on schema :sch for role :usr in
-- database :db
--  

-- Connect to DB
GRANT CONNECT ON DATABASE :"db" TO :"usr";

-- You'll need to be connected to the database for all following commands
\c :"db"

-- Connect to schema
GRANT USAGE ON SCHEMA :"sch" TO :"usr";

-- Query existing tables (or views) and sequences
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA :"sch" TO :"usr";
GRANT USAGE ON ALL SEQUENCES IN SCHEMA :"sch" TO :"usr";

-- Query and future tables (or views) and sequences
ALTER DEFAULT PRIVILEGES IN SCHEMA :"sch" GRANT ALL PRIVILEGES ON TABLES TO :"usr";
ALTER DEFAULT PRIVILEGES IN SCHEMA :"sch" GRANT USAGE ON SEQUENCES TO :"usr";