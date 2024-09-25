-- ---------------------------------------------------------
-- Prepare final table of unique political divisions for 
-- submission to GNRS
-- Basically a copy of poldivs, with added integer_id
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS gnrs_submitted;
CREATE TABLE gnrs_submitted (
id bigserial PRIMARY KEY,
poldiv_full TEXT DEFAULT '',
country TEXT DEFAULT '',
state_province TEXT DEFAULT '',
county_parish TEXT DEFAULT ''
);

INSERT INTO gnrs_submitted (
poldiv_full,
country,
state_province,
county_parish
)
SELECT 
poldiv_full,
country,
state_province,
county_parish
FROM poldivs
;


DROP INDEX IF EXISTS gnrs_submitted_poldiv_full_idx;
DROP INDEX IF EXISTS gnrs_submitted_country_idx;
DROP INDEX IF EXISTS gnrs_submitted_state_province_idx;
DROP INDEX IF EXISTS gnrs_submitted_county_parish_idx;

CREATE INDEX gnrs_submitted_poldiv_full_idx ON gnrs_submitted (poldiv_full);
CREATE INDEX gnrs_submitted_country_idx ON gnrs_submitted (country);
CREATE INDEX gnrs_submitted_state_province_idx ON gnrs_submitted (state_province);
CREATE INDEX gnrs_submitted_county_parish_idx ON gnrs_submitted (county_parish);
