-- 
-- Updates version information for entire database
-- Should be done any time changes to database are commited
--

SET search_path TO public;

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
'3.4.1',
now()::timestamp::date,
'First full public-release version. Added table endangered_taxa. Applied all taxon embargoes for CITES, IUCN, US Federal and US State. Applied dataset embargoes for REMIB, Madidi and NVS.'
)
;
