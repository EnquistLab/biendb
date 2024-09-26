-- -----------------------------------------------------------
-- Update DB metadata for this hotfix (minor version update)
-- -----------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

	

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
'4.2.6',
now()::timestamp::date,
'Minor release: add index is_range_model_obs to table view_full_occurrence_individual',
'4.2.6',
'1.2.3',
'1.2.3',
'5.0'
)
;