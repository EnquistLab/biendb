-- --------------------------------------------------
-- Replaces original tables with new table
-- Copies table rather than moving, leaving development
-- version intact
-- BTW note how stupidly complicated it is to copy
-- a table in posgres. Madness!
-- --------------------------------------------------

\c public_vegbien
SET search_path TO public;

BEGIN;

-- Drop original table, including its parent sequence
DROP TABLE IF EXISTS endangered_taxa;
DROP SEQUENCE IF EXISTS endangered_taxa_endangered_taxa_id_seq;

-- Table is small, so just copy it
-- This preserves the development version
CREATE TABLE public.endangered_taxa ( 
LIKE public_vegbien_dev.endangered_taxa 
INCLUDING DEFAULTS 
INCLUDING CONSTRAINTS 
INCLUDING INDEXES 
);	

-- Populate the table
INSERT INTO public.endangered_taxa
SELECT * FROM public_vegbien_dev.endangered_taxa;

-- Create local sequence in this 
CREATE SEQUENCE endangered_taxa_endangered_taxa_id_seq;
ALTER SEQUENCE endangered_taxa_endangered_taxa_id_seq 
	OWNED BY endangered_taxa.endangered_taxa_id;
	
-- Reset primary key to use local sequence
ALTER TABLE endangered_taxa
ALTER endangered_taxa_id SET DEFAULT nextval('endangered_taxa_endangered_taxa_id_seq'::regclass)	
;

-- Finally, reset sequence next value to the expected 
-- value of max of PK + 1
SELECT setval('endangered_taxa_endangered_taxa_id_seq', 
(SELECT MAX(endangered_taxa_id)+1 FROM endangered_taxa)
);

--
-- Adjust permissions
--
REVOKE ALL ON TABLE endangered_taxa FROM PUBLIC;
REVOKE ALL ON TABLE endangered_taxa FROM bien;
GRANT ALL ON TABLE endangered_taxa TO bien;
ALTER TABLE endangered_taxa OWNER TO bien;
GRANT SELECT ON TABLE endangered_taxa TO public_bien;
GRANT SELECT ON TABLE endangered_taxa TO public_bien3;

COMMIT;