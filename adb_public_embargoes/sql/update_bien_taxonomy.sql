-- --------------------------------------------------------------------
-- Updates taxon observation counts in bien_taxonomy
-- --------------------------------------------------------------------

SET search_path TO :sch;

--
-- Create temporary table of observations per taxon
-- 

DROP TABLE IF EXISTS taxon_obs_temp;
CREATE TABLE taxon_obs_temp AS
SELECT
bien_taxonomy_id,
taxonobservation_id
FROM view_full_occurrence_individual
;

CREATE INDEX taxon_obs_temp_bien_taxonomy_id_idx ON taxon_obs_temp (bien_taxonomy_id);

DROP TABLE IF EXISTS taxon_obs_count_temp;
CREATE TABLE taxon_obs_count_temp AS
SELECT bien_taxonomy_id, COUNT(*) AS obs
FROM taxon_obs_temp
GROUP BY bien_taxonomy_id
;

CREATE INDEX taxon_obs_count_temp_bien_taxonomy_id_idx ON taxon_obs_count_temp (bien_taxonomy_id);

-- 
-- Update bien_taxonomy
--

UPDATE bien_taxonomy
SET observations=0
;

DROP INDEX IF EXISTS bien_taxonomy_bien_taxonomy_id_idx;
CREATE INDEX bien_taxonomy_bien_taxonomy_id_idx ON bien_taxonomy (bien_taxonomy_id);

UPDATE bien_taxonomy a
SET observations=b.obs
FROM taxon_obs_count_temp b
WHERE a.bien_taxonomy_id=b.bien_taxonomy_id
;

-- Drop the temporary tables
DROP TABLE IF EXISTS taxon_obs_temp;
DROP TABLE IF EXISTS taxon_obs_count_temp;