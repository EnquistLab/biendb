-- ---------------------------------------------------------
-- Create table for storing GNRS validation results
--
-- Exact copy of table user_data in db gnrs
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS gnrs;
CREATE TABLE gnrs (
poldiv_full text DEFAULT NULL,
country_verbatim text DEFAULT '',
state_province_verbatim text DEFAULT '',
state_province_verbatim_alt text DEFAULT '',
county_parish_verbatim text DEFAULT '',
county_parish_verbatim_alt text DEFAULT '',
country text DEFAULT '',
state_province text DEFAULT '',
county_parish text DEFAULT '',
country_id INTEGER DEFAULT NULL,
state_province_id INTEGER DEFAULT NULL,
county_parish_id INTEGER DEFAULT NULL,
country_iso text DEFAULT NULL,
state_province_iso text DEFAULT NULL,
county_parish_iso text DEFAULT NULL,
geonameid INTEGER DEFAULT NULL,
gid_0 text DEFAULT NULL,
gid_1 text DEFAULT NULL,
gid_2 text DEFAULT NULL,
match_method_country text DEFAULT NULL,
match_method_state_province text DEFAULT NULL,
match_method_county_parish text DEFAULT NULL,
match_score_country NUMERIC(4,2) DEFAULT NULL,
match_score_state_province NUMERIC(4,2) DEFAULT NULL,
match_score_county_parish NUMERIC(4,2) DEFAULT NULL,
overall_score NUMERIC(4,2) DEFAULT NULL,
poldiv_submitted text DEFAULT NULL,
poldiv_matched text DEFAULT NULL,
match_status text DEFAULT NULL,
id integer DEFAULT NULL
) 
;
