-- ---------------------------------------------------------
-- Creates endangered species export tables for export from
-- cites, iucn and usda, plus source x taxon table and 
-- unified bienendangered species table
-- ---------------------------------------------------------

SET search_path TO public_vegbien_dev;

DROP TABLE IF EXISTS cites;
CREATE TABLE cites (
taxonid INTEGER,
kingdom TEXT,
phylum TEXT,
"class" TEXT,
"order" TEXT,
family TEXT,
genus TEXT,
species TEXT,
subspecies TEXT,
fullname TEXT,
authoryear TEXT,
rankname TEXT,
currentlisting TEXT,
fullannotationenglish TEXT,
annotationenglish TEXT,
annotationspanish TEXT,
annotationfrench TEXT,
annotationsymbol TEXT,
annotation TEXT,
synonymswithauthors TEXT,
englishnames TEXT,
spanishnames TEXT,
frenchnames TEXT,
citesaccepted TEXT,
all_distributionisocodes TEXT,
all_distributionfullnames TEXT,
nativedistributionfullnames TEXT,
introduced_distribution TEXT,
introduced_distribution_uncertain TEXT,
reintroduced_distribution TEXT,
extinct_distribution TEXT,
extinct_distribution_uncertain TEXT,
distribution_uncertain TEXT
);

DROP TABLE IF EXISTS iucn;
CREATE TABLE iucn (
species_id TEXT,
kingdom TEXT,
phylum TEXT,
"class" TEXT,
"order" TEXT,
family TEXT,
genus TEXT,
species TEXT,
authority TEXT,
infraspecific_rank TEXT,
infraspecific_name TEXT,
infraspecific_authority TEXT,
stock_subpopulation TEXT,
synonyms TEXT,
common_names_eng TEXT,
common_names_fre TEXT,
common_names_spa TEXT,
red_list_status TEXT,
red_list_criteria TEXT,
red_list_criteria_version TEXT,
year_assessed TEXT,
population_trend TEXT,
petitioned TEXT
);

DROP TABLE IF EXISTS usda;
CREATE TABLE usda (
symbol TEXT,
synonym_symbol TEXT,
scientific_name TEXT,
common_name TEXT,
federal_status TEXT,
state_status_codes TEXT
);   

DROP TABLE IF EXISTS endangered_taxa_by_source;
CREATE TABLE endangered_taxa_by_source (
endangered_taxa_by_source_id SERIAL NOT NULL,
verbatim_taxon TEXT,
family_scrubbed TEXT,
genus_scrubbed TEXT,
species_binomial_scrubbed TEXT,
taxon_scrubbed TEXT,
taxon_scrubbed_canonical TEXT,
taxon_rank TEXT,
cites_status TEXT,
iucn_status TEXT,
usda_status_fed TEXT,
usda_status_state TEXT
);

DROP TABLE IF EXISTS endangered_taxa;
CREATE TABLE endangered_taxa (
endangered_taxa_id SERIAL NOT NULL,
taxon_scrubbed_canonical TEXT,
taxon_rank TEXT,
cites_status TEXT,
iucn_status TEXT,
usda_status_fed TEXT,
usda_status_state TEXT
);





