-- -------------------------------------------------------------
-- Flag as cultivated based proximity to herbarium or botanical
-- garden
-- -------------------------------------------------------------

SET search_path TO :sch;

-- Get subset of records to be processed
DROP TABLE IF EXISTS cultobs_sample;
CREATE TABLE cultobs_sample AS
SELECT *
FROM cultobs
WHERE cultobs_id>=:first_id 
ORDER BY cultobs_id
LIMIT :reclimit
;

-- Temporary fix for stupid apostrophes in state names, mostly Russia
-- Need to fix this permanently in GNRS
UPDATE cultobs_sample
SET state_province=REPLACE(state_province,'''','')
WHERE state_province LIKE '%''%'
;

ALTER TABLE cultobs_sample
ADD COLUMN done smallint default 0
;

ALTER TABLE cultobs_sample ADD PRIMARY KEY (cultobs_id);
CREATE INDEX cultobs_sample_done_idx ON cultobs_sample (done);
CREATE INDEX cultobs_sample_country_idx ON cultobs_sample (country);
CREATE INDEX cultobs_sample_state_province_idx ON cultobs_sample (state_province);
