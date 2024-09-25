-- -----------------------------------------------------------
-- Creates PK sequence for bien_metadata PK (bien_metadata_id)
-- Handles case where sequence & constraint have been deleted
-- Preserves existing PK values
-- -----------------------------------------------------------

BEGIN;

SET search_path TO :sch;

-- protect against concurrent inserts while you update the counter
LOCK TABLE bien_metadata IN EXCLUSIVE MODE;

-- Remove existing constraint and sequence if exist
ALTER TABLE IF EXISTS bien_metadata ALTER COLUMN bien_metadata_id DROP DEFAULT;

-- Create the sequence and link to new_table
DROP SEQUENCE IF EXISTS bien_metadata_bien_metadata_id_seq;
CREATE SEQUENCE bien_metadata_bien_metadata_id_seq;
ALTER TABLE bien_metadata ALTER COLUMN bien_metadata_id SET DEFAULT nextval('bien_metadata_bien_metadata_id_seq');
ALTER SEQUENCE bien_metadata_bien_metadata_id_seq OWNED BY bien_metadata.bien_metadata_id;

-- Update the sequence
SELECT setval('bien_metadata_bien_metadata_id_seq', COALESCE((
SELECT MAX(bien_metadata_id)+1 FROM bien_metadata),
1),false);

COMMIT;
