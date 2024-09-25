-- --------------------------------------------------------------
-- Drops auto-increment primary key & its sequence
-- --------------------------------------------------------------

SET search_path TO :sch;

DROP SEQUENCE IF EXISTS :seq_name CASCADE;
ALTER TABLE :tbl DROP CONSTRAINT IF EXISTS :pkey_name;
ALTER TABLE :tbl DROP COLUMN IF EXISTS :id;
