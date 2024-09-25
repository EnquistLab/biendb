-- ----------------------------------------------------------------
-- Load table taxon with all accepted, unique family + genus + species
-- combinations. No authors, no morphospecies
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- Clear table in case re-running for development
TRUNCATE taxon;

-- full taxa
INSERT INTO taxon (
family,
genus,
species,
taxon
)
SELECT DISTINCT
scrubbed_family,
scrubbed_genus,
scrubbed_species_binomial,
scrubbed_taxon_name_no_author
FROM bien_taxonomy
WHERE scrubbed_taxon_name_no_author IS NOT NULL
AND scrubbed_taxonomic_status NOT IN (
'Rejected name','Invalid','Illegitimate',''
)
AND scrubbed_taxonomic_status IS NOT NULL
;

-- families
INSERT INTO taxon (
family,
genus,
species,
taxon
)
SELECT DISTINCT
scrubbed_family,
null,
null,
scrubbed_family
FROM bien_taxonomy
WHERE scrubbed_family IS NOT NULL
AND scrubbed_taxonomic_status NOT IN (
'Rejected name','Invalid','Illegitimate',''
)
AND scrubbed_taxonomic_status IS NOT NULL
;

-- genera
INSERT INTO taxon (
family,
genus,
species,
taxon
)
SELECT DISTINCT
scrubbed_family,
scrubbed_genus,
null,
scrubbed_genus
FROM bien_taxonomy
WHERE scrubbed_genus IS NOT NULL
AND scrubbed_taxonomic_status NOT IN (
'Rejected name','Invalid','Illegitimate',''
)
AND scrubbed_taxonomic_status IS NOT NULL
;

-- species
INSERT INTO taxon (
family,
genus,
species,
taxon
)
SELECT DISTINCT
scrubbed_family,
scrubbed_genus,
scrubbed_species_binomial,
scrubbed_species_binomial
FROM bien_taxonomy
WHERE scrubbed_species_binomial IS NOT NULL
AND scrubbed_taxonomic_status NOT IN (
'Rejected name','Invalid','Illegitimate',''
)
AND scrubbed_taxonomic_status IS NOT NULL
;

-- 
-- Rename table to temp table and make new copy with original name
--

DROP TABLE IF EXISTS taxon_temp CASCADE;
ALTER TABLE taxon RENAME TO taxon_temp;
CREATE TABLE taxon (LIKE taxon_temp 
);

-- Drop PK constraint on temp table and add it to the new table
ALTER TABLE taxon_temp DROP CONSTRAINT taxon_pkey;
ALTER TABLE taxon ADD PRIMARY KEY (taxon_id);

--Point the PK to the existing sequence 
ALTER SEQUENCE taxon_taxon_id_seq 
	OWNED BY taxon.taxon_id;
	
-- Reset primary key to use local sequence
ALTER TABLE taxon
ALTER taxon_id SET DEFAULT nextval('taxon_taxon_id_seq'::regclass)	
;

-- Finally, reset sequence starting value to 1
SELECT setval('taxon_taxon_id_seq', (1));

-- 
-- Insert distinct values and delete temp table
--


INSERT INTO taxon (
family,
genus,
species,
taxon
)
SELECT DISTINCT
family,
genus,
species,
taxon
FROM taxon_temp
ORDER BY 
family,
genus,
species,
taxon
;

DROP TABLE taxon_temp;