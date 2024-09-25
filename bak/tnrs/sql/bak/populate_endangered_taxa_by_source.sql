-- ---------------------------------------------------------
-- Insert verbatim taxon names for each source into table 
-- endangered_taxa_by_source
-- IMPORTANT! WHERE clause used to filter subset of criteria 
-- used by BIEN to embargo species!
-- ---------------------------------------------------------

SET search_path TO public_vegbien_dev;

-- Create table inserting iucn taxa
-- The following works because iucn has no infraspecific taxa
-- BIEN rules: only embargo 'EN' and 'CR' species
INSERT INTO endangered_taxa_by_source (
verbatim_taxon, 
iucn_status
)
SELECT DISTINCT
trim(
coalesce(family,'') || ' ' || coalesce(genus,'') || ' ' || coalesce(species,'')
), 
red_list_status
FROM iucn
WHERE red_list_status IN ('EN','CR')
;

-- cites
INSERT INTO endangered_taxa_by_source (
verbatim_taxon, 
cites_status
)
SELECT DISTINCT
trim(
coalesce(family,'') || ' ' || coalesce(fullname,'')
), 
currentlisting
FROM cites
WHERE currentlisting IS NOT NULL AND TRIM(currentlisting)<>''
AND currentlisting<>'NC'
;

-- usda federa
INSERT INTO endangered_taxa_by_source (
verbatim_taxon, 
usda_status_fed
)
SELECT DISTINCT
scientific_name, 
federal_status
FROM usda
WHERE federal_status IS NOT NULL AND TRIM(federal_status)<>''
;

-- usda state
INSERT INTO endangered_taxa_by_source (
verbatim_taxon, 
usda_status_state
)
SELECT DISTINCT
scientific_name, 
state_status_codes
FROM usda
WHERE state_status_codes IS NOT NULL AND TRIM(state_status_codes)<>''
;

-- Populated indexes
CREATE INDEX endangered_taxa_by_source_endangered_taxa_by_source_id_idx ON endangered_taxa_by_source (endangered_taxa_by_source_id);

CREATE INDEX endangered_taxa_by_source_verbatim_taxon_idx ON endangered_taxa_by_source (verbatim_taxon);