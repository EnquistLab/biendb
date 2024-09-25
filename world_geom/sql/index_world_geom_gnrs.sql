-- ---------------------------------------------------------
-- Index GNRS results table 
-- ---------------------------------------------------------

SET search_path TO :sch;

-- Populate user_id as well
UPDATE world_geom_gnrs
SET user_id=poldiv_full
;

DROP INDEX IF EXISTS world_geom_gnrs_poldiv_full_idx;
DROP INDEX IF EXISTS world_geom_gnrs_country_verbatim_idx;
DROP INDEX IF EXISTS world_geom_gnrs_state_province_verbatim_idx;
DROP INDEX IF EXISTS world_geom_gnrs_county_parish_verbatim_idx;
DROP INDEX IF EXISTS world_geom_gnrs_country_idx;
DROP INDEX IF EXISTS world_geom_gnrs_state_province_idx;
DROP INDEX IF EXISTS world_geom_gnrs_county_parish_idx;
DROP INDEX IF EXISTS world_geom_gnrs_match_method_state_province_idx;
DROP INDEX IF EXISTS world_geom_gnrs_match_method_county_parish_idx;
DROP INDEX IF EXISTS world_geom_gnrs_poldiv_submitted_idx;
DROP INDEX IF EXISTS world_geom_gnrs_poldiv_matched_idx;
DROP INDEX IF EXISTS world_geom_gnrs_match_status_idx;
DROP INDEX IF EXISTS world_geom_gnrs_user_id_idx;


CREATE INDEX  world_geom_gnrs_poldiv_full_idx ON world_geom_gnrs (poldiv_full);
CREATE INDEX  world_geom_gnrs_country_verbatim_idx ON world_geom_gnrs (country_verbatim);
CREATE INDEX  world_geom_gnrs_state_province_verbatim_idx ON world_geom_gnrs (state_province_verbatim);
CREATE INDEX  world_geom_gnrs_county_parish_verbatim_idx ON world_geom_gnrs (county_parish_verbatim);
CREATE INDEX  world_geom_gnrs_country_idx ON world_geom_gnrs (country);
CREATE INDEX  world_geom_gnrs_state_province_idx ON world_geom_gnrs (state_province);
CREATE INDEX  world_geom_gnrs_county_parish_idx ON world_geom_gnrs (county_parish);
CREATE INDEX  world_geom_gnrs_match_method_state_province_idx ON world_geom_gnrs (match_method_state_province);
CREATE INDEX  world_geom_gnrs_match_method_county_parish_idx ON world_geom_gnrs (match_method_county_parish);
CREATE INDEX  world_geom_gnrs_poldiv_submitted_idx ON world_geom_gnrs (poldiv_submitted);
CREATE INDEX  world_geom_gnrs_poldiv_matched_idx ON world_geom_gnrs (poldiv_matched);
CREATE INDEX  world_geom_gnrs_match_status_idx ON world_geom_gnrs (match_status);
CREATE INDEX  world_geom_gnrs_user_id_idx ON world_geom_gnrs (user_id);
