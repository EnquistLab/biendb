-- ---------------------------------------------------------
-- Insert verbatim taxon names
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

INSERT INTO name_submitted (
name_submitted_verbatim,
name_submitted
)
SELECT DISTINCT 
verbatim_taxon,
verbatim_taxon
FROM endangered_taxa_by_source
WHERE verbatim_taxon IS NOT NULL AND verbatim_taxon<>''
;