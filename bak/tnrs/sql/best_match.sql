-- ---------------------------------------------------------
-- Recalculates best match
-- ---------------------------------------------------------

SET search_path TO :sch;

--
-- Create temp copy of taxon_scrubbed, adding only the indexes needed
-- 

DROP TABLE IF EXISTS ts_temp CASCADE;
CREATE TABLE ts_temp (LIKE tnrs_scrubbed);
INSERT INTO ts_temp SELECT * FROM tnrs_scrubbed;

-- Rename existing column "selected"
ALTER TABLE ts_temp RENAME COLUMN selected TO selected_orig;

-- Add ranking columns 
ALTER TABLE ts_temp
ADD COLUMN selected text default null,
ADD COLUMN status_rank integer default null,
ADD COLUMN source_rank integer default null
;

--
-- Populate status_rank
-- 

CREATE INDEX ts_temp_taxonomic_status_idx ON ts_temp (taxonomic_status);

UPDATE ts_temp
SET status_rank=
CASE
WHEN taxonomic_status='Illegitimate' THEN 4
WHEN taxonomic_status='Rejected name' THEN 4
WHEN taxonomic_status='Invalid' THEN 4
WHEN taxonomic_status='Misapplied' THEN 4
WHEN taxonomic_status='No opinion' THEN 3
WHEN taxonomic_status='Synonym' THEN 3
WHEN taxonomic_status='Accepted' THEN 1
ELSE NULL
END;

DROP INDEX ts_temp_taxonomic_status_idx;

--
-- Populate source_rank
--

CREATE INDEX ts_temp_source_idx ON ts_temp (source);
CREATE INDEX ts_temp_accepted_name_family_idx ON ts_temp (accepted_name_family);
CREATE INDEX ts_temp_name_matched_accepted_family_idx ON ts_temp (name_matched_accepted_family);

UPDATE ts_temp
SET source_rank=1
WHERE source LIKE '%gcc%' AND (
accepted_name_family='Asteraceae' 
OR name_matched_accepted_family='Asteraceae'
) 
;
UPDATE ts_temp
SET source_rank=1
WHERE source LIKE '%ildis%' AND (
accepted_name_family='Fabaceae' 
OR name_matched_accepted_family='Fabaceae'
) 
;
UPDATE ts_temp
SET source_rank=100
WHERE source='gcc' AND NOT (
accepted_name_family='Fabaceae' 
OR name_matched_accepted_family='Fabaceae'
) 
;
UPDATE ts_temp
SET source_rank=100
WHERE source='ildis' AND NOT (
accepted_name_family='Asteraceae' 
OR name_matched_accepted_family='Asteraceae'
) 
;

CREATE INDEX ts_temp_source_rank_is_null_idx ON ts_temp (source_rank) WHERE source_rank IS NULL;

UPDATE ts_temp
SET source_rank=2
WHERE source like '%tropicos%'
AND source_rank IS NULL
;
UPDATE ts_temp
SET source_rank=3
WHERE source like '%tpl%'
AND source_rank IS NULL
;
UPDATE ts_temp
SET source_rank=4
WHERE source like '%usda%'
AND source_rank IS NULL
;

DROP INDEX ts_temp_source_rank_is_null_idx;
DROP INDEX ts_temp_source_idx;
DROP INDEX ts_temp_accepted_name_family_idx ;
DROP INDEX ts_temp_name_matched_accepted_family_idx;

--
-- Rank and update the selected column
--

-- create remaining indexes
CREATE INDEX ts_temp_name_number_idx ON ts_temp (name_number);
CREATE INDEX ts_temp_overall_score_idx ON ts_temp (overall_score);
CREATE INDEX ts_temp_status_rank_idx ON ts_temp (status_rank);
CREATE INDEX ts_temp_source_rank_idx ON ts_temp (source_rank);
ALTER TABLE ts_temp ADD PRIMARY KEY (tnrs_scrubbed_id);

UPDATE ts_temp a
SET selected='true'
FROM (
SELECT DISTINCT ON (name_number)
	tnrs_scrubbed_id
FROM ts_temp
ORDER BY name_number, overall_score desc, status_rank, source_rank, tnrs_scrubbed_id
) b
WHERE a.tnrs_scrubbed_id=b.tnrs_scrubbed_id
;

--
-- Transfer changes to tnsr_scrubbed & delete temp table
-- 

UPDATE tnrs_scrubbed a
SET selected=b.selected
FROM ts_temp b
WHERE a.tnrs_scrubbed_id=b.tnrs_scrubbed_id
;

DROP TABLE ts_temp;