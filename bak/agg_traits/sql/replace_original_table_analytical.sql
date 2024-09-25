-- --------------------------------------------------
-- Replaces original tables with new table
-- Copies table rather than moving, leaving development
-- version intact
-- BTW note how stupidly complicated it is to copy
-- a table + primary key in postgres. Madness!
-- --------------------------------------------------

set search_path to :target_schema;

BEGIN;

-- Drop original table, including its parent sequence
DROP TABLE IF EXISTS agg_traits;
DROP SEQUENCE IF EXISTS agg_traits_id_seq;

-- Table is small, so just copy it
-- This preserves the development version
CREATE TABLE :target_schema.agg_traits ( 
LIKE :src_schema.agg_traits 
INCLUDING DEFAULTS 
INCLUDING CONSTRAINTS 
INCLUDING INDEXES 
);	

-- Populate the table
INSERT INTO :target_schema.agg_traits
SELECT * FROM :src_schema.agg_traits;

-- Create local sequence in this 
CREATE SEQUENCE agg_traits_id_seq;
ALTER SEQUENCE agg_traits_id_seq 
	OWNED BY agg_traits.id;
	
-- Reset primary key to use local sequence
ALTER TABLE agg_traits
ALTER id SET DEFAULT nextval('agg_traits_id_seq'::regclass)	
;

-- Finally, reset sequence next value to the expected 
-- value of max of PK + 1
SELECT setval('agg_traits_id_seq', 
(SELECT MAX(id)+1 FROM agg_traits)
);

--
-- Adjust permissions
--
REVOKE ALL ON TABLE agg_traits FROM PUBLIC;
REVOKE ALL ON TABLE agg_traits FROM bien;
GRANT ALL ON TABLE agg_traits TO bien;
ALTER TABLE agg_traits OWNER TO bien;
GRANT SELECT ON TABLE agg_traits TO public_bien;
GRANT SELECT ON TABLE agg_traits TO public_bien3;

COMMIT;