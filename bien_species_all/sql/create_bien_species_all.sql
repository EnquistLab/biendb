-- 
-- Create summary table bien_species_all
--

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS bien_species_all;
CREATE TABLE bien_species_all AS 
SELECT scrubbed_species_binomial AS species,
COUNT(*) AS observations
FROM :tbl_vfoi
WHERE is_geovalid=1
AND scrubbed_species_binomial IS NOT NULL
GROUP BY scrubbed_species_binomial
; 

CREATE INDEX bien_species_all_species_idx ON bien_species_all (species);
CREATE INDEX bien_species_all_observations_idx ON bien_species_all (observations);