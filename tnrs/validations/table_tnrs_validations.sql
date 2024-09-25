-- Visually verify that verbatim & submitted names match up

-- Check tnrs_scrubbed
SELECT name_id, name_submitted, 
name_matched, 
accepted_name
FROM tnrs_scrubbed
ORDER BY name_id
LIMIT 25
;

-- Compare tnrs_submitted and tnrs_scrubbed, joining by name_id
SELECT a.name_id, 
a.name_submitted_verbatim, a.name_submitted, 
b.name_submitted_verbatim, b.name_submitted, 
b.name_matched
FROM tnrs_submitted a JOIN tnrs_scrubbed b
ON a.name_id=b.name_id
LIMIT 12
;

-- Compare tnrs_submitted and tnrs_scrubbed, joining by name_submitted
-- With LEFT JOIN to show non-matches
SELECT a.name_id, b.name_id,
a.name_submitted_verbatim, a.name_submitted, 
b.name_submitted_verbatim, b.name_submitted, 
b.name_matched
FROM tnrs_submitted a LEFT JOIN tnrs_scrubbed b
ON a.name_submitted=b.name_submitted
LIMIT 12
;

-- Compare tnrs_submitted and tnrs_scrubbed, joining by name_submitted
-- tnrs_submitted non-matches only
SELECT a.name_id, b.name_id,
a.name_submitted_verbatim, a.name_submitted, 
b.name_submitted_verbatim, b.name_submitted, 
b.name_matched
FROM tnrs_submitted a LEFT JOIN tnrs_scrubbed b
ON a.name_submitted=b.name_submitted
WHERE b.name_id IS NULL
LIMIT 12
;

-- Count total non-matches in taxon_submitted due to joining by verbatim_name
SELECT COUNT(*) FROM (
SELECT a.name_id, b.name_id,
a.name_submitted_verbatim, a.name_submitted, 
b.name_submitted_verbatim, b.name_submitted, 
b.name_matched
FROM tnrs_submitted a LEFT JOIN tnrs_scrubbed b
ON a.name_submitted=b.name_submitted
WHERE b.name_id IS NULL
) AS a
;

-- Compare tnrs_submitted and tnrs_scrubbed, joining by name_submitted
-- tnrs_scrubbed non-matches only
SELECT a.name_id, b.name_id,
a.name_submitted_verbatim, a.name_submitted, 
b.name_submitted_verbatim, b.name_submitted, 
b.name_matched
FROM tnrs_submitted a RIGHT JOIN tnrs_scrubbed b
ON a.name_submitted=b.name_submitted
WHERE a.name_id IS NULL
LIMIT 12
;

-- Count total non-matches in taxon_submitted due to joining by verbatim_name
SELECT COUNT(*) FROM (
SELECT a.name_id, b.name_id,
a.name_submitted_verbatim, a.name_submitted, 
b.name_submitted_verbatim, b.name_submitted, 
b.name_matched
FROM tnrs_submitted a LEFT JOIN tnrs_scrubbed b
ON a.name_submitted=b.name_submitted
WHERE b.name_id IS NULL
) AS a
;



-- Verify that original and possibly modified submitted names 
-- represent the same record
SELECT a.name_id, 
a.name_submitted_verbatim, a.name_submitted, 
b.name_submitted_verbatim, b.name_submitted, 
b.name_matched
FROM tnrs_submitted a JOIN tnrs b
ON a.name_id=b.name_id
LIMIT 12
;

-- Visually inspect most important result columns
-- Adjust limit and offset as needed
SELECT 
left(name_submitted, 30) as submitted,
name_matched, 
tnrs_name_matched_score as match_score, 
unmatched_terms, 
matched_taxonomic_status as matched_status, 
scrubbed_taxon_name_no_author as accepted_name, 
"sources"
FROM tnrs
LIMIT 30
OFFSET 1000
;

-- Inspect unmatched terms, relative to verbatim name and name submitted  
SELECT name_submitted_verbatim, name_submitted, name_matched, unmatched_terms
FROM tnrs
WHERE unmatched_terms IS NOT NULL
LIMIT 30
OFFSET 1000
;

-- without author
SELECT
left(name_submitted,30) as submitted,
name_submitted_rank as ns_rank,
name_matched,
name_matched_rank as nm_rank,
tnrs_name_matched_score as nm_score,
tnrs_warning as warnings,
tnrs_match_summary as summary,
matched_taxonomic_status AS matched_status,
scrubbed_taxon_name_no_author as accepted_name
FROM tnrs
WHERE author_submitted is null
AND tnrs_match_summary<>'No match'
LIMIT 40
;


-- without author, list submitted name components
SELECT
name_submitted,
name_submitted_rank as ns_rank,
taxon_submitted,
name_matched,
name_matched_rank as nm_rank,
tnrs_name_matched_score as nm_score,
matched_taxonomic_status AS tax_status,
tnrs_warning as warnings,
tnrs_match_summary as summary
FROM tnrs
WHERE author_submitted is null
AND tnrs_match_summary is null
LIMIT 40
;

-- with author
SELECT
left(name_submitted,30) as name_submitted,
name_submitted_rank as ns_rank,
author_submitted as auth_subm,
left(name_matched,16) as name_matched,
name_matched_author as auth_matched,
name_matched_rank as nm_rank,
tnrs_name_matched_score  as nm_score,
tnrs_author_matched_score as a_score,
matched_taxonomic_status AS tax_status,
left(tnrs_match_summary, 20) as summary, 
scrubbed_family,
scrubbed_taxon_name_no_author as accepted_name
FROM tnrs
WHERE author_submitted is not null
LIMIT 40
;

-- compare family submitted, matched and scrubbed
SELECT
left(name_submitted,30) as name_submitted,
left(name_matched,16) as name_matched,
family_submitted as fam_subm,
family_matched as fam_match, tnrs_name_matched_score  as nm_score,
matched_taxonomic_status AS tax_status,
left(tnrs_match_summary, 12) as summary, 
scrubbed_family,
scrubbed_taxon_name_no_author as accepted_name, name_id
FROM tnrs
WHERE family_submitted is not null
LIMIT 40
;

