-- ----------------------------------------------------------------
-- Creates table taxon
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS taxon;
CREATE TABLE taxon (
taxon_id serial primary key,
family_taxon_id integer,
genus_taxon_id integer,
species_taxon_id integer,
taxon_rank text,
family text,
genus text,
species text,
taxon text
);


