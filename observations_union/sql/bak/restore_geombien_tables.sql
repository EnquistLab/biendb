-- --------------------------------------------------------------
-- Manually restore tables in geombien
-- Not part of pipeline
-- --------------------------------------------------------------

\c geombien

--
-- observations_union
-- 

-- Create the empty table
DROP TABLE IF EXISTS observations_union;
CREATE TABLE observations_union (LIKE observations_union_bak INCLUDING ALL);
CREATE SEQUENCE observations_union_gid_seq;    
ALTER SEQUENCE observations_union_gid_seq OWNED BY observations_union.gid;
ALTER TABLE observations_union ALTER gid SET DEFAULT nextval('observations_union_gid_seq'::regclass);

-- Insert the records
INSERT INTO observations_union SELECT * FROM observations_union_bak;

-- Set permissions
REVOKE ALL ON TABLE observations_union FROM PUBLIC;
ALTER TABLE observations_union OWNER TO bien;
GRANT ALL ON TABLE observations_union TO bien;
GRANT ALL ON TABLE observations_union TO jmcgann;
GRANT SELECT ON TABLE observations_union TO bien_read;
GRANT SELECT ON TABLE observations_union TO public_bien3;

--
-- species
-- 

-- Create the empty table
DROP TABLE IF EXISTS species;
CREATE TABLE species (LIKE species_bak INCLUDING ALL);
CREATE SEQUENCE species_id_seq;    
ALTER SEQUENCE species_id_seq OWNED BY species.id;
ALTER TABLE species ALTER id SET DEFAULT nextval('species_id_seq'::regclass);

-- Insert the records
INSERT INTO species SELECT * FROM species_bak;

-- Set permissions
REVOKE ALL ON TABLE species FROM PUBLIC;
ALTER TABLE species OWNER TO bien;
GRANT ALL ON TABLE species TO bien;
GRANT ALL ON TABLE species TO jmcgann;
GRANT SELECT ON TABLE species TO bien_read;
GRANT SELECT ON TABLE species TO public_bien3;

