-- -----------------------------------------------------
-- Adds columns species_submitted, animal_family_submitted,
-- major_taxon to table tnrs
-- -----------------------------------------------------

SET search_path TO :sch;

-- 
-- Add columns to tnrs
-- 

ALTER TABLE tnrs DROP COLUMN IF EXISTS major_taxon;
ALTER TABLE tnrs DROP COLUMN IF EXISTS species_submitted;
ALTER TABLE tnrs DROP COLUMN IF EXISTS animal_family_submitted;

ALTER TABLE tnrs ADD COLUMN major_taxon text default null;
ALTER TABLE tnrs ADD COLUMN animal_family_submitted text default null;
ALTER TABLE tnrs ADD COLUMN species_submitted text default null;

-- 
-- Populate species_submitted & animal_family_submitted
-- 

UPDATE tnrs
SET species_submitted=CONCAT_WS(' ',
genus_submitted, specific_epithet_submitted
)
WHERE genus_submitted IS NOT NULL
AND specific_epithet_submitted IS NOT NULL
;

UPDATE tnrs
SET animal_family_submitted=split_part(name_submitted,' ',1)
WHERE split_part(name_submitted,' ',1) LIKE '%idae'
;

-- 
-- Index species_submitted & animal_family_submitted in preparation 
-- for populating major_taxon
-- 

CREATE INDEX tnrs_species_submitted_idx ON tnrs (species_submitted);
CREATE INDEX tnrs_animal_family_submitted_idx ON tnrs (animal_family_submitted);