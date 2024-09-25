-- ---------------------------------------------------------
-- Creates table endangered_taxa_verbatim
-- ---------------------------------------------------------

SET search_path TO public_vegbien_dev;

DROP TABLE IF EXISTS endangered_taxa_verbatim CASCADE; 

CREATE TABLE endangered_taxa_verbatim AS 
SELECT endangered_taxa_by_source_id as user_id, verbatim_taxon 
FROM endangered_taxa_by_source;

CREATE INDEX endangered_taxa_verbatim_user_id_idx ON endangered_taxa_verbatim (user_id);
CREATE INDEX endangered_taxa_verbatim_verbatim_taxon_idx ON endangered_taxa_verbatim (verbatim_taxon);