-- --------------------------------------------------------------
-- Adds integer primary key
-- Removes existing PKey, if any
-- Name of key composed by called script and sent as parameter
-- Column MUST satisfying PK rules or this script will crash
-- Name of the new PK must not conflict with any existing column name
-- --------------------------------------------------------------


SET search_path TO :sch;

-- Drop column and its sequence if already exist
DROP SEQUENCE IF EXISTS :seq_name CASCADE;
ALTER TABLE :tbl DROP CONSTRAINT IF EXISTS :pkey_name;
ALTER TABLE :tbl DROP COLUMN IF EXISTS :id;

-- Create the column
ALTER TABLE :tbl ADD COLUMN :id BIGSERIAL NOT NULL;
ALTER TABLE :tbl ADD PRIMARY KEY (:id);
