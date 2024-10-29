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
db_code_version TEXT DEFAULT NULL,
rbien_version TEXT DEFAULT NULL,
rtodobien_version TEXT DEFAULT NULL,
tnrs_version TEXT DEFAULT NULL,
nsr_version TEXT DEFAULT NULL,
gnrs_version TEXT DEFAULT NULL,
gvs_version TEXT DEFAULT NULL,
version_comments TEXT DEFAULT NULL
);

CREATE INDEX bien_metadata_db_version_idx ON bien_metadata(db_version);
CREATE INDEX bien_metadata_db_release_date_idx ON bien_metadata(db_release_date);
CREATE INDEX bien_metadata_db_retired_date_idx ON bien_metadata(db_retired_date);
CREATE INDEX bien_metadata_db_code_version_idx ON bien_metadata(db_code_version);
CREATE INDEX bien_metadata_rbien_version_idx ON bien_metadata(rbien_version);
CREATE INDEX bien_metadata_rtodobien_version_idx ON bien_metadata(rtodobien_version);
CREATE INDEX bien_metadata_tnrs_version_idx ON bien_metadata(tnrs_version);