-- --------------------------------------------------------------
-- Converts existing column to primary key
-- Name of key composed by called script and sent as parameter
-- Column MUST satisfying PK rules or this script will crash
-- --------------------------------------------------------------


SET search_path TO :sch;

ALTER TABLE :tbl DROP CONSTRAINT IF EXISTS :pkey_name;
ALTER TABLE :tbl ADD PRIMARY KEY (:id);
