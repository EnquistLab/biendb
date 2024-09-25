-- --------------------------------------------------------------
-- Manually restore tables in geombien
-- Not part of pipeline
-- --------------------------------------------------------------

\c geombien

--
-- observations_union
-- 

-- Create the empty table
DROP TABLE IF EXISTS observations_union_bak;
CREATE TABLE observations_union_bak (LIKE observations_union INCLUDING ALL);
CREATE SEQUENCE observations_union_bak_gid_seq;    
ALTER SEQUENCE observations_union_bak_gid_seq OWNED BY observations_union_bak.gid;
ALTER TABLE observations_union_bak ALTER gid SET DEFAULT nextval('observations_union_bak_gid_seq'::regclass);

-- Insert the records
INSERT INTO observations_union_bak SELECT * FROM observations_union;

-- Set permissions
REVOKE ALL ON TABLE observations_union_bak FROM PUBLIC;
ALTER TABLE observations_union_bak OWNER TO bien;
GRANT ALL ON TABLE observations_union_bak TO bien;
GRANT ALL ON TABLE observations_union_bak TO jmcgann;
GRANT SELECT ON TABLE observations_union_bak TO bien_read;
GRANT SELECT ON TABLE observations_union_bak TO public_bien3;

--
-- species
-- 

-- Create the empty table
DROP TABLE IF EXISTS species_bak;
CREATE TABLE species_bak (LIKE species INCLUDING ALL);
CREATE SEQUENCE species_bak_id_seq;    
ALTER SEQUENCE species_bak_id_seq OWNED BY species_bak.id;
ALTER TABLE species_bak ALTER id SET DEFAULT nextval('species_bak_id_seq'::regclass);

-- Insert the records
INSERT INTO species_bak SELECT * FROM species;

-- Set permissions
REVOKE ALL ON TABLE species_bak FROM PUBLIC;
ALTER TABLE species_bak OWNER TO bien;
GRANT ALL ON TABLE species_bak TO bien;
GRANT ALL ON TABLE species_bak TO jmcgann;
GRANT SELECT ON TABLE species_bak TO bien_read;
GRANT SELECT ON TABLE species_bak TO public_bien3;

