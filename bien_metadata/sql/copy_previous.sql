-- --------------------------------------------------------------------
-- Copies existing db metadata table from production to development
-- schema, resets primary key to next integer in sequence and restores
-- all indexes
-- --------------------------------------------------------------------

SET search_path TO :dev_schema;

-- Drop metadata table and sequence if exist
DROP TABLE IF EXISTS bien_metadata CASCADE;

-- Create the new table based on existing table in production schema
CREATE TABLE bien_metadata (LIKE :prod_schema.bien_metadata);
INSERT INTO bien_metadata SELECT * FROM :prod_schema.bien_metadata;

-- Create the sequence and link to bien_metadata
CREATE SEQUENCE bien_metadata_bien_metadata_id_seq;
ALTER TABLE bien_metadata ALTER COLUMN bien_metadata_id SET DEFAULT nextval('bien_metadata_bien_metadata_id_seq');
ALTER TABLE bien_metadata ALTER COLUMN bien_metadata_id SET NOT NULL;
ALTER SEQUENCE bien_metadata_bien_metadata_id_seq OWNED BY bien_metadata.bien_metadata_id;

-- Set tne next value in sequence
SELECT setval('bien_metadata_bien_metadata_id_seq', COALESCE((
SELECT MAX(bien_metadata_id)+1 FROM bien_metadata),
1),false);

-- Set the pkey
ALTER TABLE bien_metadata ADD PRIMARY KEY (bien_metadata_id);

-- Add remaining indexes
CREATE INDEX bien_metadata_db_version_idx ON bien_metadata(db_version);
CREATE INDEX bien_metadata_db_release_date_idx ON bien_metadata(db_release_date);
CREATE INDEX bien_metadata_db_retired_date_idx ON bien_metadata(db_retired_date);
CREATE INDEX bien_metadata_db_code_version_idx ON bien_metadata(db_code_version);
CREATE INDEX bien_metadata_rbien_version_idx ON bien_metadata(rbien_version);
CREATE INDEX bien_metadata_rtodobien_version_idx ON bien_metadata(rtodobien_version);