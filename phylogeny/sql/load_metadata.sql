-- --------------------------------------------------------
-- Loads metadata from temporary table phylo_info into
-- table phylogeny
-- --------------------------------------------------------

SET search_path To :dev_schema;

-- Remove text from integer column and change data type
UPDATE phylo_info
SET replicate=NULL
WHERE replicate='NA'
;

-- Change data type
ALTER TABLE phylo_info 
ALTER COLUMN replicate DROP DEFAULT
;
ALTER TABLE phylo_info 
ALTER COLUMN replicate TYPE integer USING (trim(replicate)::integer)
;

-- insert the records
INSERT INTO phylogeny (
phylogeny_version,
replicate,
filename,
citation
)
SELECT 
TRIM(phylogeny_version),
replicate,
TRIM(filename),
TRIM(citation)
FROM phylo_info
;

-- Drop the temporary table
DROP TABLE phylo_info;