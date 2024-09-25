-- ---------------------------------------------------------
-- Substitute underscore for space in column species and move
-- standard (space delimited) species name to new column
-- "species_std". Makes table same as version used in geombien. 
-- ---------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE observations_union
ADD COLUMN species_std text,
ADD COLUMN is_embargoed smallint DEFAULT 0
;

-- Populate species_std and replace underscore with whitespace in species
UPDATE observations_union
SET species_std=species
;
UPDATE observations_union
SET species=REPLACE(species_std,' ','_')
;

-- Flag embargoed species
UPDATE observations_union a
SET is_embargoed=1
FROM taxon b
WHERE a.species_std=b.taxon
AND b.is_embargoed=1
;

-- Index the new columns
CREATE INDEX observations_union_species_std_idx ON observations_union USING btree (species_std)
;
CREATE INDEX observations_union_is_embargoed_idx ON observations_union USING btree (is_embargoed)
;