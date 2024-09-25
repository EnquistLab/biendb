-- --------------------------------------------------------
-- Rename tables countries and alt_stateprovince
-- --------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE country_name RENAME TO alt_country;
ALTER TABLE state_province_name RENAME TO alt_state_province;
ALTER TABLE county_parish_name RENAME TO alt_county_parish;