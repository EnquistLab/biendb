-- -----------------------------------------------------------------
-- Create table taxon_status
-- Summarizes taxonomic status for each accepted name in BIEN DB
-- Add to pipeline in next version!
-- -----------------------------------------------------------------

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS taxon_status;
CREATE TABLE taxon_status AS
SELECT DISTINCT
scrubbed_family AS family,
scrubbed_genus AS genus, 
scrubbed_species_binomial AS species_binomial,
scrubbed_taxon_name_no_author taxon, 
scrubbed_author AS author,
scrubbed_taxonomic_status AS taxonomic_status
FROM tnrs
WHERE scrubbed_specific_epithet IS NOT NULL
ORDER BY scrubbed_family,
scrubbed_genus, 
scrubbed_species_binomial,
scrubbed_taxon_name_no_author, 
scrubbed_author,
scrubbed_taxonomic_status
;

ALTER TABLE taxon_status
ADD COLUMN rank text default NULL;

UPDATE taxon_status
SET rank='hybrid'
WHERE taxon LIKE 'X %' OR taxon LIKE '% x %' 
OR taxon similar to 'x[A-Z]%'
;
UPDATE taxon_status
SET rank='species'
WHERE species_binomial=taxon
AND rank IS NULL
;
UPDATE taxon_status
SET rank='infraspecific'
WHERE rank IS NULL
;

CREATE INDEX taxon_status_family_idx ON taxon_status(family);
CREATE INDEX taxon_status_genus_idx ON taxon_status(genus);
CREATE INDEX taxon_status_species_binomial_idx ON taxon_status(species_binomial);
CREATE INDEX taxon_status_taxon_idx ON taxon_status(taxon);
CREATE INDEX taxon_status_author_idx ON taxon_status(author);
CREATE INDEX taxon_status_taxonomic_status_idx ON taxon_status(taxonomic_status);
CREATE INDEX taxon_status_rank_idx ON taxon_status(rank);
