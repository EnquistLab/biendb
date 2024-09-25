-- -----------------------------------------------------
-- Correct erroneous major taxon classifications
-- -----------------------------------------------------

SET search_path TO :sch;

-- Assume any submitted name with a plant family pre-prended is a plant
UPDATE tnrs
SET major_taxon='Embryophyta'
WHERE TRIM(SPLIT_PART(name_submitted, ' ', 1)) LIKE '%aceae';

UPDATE tnrs
SET major_taxon='Embryophyta'
WHERE TRIM(SPLIT_PART(name_submitted, ' ', 1)) IN (
'Compositae',
'Cruciferae',
'Graminae',
'Guttiferae',
'Labiatae',
'Leguminae',
'Palmae',
'Umbelliferae'
);