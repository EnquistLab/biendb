-- -----------------------------------------------------------
-- Update DB metadata for this hotfix (minor version update)
-- -----------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

-- \c public_vegbien

UPDATE bien_metadata
-- SET db_retired_date=now()::timestamp::date
SET db_retired_date='2023-06-27' -- Entering manually due to delayed update
WHERE bien_metadata_id=(SELECT MAX(bien_metadata_id) FROM bien_metadata)
;

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
'4.2.8',
-- now()::timestamp::date,
'2023-06-27', -- Entering manually due to delayed update
'Minor release: update latlong_text where is_embargoed_occurrence=1 (affects public database only)',
'4.2.8',
'1.2.3',
'1.2.3',
'5.0.3'
)
;
