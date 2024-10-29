-- -----------------------------------------------------------
-- Update DB metadata for this hotfix (minor version update)
-- New column "nsr_version" added to DB pipeline
-- -----------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

-- \c public_vegbien

ALTER TABLE bien_metadata
ADD COLUMN nsr_version text DEFAULT NULL
;

UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
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
tnrs_version,
nsr_version
)
VALUES (
'4.3',
now()::timestamp::date,
'Update NSR columns in view_full_occurrence_individual, analytical_stem and agg_traits',
'4.3',
'1.2.6',
'1.2.6',
'5.3.1',
'3.0'
)
;
