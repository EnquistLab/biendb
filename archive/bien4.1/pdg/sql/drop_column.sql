SET search_path TO :sch;

ALTER TABLE :tbl DROP COLUMN IF EXISTS :col;
