-- ---------------------------------------------------------------
-- Alters table observations union so that content of column "species"
-- is identical to version in geombien and used by biendata.org, i.e.,
-- underscore ('_') instead of space between genus and specific epithet.
-- Normal version with space moved to new column species_std.
-- 
-- DB version not incremented (at 4.1.1)
-- ADDED TO BIEN 4.2 PIPELINE
-- ---------------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

ALTER TABLE observations_union
ADD COLUMN species_std text
;

UPDATE observations_union
SET species_std=species
;

CREATE INDEX observations_union_species_std_idx ON observations_union USING btree (species_std)
;

UPDATE observations_union
SET species=REPLACE(species_std,' ','_')
;

\c public_vegbien

ALTER TABLE observations_union
ADD COLUMN species_std text
;

UPDATE observations_union
SET species_std=species
;

UPDATE observations_union
SET species=REPLACE(species_std,' ','_')
;

CREATE INDEX observations_union_species_std_idx ON observations_union USING btree (species_std)
;

