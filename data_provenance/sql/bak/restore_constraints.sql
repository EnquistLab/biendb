-- ------------------------------------------------------------------
-- Restore constraints on production tables
-- 
-- Currently only constraint is FK from nsr to vfoi
-- Possibly add FK from vfoi to bien_taxonomy, allowing nulls?
-- ------------------------------------------------------------------

\c public_vegbien
SET search_path TO public;

BEGIN;

LOCK TABLE nsr IN SHARE MODE;

-- Restore FK constraints
ALTER TABLE ONLY nsr
ADD CONSTRAINT nsr_user_id_fkey FOREIGN KEY (user_id) REFERENCES view_full_occurrence_individual(taxonobservation_id);

COMMIT;
