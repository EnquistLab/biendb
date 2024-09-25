-- ---------------------------------------------------------
-- Creates, populates & indexes table species
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS species;
CREATE TABLE species (
id BIGSERIAL PRIMARY KEY,
species TEXT NOT NULL
);

INSERT INTO species (species)
SELECT DISTINCT species_std
FROM observations_union
ORDER BY species_std
;

CREATE UNIQUE INDEX species_species ON species(species);
