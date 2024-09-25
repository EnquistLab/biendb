-- ---------------------------------------------------------
-- Creates table taxon_verbartim and indexes it back to 
-- table agg_traits
-- ---------------------------------------------------------

set search_path to :dev_schema;

-- Select distinct values into separate table
DROP TABLE IF EXISTS taxon_verbatim CASCADE; 
CREATE TABLE taxon_verbatim AS 
SELECT DISTINCT name_submitted AS taxon_verbatim 
FROM agg_traits;

-- Index taxon_verbatim
ALTER TABLE taxon_verbatim
ADD COLUMN taxon_verbatim_id serial primary key not null
;
CREATE INDEX taxon_verbatim_taxon_verbatim_id_idx ON taxon_verbatim (taxon_verbatim_id);
CREATE INDEX taxon_verbatim_taxon_verbatim_idx ON taxon_verbatim (taxon_verbatim);

-- Add and populate FK linking agg_traits to PK
-- of taxon_verbatim
ALTER TABLE agg_traits
ADD COLUMN fk_tnrs_user_id INTEGER DEFAULT NULL
;
UPDATE agg_traits a
SET fk_tnrs_user_id=b.taxon_verbatim_id
FROM taxon_verbatim b
WHERE a.name_submitted=b.taxon_verbatim
;

-- Index the FK
CREATE INDEX agg_traits_fk_tnrs_user_id_idx ON agg_traits (fk_tnrs_user_id);
