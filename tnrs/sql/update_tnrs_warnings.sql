-- ----------------------------------------------------------------
-- Re-populate column tnrs_warning with more informative messages
-- and populate overall match summary column
-- NOTE: most schema changes here should be moved to original
-- create table script
-- ----------------------------------------------------------------

-- 
-- Simplified version. Ultimately need more detailed breakdown 
-- which includes:
-- 	"Complete match"
-- 	"Complete match on taxon, author changed"
--	"Complete match to synonym; different accepted name"
-- 	etc. Need to come up with list of logical alternatives
-- 

set search_path to :sch;

-- Completely replace column; temporary fix until I can figure 
-- out how to translate integer codes produced by TNRSbatch
ALTER TABLE tnrs DROP COLUMN tnrs_warning;
ALTER TABLE tnrs 
ADD COLUMN tnrs_warning text DEFAULT NULL,
ADD COLUMN tnrs_match_summary text DEFAULT NULL,
ADD COLUMN tnrs_author_matched_score DECIMAL(3,2) DEFAULT NULL,
ADD COLUMN taxon_submitted text DEFAULT NULL
;
ALTER TABLE tnrs
ALTER COLUMN tnrs_name_matched_score TYPE DECIMAL(3,2) USING tnrs_name_matched_score::DECIMAL(3,2)
;

-- Populate taxon_submitted
-- Incomplete until I can figure out how to extract infraspecific name
-- submitted from TNRSbatch
UPDATE tnrs
SET taxon_submitted=
CASE
WHEN genus_submitted IS NULL THEN family_submitted
ELSE TRIM(CONCAT_WS(' ', genus_submitted, specific_epithet_submitted))
END
;
UPDATE tnrs
SET taxon_submitted=NULL
WHERE TRIM(taxon_submitted)=''
AND taxon_submitted IS NOT NULL
;

-- Populate missing values of name_sbmitted_rank based
-- on taxon_submitted
UPDATE tnrs
SET name_submitted_rank=
CASE
WHEN taxon_submitted NOT LIKE '% %' THEN 'genus'
WHEN taxon_submitted LIKE '% %' AND taxon_submitted NOT LIKE '% % %' THEN 'species'
ELSE NULL
END
WHERE name_submitted_rank IS NULL
;
UPDATE tnrs
SET name_submitted_rank='family'
WHERE name_submitted_rank='genus'
AND taxon_submitted ILIKE '%aceae%'
;

-- Add indexes on new columns
-- All other indexes should already be present
DROP INDEX IF EXISTS tnrs_tnrs_warning_idx;
CREATE INDEX tnrs_tnrs_warning_idx ON tnrs (tnrs_warning)
;
DROP INDEX IF EXISTS tnrs_tnrs_match_summary_idx;
CREATE INDEX tnrs_tnrs_match_summary_idx ON tnrs (tnrs_match_summary)
;
DROP INDEX IF EXISTS tnrs_tnrs_author_matched_score_idx;
CREATE INDEX tnrs_tnrs_author_matched_score_idx ON tnrs (tnrs_author_matched_score)
;
DROP INDEX IF EXISTS tnrs_taxon_submitted_idx;
CREATE INDEX tnrs_taxon_submitted_idx ON tnrs (taxon_submitted)
;

-- 
-- warnings
-- 

UPDATE tnrs
SET tnrs_warning=trim(tnrs_warning)
WHERE tnrs_warning IS NOT NULL
;
UPDATE tnrs
SET tnrs_warning=NULL
WHERE tnrs_warning=''
;

-- No match
UPDATE tnrs
SET tnrs_warning='No match'
WHERE name_matched IS NULL OR name_matched = ''
AND tnrs_warning IS NULL
;

-- Partial match
UPDATE tnrs
SET tnrs_warning='Partial match'
WHERE name_submitted_rank<>name_matched_rank
AND name_matched_rank IS NOT NULL AND name_matched_rank <> ''
AND tnrs_warning IS NULL
;

-- 
-- Append taxonomic status changes
-- 

-- No match
UPDATE tnrs
SET tnrs_match_summary='No match'
WHERE name_matched IS NULL
;

-- Exact match
UPDATE tnrs
SET tnrs_match_summary='Exact match'
WHERE (
name_submitted=name_matched OR tnrs_name_matched_score=1
)
AND tnrs_match_summary IS NULL
;

-- Fuzzy match
UPDATE tnrs
SET tnrs_match_summary='Fuzzy match'
WHERE name_submitted<>name_matched 
AND name_submitted_rank=name_matched_rank
AND tnrs_match_summary IS NULL
;

-- Partial match
UPDATE tnrs
SET tnrs_match_summary='Partial match to higher taxon'
WHERE name_submitted_rank<>name_matched_rank
AND name_matched_rank IS NOT NULL AND name_matched_rank <> ''
AND tnrs_match_summary IS NULL
;
UPDATE tnrs
SET tnrs_match_summary='Partial match to higher taxon'
WHERE tnrs_warning='Partial match'
;
