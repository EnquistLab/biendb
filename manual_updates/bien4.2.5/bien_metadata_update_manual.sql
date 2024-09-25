-- -----------------------------------------------------------
-- Update DB metadata for this hotfix (minor version update)
-- -----------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

-- Retire current minor
UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE bien_metadata_id=(
SELECT MAX(bien_metadata_id) FROM bien_metadata
);

-- Insert new record for new minor version
INSERT INTO bien_metadata (
db_version,
db_release_date,
version_comments,
db_code_version,
rbien_version,
rtodobien_version,
tnrs_version
)
VALUES (
'4.2.5',
now()::timestamp::date,
'Minor release: refactor table species_by_political_division, making  species+country+state+county a compound alternate candidate key',
'4.2.5',
'1.2.3',
'1.2.3',
'5.0'
)
;


\c public_vegbien

UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE bien_metadata_id=(
SELECT MAX(bien_metadata_id) FROM bien_metadata
);

-- Insert new record for new minor version
INSERT INTO bien_metadata (
db_version,
db_release_date,
version_comments,
db_code_version,
rbien_version,
rtodobien_version,
tnrs_version
)
VALUES (
'4.2.5',
now()::timestamp::date,
'Minor release: refactor table species_by_political_division, making  species+country+state+county a compound alternate candidate key',
'4.2.5',
'1.2.3',
'1.2.3',
'5.0'
)
;
