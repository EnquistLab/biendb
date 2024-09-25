-- -----------------------------------------------------
-- Creates table holding db version and other metadata
-- -----------------------------------------------------

set search_path to :dev_schema;

-- Create table
DROP TABLE IF EXISTS bien_metadata;
CREATE TABLE bien_metadata (
bien_metadata_id SERIAL PRIMARY KEY NOT NULL,
db_version TEXT NOT NULL,
db_release_date DATE DEFAULT NULL,
db_retired_date DATE DEFAULT NULL,
version_comments TEXT DEFAULT NULL
);

CREATE INDEX bien_metadata_db_version_idx ON bien_metadata(db_version);
CREATE INDEX bien_metadata_db_release_date_idx ON bien_metadata(db_release_date);
CREATE INDEX bien_metadata_db_retired_date_idx ON bien_metadata(db_retired_date);