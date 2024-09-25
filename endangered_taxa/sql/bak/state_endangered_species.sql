-- ---------------------------------------------------------
-- Create table of USDA state-specific embargoes
-- ---------------------------------------------------------

SET search_path TO public_vegbien_dev;

-- Create table of US state abbreviations and full names
DROP TABLE IF EXISTS us_states;
CREATE TABLE us_states (
state_abbrev VARCHAR(2),
state_abbrev_alt VARCHAR(10),
state_name VARCHAR(50)
);

INSERT INTO us_states (state_abbrev, state_abbrev_alt, state_name)
VALUES 
('AL','Ala.','Alabama'),
('AK','Alaska','Alaska'),
('AZ','Ariz.','Arizona'),
('AR','Ark.','Arkansas'),
('CA','Calif.','California'),
('CO','Colo.','Colorado'),
('CT','Conn.','Connecticut'),
('DE','Del.','Delaware'),
('FL','Fla.','Florida'),
('GA','Ga.','Georgia'),
('HI','Hawaii','Hawaii'),
('ID','Idaho','Idaho'),
('IL','Ill.','Illinois'),
('IN','Ind.','Indiana'),
('IA','Iowa','Iowa'),
('KS','Kan.','Kansas'),
('KY','Ky.','Kentucky'),
('LA','La.','Louisiana'),
('ME','Maine','Maine'),
('MD','Md.','Maryland'),
('MA','Mass.','Massachusetts'),
('MI','Mich.','Michigan'),
('MN','Minn.','Minnesota'),
('MS','Miss.','Mississippi'),
('MO','Mo.','Missouri'),
('MT','Mont.','Montana'),
('NE','Neb.','Nebraska'),
('NV','Nev.','Nevada'),
('NH','N.H.','New Hampshire'),
('NJ','N.J.','New Jersey'),
('NM','N.M.','New Mexico'),
('NY','N.Y.','New York'),
('NC','N.C.','North Carolina'),
('ND','N.D.','North Dakota'),
('OH','Ohio','Ohio'),
('OK','Okla.','Oklahoma'),
('OR','Ore.','Oregon'),
('PA','Pa.','Pennsylvania'),
('RI','R.I.','Rhode Island'),
('SC','S.C.','South Carolina'),
('SD','S.D.','South Dakota'),
('TN','Tenn.','Tennessee'),
('TX','Texas','Texas'),
('UT','Utah','Utah'),
('VT','Vt.','Vermont'),
('VA','Va.','Virginia'),
('WA','Wash.','Washington'),
('WV','W.Va.','West Virginia'),
('WI','Wis.','Wisconsin'),
('WY','Wyo.','Wyoming'),
('DC','','Washington DC'),
('PR','','Puerto Rico'),
('VI','','U.S. Virgin Islands'),
('AS','','American Samoa'),
('GU','','Guam'),
('MP','','Northern Mariana Islands'),
('FM','','Federated States of Micronesia'),
('MH','','Marshall Islands'),
('PW','','Palau')
;
CREATE INDEX ON us_states (state_abbrev);
CREATE INDEX ON us_states (state_abbrev_alt);
CREATE INDEX ON us_states (state_name);

-- Create table of state-specific endangered species
DROP TABLE IF EXISTS endangered_taxa_by_state;
CREATE TABLE endangered_taxa_by_state (
family_scrubbed TEXT,
genus_scrubbed TEXT,
species_binomial_scrubbed TEXT,
taxon_scrubbed TEXT,
taxon_scrubbed_canonical TEXT,
taxon_rank TEXT,
state_abbrev VARCHAR(2),
state_abbrev_alt VARCHAR(10),
state_name VARCHAR(50),
usda_status_state TEXT
);

-- Insert species and states
INSERT INTO endangered_taxa_by_state (
family_scrubbed,
genus_scrubbed,
species_binomial_scrubbed,
taxon_scrubbed,
taxon_scrubbed_canonical,
taxon_rank,
state_abbrev,
state_abbrev_alt,
state_name
)
SELECT DISTINCT
family_scrubbed,
genus_scrubbed,
species_binomial_scrubbed,
taxon_scrubbed,
taxon_scrubbed_canonical,
taxon_rank,
state_abbrev,
state_abbrev_alt,
state_name
FROM endangered_taxa_by_source a, us_states b
WHERE usda_status_state IS NOT NULL 
AND usda_status_state LIKE '%' || b.state_abbrev || ' ' || '%'
;

CREATE INDEX ON endangered_taxa_by_state (taxon_scrubbed_canonical);

UPDATE endangered_taxa_by_state a
SET usda_status_state=b.usda_status_state
FROM endangered_taxa_by_source b
WHERE a.taxon_scrubbed_canonical=b.taxon_scrubbed_canonical
AND b.usda_status_state IS NOT NULL
;

CREATE INDEX ON endangered_taxa_by_state (family_scrubbed);
CREATE INDEX ON endangered_taxa_by_state (taxon_scrubbed);
CREATE INDEX ON endangered_taxa_by_state (taxon_rank);
CREATE INDEX ON endangered_taxa_by_state (state_abbrev);
CREATE INDEX ON endangered_taxa_by_state (state_abbrev_alt);
CREATE INDEX ON endangered_taxa_by_state (state_name);

