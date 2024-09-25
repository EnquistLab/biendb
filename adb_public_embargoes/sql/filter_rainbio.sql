-- ---------------------------------------------------------------------
-- Flags and removes from the PUBLIC database all records within 
-- datasource 'rainbio' that are from non-public datasets. 
-- 
-- NOTE 1: vfoi.catalog_number MUST be indexed for operation that
-- populates rainbio_embargoes or this will be extremely slow!
-- 
-- NOTE 2: All indexes should be removed from vfoi, astem and agg_traits
-- at delete stage or these queries will be extremely slow!
-- ---------------------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS rainbio_embargoes;
CREATE TABLE rainbio_embargoes (
id bigserial not null primary key,
taxonobservation_id bigint not null, 
catalog_number text not null,
comment text default null
);

-- Insert all Meise records for potential embargo
INSERT INTO rainbio_embargoes (
taxonobservation_id,
catalog_number
) 
SELECT
taxonobservation_id,
catalog_number
FROM view_full_occurrence_individual
WHERE datasource='rainbio'
AND (
catalog_number LIKE 'MS%'
OR catalog_number LIKE 'BR%'
OR catalog_number LIKE 'UB%'
);

-- Add index needed for next operation
CREATE INDEX rainbio_embargoes_catalog_number_idx ON rainbio_embargoes (catalog_number);

-- Join back to original data and flag for removal any records
-- which have a value in otherCatalogNumbers. These will not
-- be embargoed. Doing in two steps to allow inspection.
UPDATE rainbio_embargoes a 
SET comment='noembargo'
FROM rainbio.rainbio_raw b
WHERE a.catalog_number=b."catalogNumber"
AND b.idsc IS NOT NULL
;

-- Delete the records after inspection
CREATE INDEX rainbio_embargoes_comment_idx ON rainbio_embargoes (comment);
DELETE FROM rainbio_embargoes
WHERE comment='noembargo';

-- Delete the records in all relevant tables
DELETE FROM view_full_occurrence_individual a
USING rainbio_embargoes b
WHERE a.taxonobservation_id=b.taxonobservation_id
;
DELETE FROM analytical_stem a
USING rainbio_embargoes b
WHERE a.taxonobservation_id=b.taxonobservation_id
;
DELETE FROM agg_traits a
USING rainbio_embargoes b
WHERE a.taxonobservation_id=b.taxonobservation_id
;

-- Remove temporary table
DROP TABLE IF EXISTS rainbio_embargoes;
