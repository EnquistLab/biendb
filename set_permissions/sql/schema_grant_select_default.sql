--
-- Grant select permission on all tables in schema :sch for role :usr in
-- database :db, including tables created in future
--  

-- Connect to DB
GRANT CONNECT ON DATABASE :"db" TO :"usr";

-- You'll need to be connected to the database for all following commands
\c :"db"

-- Connect to schema
GRANT USAGE ON SCHEMA :"sch" TO :"usr";

-- Query existing tables (or views) and sequences
GRANT SELECT ON ALL TABLES IN SCHEMA :"sch" TO :"usr";
GRANT USAGE ON ALL SEQUENCES IN SCHEMA :"sch" TO :"usr";

-- Query all future tables (or views) and sequences
ALTER DEFAULT PRIVILEGES IN SCHEMA :"sch" GRANT SELECT ON TABLES TO :"usr";
ALTER DEFAULT PRIVILEGES IN SCHEMA :"sch" GRANT SELECT ON SEQUENCES TO :"usr";