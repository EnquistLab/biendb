-- ---------------------------------------------------------
-- Index verbatim & scrubbed political division columns 
-- Re-index geom field, including not null filter
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP INDEX IF EXISTS world_geom_country_verbatim_idx;
CREATE INDEX world_geom_country_verbatim_idx ON world_geom (country_verbatim);

DROP INDEX IF EXISTS world_geom_state_province_verbatim_idx;
CREATE INDEX world_geom_state_province_verbatim_idx ON world_geom (state_province_verbatim);

DROP INDEX IF EXISTS world_geom_county_verbatim_idx;
CREATE INDEX world_geom_county_verbatim_idx ON world_geom (county_verbatim);

DROP INDEX IF EXISTS world_geom_country_idx;
CREATE INDEX world_geom_country_idx ON world_geom (country);

DROP INDEX IF EXISTS world_geom_state_province_idx;
CREATE INDEX world_geom_state_province_idx ON world_geom (state_province);

DROP INDEX IF EXISTS world_geom_county_idx;
CREATE INDEX world_geom_county_idx ON world_geom (county);

DROP INDEX IF EXISTS world_geom_match_status_idx;
CREATE INDEX world_geom_match_status_idx ON world_geom (match_status);

DROP INDEX IF EXISTS world_geom_geom_idx;
CREATE INDEX world_geom_geom_idx ON world_geom USING gist (geom) WHERE geom IS NOT NULL;
