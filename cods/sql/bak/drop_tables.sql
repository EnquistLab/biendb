-- -------------------------------------------------------------
-- Dropping cultobs extract and results tables
-- 
-- No point in keeping these as all information is copied to 
-- original tables
-- -------------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS cultobs;
DROP TABLE IF EXISTS cultobs_descriptions;
DROP TABLE IF EXISTS cultobs_herb_dist;
DROP TABLE IF EXISTS cultobs_herb_dist_bak;
DROP TABLE IF EXISTS cultobs_herb_min_dist;
DROP TABLE IF EXISTS cultobs_herbaria;
DROP TABLE IF EXISTS cultobs_sample;
