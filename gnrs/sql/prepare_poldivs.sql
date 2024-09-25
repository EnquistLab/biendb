-- ---------------------------------------------------------
-- Extract table of all unique political divisions from
-- vfoi and agg_traits in preparation for scrubbing with
-- GNRS
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS poldivs;
CREATE TABLE poldivs (
poldiv_full TEXT DEFAULT '',
country TEXT DEFAULT '',
state_province TEXT DEFAULT '',
county_parish TEXT DEFAULT ''
);

INSERT INTO poldivs (
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
FROM view_full_occurrence_individual_dev
;

INSERT INTO poldivs (
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
FROM agg_traits
;

INSERT INTO poldivs (
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
FROM plot_metadata
;

INSERT INTO poldivs (
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

DROP TABLE IF EXISTS poldivs_temp;
CREATE TABLE poldivs_temp (LIKE poldivs);

-- Just insert PK to eliminate duplicates due to slight differences
-- in padding whitespace. This is faster than trimming extract
-- from each table. Critical to avoid PK anomalies on update!
INSERT INTO poldivs_temp (poldiv_full) 
SELECT DISTINCT poldiv_full FROM poldivs;

ALTER TABLE poldivs_temp ADD PRIMARY KEY (poldiv_full);

UPDATE poldivs_temp a
SET 
country=b.country,
state_province=b.state_province,
county_parish=b.county_parish
FROM poldivs b
WHERE a.poldiv_full=b.poldiv_full
;

DROP TABLE poldivs;
ALTER TABLE poldivs_temp RENAME TO poldivs;
