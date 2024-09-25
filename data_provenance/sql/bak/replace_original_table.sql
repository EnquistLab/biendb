-- --------------------------------------------------
-- Replaces original tables with new tables
--
-- DANGEROUS! Only run after backup and extensive testing!
-- --------------------------------------------------

\c public_vegbien
SET search_path TO public;

BEGIN;

LOCK TABLE view_full_occurrence_individual IN ACCESS EXCLUSIVE MODE;
LOCK TABLE nsr IN SHARE MODE;

-- Remove dependent-table FK constraints
ALTER TABLE nsr DROP CONSTRAINT "nsr_user_id_fkey";

-- Drop original vfoi & replace with new table from dev schema
DROP TABLE view_full_occurrence_individual;
ALTER TABLE public_vegbien_dev.view_full_occurrence_individual_dev 
	SET SCHEMA public;
ALTER TABLE view_full_occurrence_individual_dev 
	RENAME TO view_full_occurrence_individual;

--
-- Adjust permissions
--
REVOKE ALL ON TABLE view_full_occurrence_individual FROM PUBLIC;
REVOKE ALL ON TABLE view_full_occurrence_individual FROM bien;
GRANT ALL ON TABLE view_full_occurrence_individual TO bien;
ALTER TABLE view_full_occurrence_individual OWNER TO bien;
GRANT SELECT ON TABLE view_full_occurrence_individual TO public_bien;

COMMIT;