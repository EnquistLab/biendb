-- ---------------------------------------------------------------
-- Add column is_embargoed to table taxon
-- ADDED TO BIEN 4.2 PIPELINE
-- ---------------------------------------------------------------

DROP TABLE IF EXISTS temp_embargoed_taxa1;
CREATE TABLE temp_embargoed_taxa1 AS
SELECT scrubbed_taxon_name_no_author as embargoed_taxon
FROM view_full_occurrence_individual
WHERE is_embargoed_observation=1
;

DROP TABLE IF EXISTS embargoed_taxa;
CREATE TABLE embargoed_taxa AS
SELECT DISTINCT embargoed_taxon
FROM temp_embargoed_taxa1
;
CREATE INDEX embargoed_taxa_embargoed_taxa_idx ON embargoed_taxa(embargoed_taxon);

ALTER TABLE taxon 
ADD COLUMN is_embargoed smallint default 0;

UPDATE taxon a
SET is_embargoed=1
FROM embargoed_taxa b
WHERE a.taxon=b.embargoed_taxon
;
CREATE INDEX taxon_is_embargoed_idx ON taxon(is_embargoed);

DROP TABLE temp_embargoed_taxa1;
DROP TABLE embargoed_taxa;