-- --------------------------------------------------------
-- Drops political division tables if they already exist
-- --------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS countries CASCADE;
DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS country_name CASCADE;
DROP TABLE IF EXISTS alt_country CASCADE;
DROP TABLE IF EXISTS state_province CASCADE;
DROP TABLE IF EXISTS state_province_name CASCADE;
DROP TABLE IF EXISTS alt_state_province CASCADE;
DROP TABLE IF EXISTS alt_stateprovince CASCADE;
DROP TABLE IF EXISTS county_parish CASCADE;
DROP TABLE IF EXISTS county_parish_name CASCADE;
DROP TABLE IF EXISTS alt_county_parish CASCADE;
DROP TABLE IF EXISTS alt_countyparish CASCADE;
