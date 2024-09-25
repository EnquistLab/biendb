-- 
-- Updates version information for entire database
-- Retires current version and insert new version record
-- Should be done any time changes to database are commited
--

SET search_path TO :sch;

-- Populate archive data for existing database
-- Make SURE you have archived a backup of this
-- database, including version # in filename
UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE bien_metadata_id=(
SELECT MAX(bien_metadata_id) FROM bien_metadata
);

-- Insert new records for new version
-- Version comments are optional
-- Ideally, version number should be a parameter, but
-- I'm doing this the lazy way for now.
INSERT INTO bien_metadata (
db_version,
db_release_date,
version_comments
)
VALUES (
:'db_version',
now()::timestamp::date,
:'version_comments'
)
;
