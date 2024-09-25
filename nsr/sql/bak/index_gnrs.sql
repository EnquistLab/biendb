-- ---------------------------------------------------------
-- Index GNRS results table 
-- ---------------------------------------------------------

SET search_path TO :sch;

-- Populate user_id as well
UPDATE gnrs
SET user_id=poldiv_full
;

DROP INDEX IF EXISTS gnrs_poldiv_full_idx;
DROP INDEX IF EXISTS gnrs_country_verbatim_idx;
DROP INDEX IF EXISTS gnrs_state_province_verbatim_idx;
DROP INDEX IF EXISTS gnrs_county_parish_verbatim_idx;
DROP INDEX IF EXISTS gnrs_country_idx;
DROP INDEX IF EXISTS gnrs_state_province_idx;
DROP INDEX IF EXISTS gnrs_county_parish_idx;
DROP INDEX IF EXISTS gnrs_match_method_state_province_idx;
DROP INDEX IF EXISTS gnrs_match_method_county_parish_idx;
DROP INDEX IF EXISTS gnrs_poldiv_submitted_idx;
DROP INDEX IF EXISTS gnrs_poldiv_matched_idx;
DROP INDEX IF EXISTS gnrs_match_status_idx;
DROP INDEX IF EXISTS gnrs_user_id_idx;


CREATE INDEX  gnrs_poldiv_full_idx ON gnrs (poldiv_full);
CREATE INDEX  gnrs_country_verbatim_idx ON gnrs (country_verbatim);
CREATE INDEX  gnrs_state_province_verbatim_idx ON gnrs (state_province_verbatim);
CREATE INDEX  gnrs_county_parish_verbatim_idx ON gnrs (county_parish_verbatim);
CREATE INDEX  gnrs_country_idx ON gnrs (country);
CREATE INDEX  gnrs_state_province_idx ON gnrs (state_province);
CREATE INDEX  gnrs_county_parish_idx ON gnrs (county_parish);
CREATE INDEX  gnrs_match_method_state_province_idx ON gnrs (match_method_state_province);
CREATE INDEX  gnrs_match_method_county_parish_idx ON gnrs (match_method_county_parish);
CREATE INDEX  gnrs_poldiv_submitted_idx ON gnrs (poldiv_submitted);
CREATE INDEX  gnrs_poldiv_matched_idx ON gnrs (poldiv_matched);
CREATE INDEX  gnrs_match_status_idx ON gnrs (match_status);
CREATE INDEX  gnrs_user_id_idx ON gnrs (user_id);
