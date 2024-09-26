-- --------------------------------------------------------------------
-- Create index on column catalog_number-- --------------------------------------------------------------------

SET search_path TO :SCH;

DROP INDEX IF EXISTS :IDX_NAME;
CREATE INDEX :IDX_NAME ON :"TBL"(catalog_number);
