-- ---------------------------------------------------------
-- Extract table of all unique political divisions from
-- ppg spatial reference table world_geom
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS world_geom_poldivs;
CREATE TABLE world_geom_poldivs (
poldiv_full TEXT DEFAULT '',
country TEXT DEFAULT '',
state_province TEXT DEFAULT '',
county_parish TEXT DEFAULT ''
);

INSERT INTO world_geom_poldivs (
poldiv_full,
country,
state_province,
county_parish
)
SELECT DISTINCT
poldiv_full,
country_verbatim,
state_province_verbatim,
county_verbatim
FROM world_geom
;

-- Index FK
DROP INDEX IF EXISTS world_geom_poldivs_poldiv_full_idx;
CREATE INDEX world_geom_poldivs_poldiv_full_idx ON world_geom_poldivs (poldiv_full);