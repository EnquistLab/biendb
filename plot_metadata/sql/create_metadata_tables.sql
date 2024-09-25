-- 
-- Create empty source-specific metadata tables
--

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS metadata_cvs;
CREATE TABLE metadata_cvs (
authorObsCode VARCHAR(250) DEFAULT NULL,
plot_area_ha DOUBLE PRECISION DEFAULT NULL,
abundance_measurement VARCHAR(250) DEFAULT NULL,
has_strata VARCHAR(25) DEFAULT NULL,
has_stem_data VARCHAR(25) DEFAULT NULL,
stem_diam_min NUMERIC DEFAULT NULL,
stem_diam_min_units VARCHAR(25) DEFAULT NULL,
growth_forms_included_trees VARCHAR(25) DEFAULT NULL,
growth_forms_included_shrubs VARCHAR(25) DEFAULT NULL,
growth_forms_included_lianas VARCHAR(25) DEFAULT NULL,
growth_forms_included_herbs VARCHAR(25) DEFAULT NULL,
growth_forms_included_epiphytes VARCHAR(25) DEFAULT NULL,
taxa_included_seed_plants VARCHAR(25) DEFAULT NULL,
taxa_included_ferns_lycophytes VARCHAR(25) DEFAULT NULL,
taxa_included_bryophytes VARCHAR(25) DEFAULT NULL
); 

DROP TABLE IF EXISTS metadata_vegbank;
CREATE TABLE metadata_vegbank (
accessioncode VARCHAR(1000) DEFAULT NULL,
authorobscode VARCHAR(250) DEFAULT NULL,
plot_area_ha DOUBLE PRECISION DEFAULT NULL,
abundance_measurement VARCHAR(250) DEFAULT NULL,
has_strata VARCHAR(25) DEFAULT NULL,
has_stem_data VARCHAR(25) DEFAULT NULL,
stem_diam_min NUMERIC DEFAULT NULL,
stem_diam_min_units VARCHAR(25) DEFAULT NULL,
growth_forms_included_trees VARCHAR(25) DEFAULT NULL,
growth_forms_included_shrubs VARCHAR(25) DEFAULT NULL,
growth_forms_included_lianas VARCHAR(25) DEFAULT NULL,
growth_forms_included_herbs VARCHAR(25) DEFAULT NULL,
growth_forms_included_epiphytes VARCHAR(25) DEFAULT NULL,
taxa_included_seed_plants VARCHAR(25) DEFAULT NULL,
taxa_included_ferns_lycophytes VARCHAR(25) DEFAULT NULL,
taxa_included_bryophytes VARCHAR(25) DEFAULT NULL
);

DROP TABLE IF EXISTS metadata_bien2;
CREATE TABLE metadata_bien2 (
plotID VARCHAR(250) DEFAULT NULL,
dataSourceID VARCHAR(250) DEFAULT NULL,
dataSourceName VARCHAR(250) DEFAULT NULL,
plotCode VARCHAR(250) DEFAULT NULL,
plotAreaHa VARCHAR(25) DEFAULT NULL,
plotMinDbh VARCHAR(25) DEFAULT NULL,
plotMethod VARCHAR (1000) DEFAULT NULL,
country VARCHAR(250) DEFAULT NULL,
stateProvince VARCHAR(250) DEFAULT NULL,
countyParish VARCHAR(250) DEFAULT NULL,
latitude VARCHAR(250) DEFAULT NULL,
longitude VARCHAR(250) DEFAULT NULL,
isValidLatLong VARCHAR(250) DEFAULT NULL,
isGeovalid VARCHAR(250) DEFAULT NULL,
elevation_m VARCHAR(250) DEFAULT NULL,
localityDescription VARCHAR(250) DEFAULT NULL,
isCultivated VARCHAR(250) DEFAULT NULL,
isNewWorld VARCHAR(250) DEFAULT NULL
);
