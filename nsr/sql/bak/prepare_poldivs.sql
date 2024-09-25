-- ---------------------------------------------------------
-- Extract table of all unique political divisions + taxa from
-- vfoi and agg_traits in preparation for scrubbing with
-- NSR
-- ---------------------------------------------------------

-- UNDER CONSTRUCTION!!!! ---

SET search_path TO :sch;

DROP TABLE IF EXISTS nsr_input;
CREATE TABLE nsr_input (
taxon_poldiv TEXT DEFAULT '',
country TEXT DEFAULT '',
state_province TEXT DEFAULT '',
county_parish TEXT DEFAULT '',
taxon text default ''
);

INSERT INTO nsr_input (
taxon_poldiv,
country,
state_province,
county_parish,
taxon
)
SELECT DISTINCT
taxon_poldiv,
country,
state_province,
county,
scrubbed_taxon_name_no_author
FROM view_full_occurrence_individual_dev
;

INSERT INTO nsr_input (
taxon_poldiv,
country,
state_province,
county_parish
)
SELECT DISTINCT
taxon_poldiv,
country_verbatim,
state_province_verbatim,
county_verbatim
FROM agg_traits
;

CREATE TABLE nsr_input_temp (LIKE nsr_input);
INSERT INTO  nsr_input_temp SELECT DISTINCT * FROM nsr_input;
DROP TABLE nsr_input;
ALTER TABLE nsr_input_temp RENAME TO nsr_input;

-- Index FK
DROP INDEX IF EXISTS nsr_input_taxon_poldiv_idx;
CREATE INDEX nsr_input_taxon_poldiv_idx ON nsr_input (taxon_poldiv);



