-- 
-- Copy table bien_summary from production to development
--

SET search_path TO :dev_schema;

BEGIN;

-- Drop original table, including its parent sequence
DROP TABLE IF EXISTS bien_summary;

-- Table is small, so just copy it
-- This preserves the development version
CREATE TABLE bien_summary ( 
LIKE :prod_schema.bien_summary 
INCLUDING DEFAULTS 
INCLUDING CONSTRAINTS 
INCLUDING INDEXES 
);	

-- Populate the table
INSERT INTO bien_summary
SELECT * FROM :prod_schema.bien_summary;

-- Create local sequence in this 
CREATE SEQUENCE bien_summary_bien_summary_id_seq;
ALTER SEQUENCE bien_summary_bien_summary_id_seq 
	OWNED BY bien_summary.bien_summary_id;
	
-- Reset primary key to use local sequence
ALTER TABLE bien_summary
ALTER bien_summary_id SET DEFAULT nextval('bien_summary_bien_summary_id_seq'::regclass)	
;

-- Finally, reset sequence next value to the expected 
-- value of max of PK + 1
SELECT setval('bien_summary_bien_summary_id_seq', 
(SELECT MAX(bien_summary_id)+1 FROM bien_summary)
);

COMMIT;