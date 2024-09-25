-- ----------------------------------------------------------------
-- Populates rank column
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- family
UPDATE bien_taxonomy 
SET taxon_rank='family'
WHERE scrubbed_family=scrubbed_taxon_name_no_author
AND scrubbed_taxon_name_no_author like '%aceae'
;

-- genus
UPDATE bien_taxonomy 
SET taxon_rank='genus'
WHERE scrubbed_genus=scrubbed_taxon_name_no_author
AND scrubbed_species_binomial is null
AND scrubbed_taxon_name_no_author NOT LIKE '% %'
;

-- species
UPDATE bien_taxonomy 
SET taxon_rank='species'
WHERE scrubbed_species_binomial=scrubbed_taxon_name_no_author
AND scrubbed_taxon_name_no_author LIKE '% %'
AND scrubbed_taxon_name_no_author NOT LIKE '% % %'
;

-- infraspecific
UPDATE bien_taxonomy 
SET taxon_rank='infraspecific'
WHERE scrubbed_species_binomial<>scrubbed_taxon_name_no_author
AND scrubbed_species_binomial IS NOT NULL
AND scrubbed_taxon_name_no_author LIKE '% % %'
;

-- genus hybrids
UPDATE bien_taxonomy 
SET taxon_rank='hybrid genus'
WHERE scrubbed_taxon_name_no_author LIKE 'x %' 
OR scrubbed_genus LIKE 'x %'
;

-- Index taxon_rank before the final step, bit speedier
DROP INDEX IF EXISTS bien_taxonomy_taxon_rank_idx;
CREATE INDEX bien_taxonomy_taxon_rank_idx ON bien_taxonomy (taxon_rank);

-- species hybrids
UPDATE bien_taxonomy 
SET taxon_rank='hybrid species'
WHERE scrubbed_taxon_name_no_author LIKE '% x %' 
;
