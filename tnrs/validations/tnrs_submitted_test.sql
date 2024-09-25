CREATE TABLE tnrs_submitted_test (
tbl text,
name_submitted text
);

INSERT INTO tnrs_submitted_test (
tbl,
name_submitted
)
SELECT DISTINCT 
'endangered_taxa_by_source',
verbatim_taxon
FROM endangered_taxa_by_source
WHERE verbatim_taxon IS NOT NULL AND verbatim_taxon<>''
;


INSERT INTO tnrs_submitted_test (
tbl,
name_submitted
)
SELECT DISTINCT 
'agg_traits',
name_submitted
FROM agg_traits
WHERE name_submitted IS NOT NULL AND name_submitted<>''
;

INSERT INTO tnrs_submitted_test (
tbl,
name_submitted
)
SELECT DISTINCT 
'vfoi',
name_submitted
FROM view_full_occurrence_individual_dev
WHERE name_submitted IS NOT NULL AND name_submitted<>''
;


CREATE TABLE tnrs_submitted_test_uniq AS 
SELECT DISTINCT name_submitted
FROM tnrs_submitted_test
;
