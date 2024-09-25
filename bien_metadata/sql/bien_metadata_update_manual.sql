-- -----------------------------------------------------------
-- One-time update to add and populate code version columns
-- -----------------------------------------------------------

ALTER TABLE bien_metadata
ADD COLUMN db_code_version TEXT NOT NULL,
ADD COLUMN rbien_version TEXT NOT NULL,
ADD COLUMN rtodobien_version TEXT NOT NULL
;

UPDATE bien_metadata
SET db_code_version='v2.1',
rbien_version=NULL,
rtodobien_version=NULL
WHERE db_version='3.4.5'
;

UPDATE bien_metadata
SET db_code_version='v4.0',
rbien_version=NULL,
rtodobien_version=NULL
WHERE db_version='4.0'
;

UPDATE bien_metadata
SET db_code_version='v4.1',
rbien_version=NULL,
rtodobien_version=NULL
WHERE db_version='4.0.1'
;

CREATE INDEX bien_metadata_db_code_version_idx ON bien_metadata(db_code_version);
CREATE INDEX bien_metadata_rbien_version_idx ON bien_metadata(rbien_version);
CREATE INDEX bien_metadata_rtodobien_version_idx ON bien_metadata(rtodobien_version);