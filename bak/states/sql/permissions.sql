-- -----------------------------------------------------------------
-- Permissions relevant to BIEN geoserver tables
-- -----------------------------------------------------------------

SET search_path to :sch;

REVOKE ALL ON TABLE countries FROM PUBLIC;
ALTER TABLE countries OWNER TO bien;
GRANT ALL ON TABLE countries TO bien;
GRANT ALL ON TABLE countries TO jmcgann;
GRANT SELECT ON TABLE countries TO bien_read;
GRANT SELECT ON TABLE countries TO public_bien3;
GRANT SELECT ON TABLE countries TO public_bien;

REVOKE ALL ON TABLE alt_country FROM PUBLIC;
ALTER TABLE alt_country OWNER TO bien;
GRANT ALL ON TABLE alt_country TO bien;
GRANT ALL ON TABLE alt_country TO jmcgann;
GRANT SELECT ON TABLE alt_country TO bien_read;
GRANT SELECT ON TABLE alt_country TO public_bien3;
GRANT SELECT ON TABLE alt_country TO public_bien;