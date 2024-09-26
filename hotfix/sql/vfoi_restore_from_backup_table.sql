-- ---------------------------------------
-- ********** DANGER **************
-- For development only
-- Do not use for production run!!!
-- ---------------------------------------

-- Transaction gives last chance to cance/rollback 
-- if you make a mistake
BEGIN;

SET search_path TO analytical_db_test;

DROP TABLE analytical_db_test.view_full_occurrence_individual_dev;

CREATE TABLE analytical_db_test.view_full_occurrence_individual_dev (LIKE
analytical_db_test.view_full_occurrence_individual_dev_bak);

INSERT INTO analytical_db_test.view_full_occurrence_individual_dev
SELECT * FROM analytical_db_test.view_full_occurrence_individual_dev_bak;

ALTER TABLE analytical_db_test.view_full_occurrence_individual_dev 
OWNER TO bien;

COMMIT;