-- -----------------------------------------------------
-- Update column major_taxon in table tnrs by joining to 
-- table ncbi_taxa
-- -----------------------------------------------------

SET search_path TO :sch;

-- 
-- Update major_taxon by joining to ncbi_taxa
-- 

-- First, flag non-animals; this will prevent cross-code homonyms from matching
UPDATE tnrs a
SET major_taxon=b.major_higher_taxon
FROM ncbi_taxa b
WHERE a.species_submitted=b.taxon
AND b.rank='species'
AND b.major_higher_taxon<>'Animalia'
;

CREATE INDEX tnrs_major_taxon_idx ON tnrs (major_taxon);

-- Now flag animal names
UPDATE tnrs a
SET major_taxon='Animalia'
FROM ncbi_taxa b
WHERE a.species_submitted=b.taxon
AND b.rank='species'
AND b.major_higher_taxon='Animalia'
AND a.major_taxon IS NULL
;

-- Flag ICN names by joining to animal families
UPDATE tnrs a
SET major_taxon=b.major_higher_taxon
FROM ncbi_taxa b
WHERE a.family_submitted=b.taxon
AND b.rank='family'
AND a.major_taxon IS NULL
;

-- Flag zoological code (animal) names by joining to animal families
UPDATE tnrs a
SET major_taxon='Animalia'
FROM ncbi_taxa b
WHERE a.animal_family_submitted=b.taxon
AND b.rank='family'
AND b.major_higher_taxon='Animalia'
AND a.major_taxon IS NULL
;



