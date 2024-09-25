-- ----------------------------------------------------------------
-- Detect ranks, populate recursive FKs and add indexes
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

--
-- Index taxon columns
--

DROP INDEX IF EXISTS taxon_family_idx;
CREATE INDEX taxon_family_idx ON taxon (family);
DROP INDEX IF EXISTS taxon_genus_idx;
CREATE INDEX taxon_genus_idx ON taxon (genus);
DROP INDEX IF EXISTS taxon_species_idx;
CREATE INDEX taxon_species_idx ON taxon (species);
DROP INDEX IF EXISTS taxon_taxon_idx;
CREATE INDEX taxon_taxon_idx ON taxon (taxon);


-- 
-- Populate rank
--

UPDATE taxon
SET taxon_rank='family'
WHERE family is not null and genus is null 
AND taxon like '%aceae'
;

UPDATE taxon
SET taxon_rank='genus'
WHERE genus is not null and species is null
AND taxon not like '% %'
;

UPDATE taxon
SET taxon_rank='species'
WHERE species is not null and species=taxon
and taxon like '% %' and taxon not like '% % %'
;

UPDATE taxon
SET taxon_rank='infraspecific'
WHERE species is not null and species<>taxon
and taxon like '% % %'
;

-- genus hybrids
UPDATE taxon 
SET taxon_rank='hybrid genus'
WHERE genus LIKE 'x %' 
;

DROP INDEX IF EXISTS taxon_taxon_rank_idx;
CREATE INDEX taxon_rank ON taxon (taxon_rank);

-- species hybrids
UPDATE taxon 
SET taxon_rank='hybrid species'
WHERE taxon LIKE '% x %' 
;

-- 
-- Populate recursive FKs
--

UPDATE taxon a
SET family_taxon_id=b.taxon_id
FROM taxon b
WHERE a.family=b.taxon
;

UPDATE taxon a
SET genus_taxon_id=b.taxon_id
FROM taxon b
WHERE a.genus=b.taxon
;

UPDATE taxon a
SET species_taxon_id=b.taxon_id
FROM taxon b
WHERE a.species=b.taxon
;

-- 
-- Index FKs
--

DROP INDEX IF EXISTS taxon_family_taxon_id_idx;
CREATE INDEX taxon_family_taxon_id_idx ON taxon (family_taxon_id);
DROP INDEX IF EXISTS taxon_genus_taxon_id_idx;
CREATE INDEX taxon_genus_taxon_id_idx ON taxon (genus_taxon_id);
DROP INDEX IF EXISTS taxon_species_taxon_id_idx;
CREATE INDEX taxon_col_taxon_species_taxon_id_idxidx ON taxon (species_taxon_id);


