-- ---------------------------------------------------------
-- Creates, populates & indexes table species
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS species_temp;
CREATE TABLE species_temp (
species TEXT NOT NULL
);

INSERT INTO species_temp (species)
SELECT DISTINCT(scrubbed_species_binomial) 
FROM :tbl_vfoi
WHERE :sql_where_default
:limit
;

DROP TABLE IF EXISTS species;
CREATE TABLE species (
id BIGSERIAL PRIMARY KEY,
species TEXT NOT NULL
);

INSERT INTO species (species)
SELECT species
FROM species_temp
ORDER BY species
;

CREATE UNIQUE INDEX species_species ON species(species);

DROP TABLE IF EXISTS species_temp;