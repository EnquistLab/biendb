-- ---------------------------------------------------------
-- Create analytical table species_by_political_division
-- ---------------------------------------------------------

SET search_path TO :dev_schema;

--
-- Create the table and insert unique species + political divisions
--

DROP TABLE IF EXISTS species_by_political_division;
CREATE TABLE species_by_political_division (
species_by_political_division_id BIGSERIAL PRIMARY KEY,
scrubbed_species_binomial text DEFAULT NULL,
country text DEFAULT NULL,
state_province text DEFAULT NULL,
county text DEFAULT NULL,
is_new_world smallint DEFAULT 0,
is_introduced smallint DEFAULT NULL,
native_status text DEFAULT NULL,
is_cultivated_in_region smallint DEFAULT NULL,
species_poldivs text DEFAULT NULL
);

-- Insert just these four fields to guarantee each combination is unique
INSERT INTO species_by_political_division (
country,
state_province,
county,
scrubbed_species_binomial
)
SELECT DISTINCT
country,
state_province,
county,
scrubbed_species_binomial
FROM view_full_occurrence_individual_dev
-- FROM view_full_occurrence_individual
WHERE scrubbed_species_binomial IS NOT NULL
AND country IS NOT NULL -- no point in including unresolved locations
;

--
-- Populate the candidate foreign key
--

UPDATE species_by_political_division
SET species_poldivs=CONCAT_WS('@',
scrubbed_species_binomial,
coalesce(country, ''),
coalesce(state_province, ''),
coalesce(county, '')
)
;

--
-- Populate is_new_world
--

CREATE INDEX species_by_political_division_country_idx ON species_by_political_division (country);

DROP TABLE IF EXISTS temp_new_world;
CREATE TABLE temp_new_world AS
SELECT DISTINCT country
FROM view_full_occurrence_individual_dev
-- FROM view_full_occurrence_individual
WHERE is_new_world=1
AND country IS NOT NULL
;
CREATE INDEX temp_new_world_country_idx ON temp_new_world (country);

UPDATE species_by_political_division a
SET is_new_world=1
FROM temp_new_world b
WHERE a.country=b.country
;
DROP TABLE temp_new_world;

--
-- Populate NSR fields
--

CREATE INDEX species_by_political_division_species_poldivs_idx ON species_by_political_division (species_poldivs);

-- Add FK species poldivs column to nsr
ALTER TABLE nsr DROP COLUMN IF EXISTS species_poldivs;
ALTER TABLE nsr 
ADD COLUMN species_poldivs text default null
;
UPDATE nsr
SET species_poldivs=CONCAT_WS('@',
species,
coalesce(country, ''),
coalesce(state_province, ''),
coalesce(county_parish, '')
)
WHERE species IS NOT NULL
;
CREATE INDEX nsr_species_poldivs_idx ON nsr (species_poldivs);

-- Update species_by_political_division
UPDATE species_by_political_division a
SET is_introduced=b.isintroduced::integer,
native_status=b.native_status,
is_cultivated_in_region=b.is_cultivated_in_region::integer
FROM nsr b
WHERE a.species_poldivs=b.species_poldivs
;

--
-- Index the remaining fields
--

CREATE INDEX species_by_political_division_state_province_idx ON species_by_political_division (state_province);
CREATE INDEX species_by_political_division_country_state_province_idx ON species_by_political_division (country,state_province);
CREATE INDEX species_by_political_division_country_state_province_county_idx ON species_by_political_division (country,state_province,county);
CREATE INDEX species_by_political_division_scrubbed_species_binomial_idx ON species_by_political_division (scrubbed_species_binomial);
CREATE INDEX species_by_political_division_is_new_world_idx ON species_by_political_division (is_new_world);
CREATE INDEX species_by_political_division_is_cultivated_in_region_idx ON species_by_political_division (is_cultivated_in_region);
CREATE INDEX species_by_political_division_is_introduced_idx ON species_by_political_division (is_introduced);
CREATE INDEX species_by_political_division_native_status_idx ON species_by_political_division (native_status);
CREATE INDEX species_by_political_division_rank_idx ON species_by_political_division (rank);

--
-- Add taxonomic status (add on)
-- 

ALTER TABLE taxon_status DROP COLUMN IF EXISTS id;
ALTER TABLE taxon_status
ADD COLUMN id BIGSERIAL PRIMARY KEY
;

DROP TABLE IF EXISTS species_status;
CREATE TABLE species_status AS
SELECT DISTINCT species_binomial, 
'Unresolved'::text AS taxonomic_status
FROM taxon_status
WHERE rank='species'
;
ALTER TABLE species_status
ADD CONSTRAINT species_status_pk PRIMARY KEY (species_binomial)
;

DROP TABLE IF EXISTS accepted_species_temp;
CREATE TABLE accepted_species_temp AS
SELECT x.species_binomial
FROM taxon_status x JOIN (
SELECT species_binomial, COUNT(*) 
FROM taxon_status
WHERE rank='species' AND taxonomic_status='Accepted'
GROUP BY species_binomial
HAVING COUNT(*)=1
) y
ON x.species_binomial=y.species_binomial
WHERE rank='species' AND taxonomic_status='Accepted'
;
DROP TABLE IF EXISTS accepted_species;
CREATE TABLE accepted_species AS
SELECT DISTINCT species_binomial
FROM accepted_species_temp
;
DROP TABLE accepted_species_temp;
CREATE INDEX accepted_species_species_binomial_idx ON accepted_species (species_binomial);

UPDATE species_status a
SET taxonomic_status='Accepted'
FROM accepted_species b
WHERE a.species_binomial=b.species_binomial
;
DROP TABLE accepted_species;

ALTER TABLE species_by_political_division DROP COLUMN IF EXISTS taxonomic_status;
ALTER TABLE species_by_political_division
ADD COLUMN taxonomic_status text
; 
UPDATE species_by_political_division a
SET taxonomic_status=b.taxonomic_status
FROM species_status b
WHERE a.scrubbed_species_binomial=b.species_binomial
;
CREATE INDEX species_by_political_division_taxonomic_status_idx ON species_by_political_division (taxonomic_status)
;
UPDATE species_by_political_division
SET taxonomic_status='Unresolved'
WHERE taxonomic_status IS NULL
;

--
-- Set ownership of the new table
--

ALTER TABLE species_by_political_division OWNER TO bien;