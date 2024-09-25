-- -----------------------------------------------------------
-- Add missing GNRS results to table ih
-- One-time fix only
-- -----------------------------------------------------------

DROP TABLE IF EXISTS temp_poldivs_ih;
CREATE TABLE temp_poldivs_ih (
poldiv_full TEXT DEFAULT '',
country TEXT DEFAULT '',
state_province TEXT DEFAULT '',
county_parish TEXT DEFAULT ''
);

INSERT INTO temp_poldivs_ih (
poldiv_full,
country,
state_province,
county_parish
)
SELECT DISTINCT
poldiv_full,
country_verbatim,
state_province_verbatim,
''
FROM ih
;

CREATE TABLE poldivs_temp (LIKE temp_poldivs_ih);
INSERT INTO  poldivs_temp SELECT DISTINCT * FROM temp_poldivs_ih;
DROP TABLE temp_poldivs_ih;
ALTER TABLE poldivs_temp RENAME TO temp_poldivs_ih;

-- Index FK
DROP INDEX IF EXISTS temp_poldivs_ih_poldiv_full_idx;
CREATE INDEX temp_poldivs_ih_poldiv_full_idx ON temp_poldivs_ih (poldiv_full);

\copy (select distinct '' as user_id, country, state_province, county_parish from temp_poldivs_ih) to /home/boyle/bien3/gnrs/userdata/gnrs_ih_submitted.csv csv header

-- Run gnrs_import.sh, gnrs.sh, gnrs_export.sh
-- Be sure to modify file names in gnrs/params.sh first


DROP TABLE IF EXISTS gnrs_ih;
CREATE TABLE gnrs_ih (
id BIGINT NOT NULL PRIMARY KEY,
poldiv_full text DEFAULT NULL,
country_verbatim text DEFAULT '',
state_province_verbatim text DEFAULT '',
county_parish_verbatim text DEFAULT '',
country VARCHAR(250) DEFAULT NULL,
state_province VARCHAR(250) DEFAULT NULL,
county_parish VARCHAR(250) DEFAULT NULL,
country_id INTEGER DEFAULT NULL,
state_province_id INTEGER DEFAULT NULL,
county_parish_id INTEGER DEFAULT NULL,
match_method_country VARCHAR(50) DEFAULT NULL,
match_method_state_province VARCHAR(50) DEFAULT NULL,
match_method_county_parish VARCHAR(50) DEFAULT NULL,
match_score_country NUMERIC(4,2) DEFAULT NULL,
match_score_state_province NUMERIC(4,2) DEFAULT NULL,
match_score_county_parish NUMERIC(4,2) DEFAULT NULL,
poldiv_submitted VARCHAR(50) DEFAULT NULL, 
poldiv_matched VARCHAR(50) DEFAULT NULL,
match_status VARCHAR(50) DEFAULT NULL,
user_id text DEFAULT NULL
) 
;

\COPY gnrs_ih FROM '/home/boyle/bien3/gnrs/userdata/gnrs_ih_results.csv' DELIMITER ',' CSV HEADER;


UPDATE gnrs_ih
SET user_id=poldiv_full
;

DROP INDEX IF EXISTS gnrs_ih_poldiv_full_idx;
DROP INDEX IF EXISTS gnrs_ih_country_verbatim_idx;
DROP INDEX IF EXISTS gnrs_ih_state_province_verbatim_idx;
DROP INDEX IF EXISTS gnrs_ih_county_parish_verbatim_idx;
DROP INDEX IF EXISTS gnrs_ih_country_idx;
DROP INDEX IF EXISTS gnrs_ih_state_province_idx;
DROP INDEX IF EXISTS gnrs_ih_county_parish_idx;
DROP INDEX IF EXISTS gnrs_ih_match_method_state_province_idx;
DROP INDEX IF EXISTS gnrs_ih_match_method_county_parish_idx;
DROP INDEX IF EXISTS gnrs_ih_poldiv_submitted_idx;
DROP INDEX IF EXISTS gnrs_ih_poldiv_matched_idx;
DROP INDEX IF EXISTS gnrs_ih_match_status_idx;
DROP INDEX IF EXISTS gnrs_ih_user_id_idx;


CREATE INDEX  gnrs_ih_poldiv_full_idx ON gnrs_ih (poldiv_full);
CREATE INDEX  gnrs_ih_country_verbatim_idx ON gnrs_ih (country_verbatim);
CREATE INDEX  gnrs_ih_state_province_verbatim_idx ON gnrs_ih (state_province_verbatim);
CREATE INDEX  gnrs_ih_county_parish_verbatim_idx ON gnrs_ih (county_parish_verbatim);
CREATE INDEX  gnrs_ih_country_idx ON gnrs_ih (country);
CREATE INDEX  gnrs_ih_state_province_idx ON gnrs_ih (state_province);
CREATE INDEX  gnrs_ih_county_parish_idx ON gnrs_ih (county_parish);
CREATE INDEX  gnrs_ih_match_method_state_province_idx ON gnrs_ih (match_method_state_province);
CREATE INDEX  gnrs_ih_match_method_county_parish_idx ON gnrs_ih (match_method_county_parish);
CREATE INDEX  gnrs_ih_poldiv_submitted_idx ON gnrs_ih (poldiv_submitted);
CREATE INDEX  gnrs_ih_poldiv_matched_idx ON gnrs_ih (poldiv_matched);
CREATE INDEX  gnrs_ih_match_status_idx ON gnrs_ih (match_status);
CREATE INDEX  gnrs_ih_user_id_idx ON gnrs_ih (user_id);

UPDATE ih a
SET
fk_gnrs_id=b.id,
country=b.country,
state_province=b.state_province
FROM gnrs_ih b
WHERE a.poldiv_full=b.poldiv_full
;

-- Clean up
DROP TABLE temp_poldivs_ih;