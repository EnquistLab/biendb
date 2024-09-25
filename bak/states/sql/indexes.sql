-- --------------------------------------------------------
-- Add not null partial index on column geom
-- A one-time thing; this index now added to pipeline
-- --------------------------------------------------------

SET search_path TO :sch;

-- countries
DROP INDEX IF EXISTS countries_iso_idx;
CREATE INDEX countries_iso_idx ON countries USING btree (iso);
DROP INDEX IF EXISTS countries_iso3_idx;
CREATE INDEX countries_iso3_idx ON countries USING btree (iso3);
DROP INDEX IF EXISTS countries_fips_idx;
CREATE INDEX countries_fips_idx ON countries USING btree (fips);
DROP INDEX IF EXISTS countries_geonameid_idx;
CREATE INDEX countries_geonameid_idx ON countries USING btree (geonameid);

-- alt_country
DROP INDEX IF EXISTS alt_country_country_idx;
CREATE INDEX alt_country_country_idx ON alt_country USING btree (country);
DROP INDEX IF EXISTS alt_countryalternatename_idx;
CREATE INDEX alt_country_alternatename_idx ON alt_country USING btree (alternatename);
