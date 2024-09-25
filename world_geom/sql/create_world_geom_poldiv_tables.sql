-- ----------------------------------------------------------------
-- Create tables on political division names only, for quick filtering
-- ----------------------------------------------------------------

SET search_path to :sch;

DROP TABLE IF EXISTS world_geom_county;
CREATE TABLE world_geom_county AS
SELECT DISTINCT country, state_province, county
FROM world_geom
WHERE country IS NOT NULL
AND state_province IS NOT NULL
AND county IS NOT NULL
;
CREATE UNIQUE INDEX ON world_geom_county (country, state_province, county);

DROP TABLE IF EXISTS world_geom_state;
CREATE TABLE world_geom_state AS
SELECT DISTINCT country, state_province
FROM world_geom
WHERE country IS NOT NULL
AND state_province IS NOT NULL
;
CREATE UNIQUE INDEX ON world_geom_state (country, state_province);

DROP TABLE IF EXISTS world_geom_country;
CREATE TABLE world_geom_country AS
SELECT DISTINCT country
FROM world_geom
WHERE country IS NOT NULL
;
CREATE UNIQUE INDEX ON world_geom_country (country);
