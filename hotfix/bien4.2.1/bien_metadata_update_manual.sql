-- -----------------------------------------------------------
-- One-time update to makes dates and versions exactly right
-- for new release
-- -----------------------------------------------------------


--
-- BIEN private
-- 

\c vegbien
SET search_path TO analytical_db;

-- retire current version
UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE bien_metadata_id=(
SELECT MAX(bien_metadata_id) FROM bien_metadata
);

-- Insert new record for new version
-- Version comments are optional
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
'4.2.1',
now()::timestamp::date,
'Minor release: Populate missing values in NSR columns is_cultivated_taxon and is_cultivated_in_region',
'4.2.3',
'1.2.3',
'1.2.3',
'5.0'
)
;

--
-- BIEN public
-- 

\c public_vegbien
SET search_path TO public;

-- retire current version
UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE bien_metadata_id=(
SELECT MAX(bien_metadata_id) FROM bien_metadata
);

-- Insert new record for new version
-- Version comments are optional
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
'4.2.1',
now()::timestamp::date,
'Minor release: Populate missing values in NSR columns is_cultivated_taxon and is_cultivated_in_region',
'4.2.3',
'1.2.3',
'1.2.3',
'5.0'
)
;
