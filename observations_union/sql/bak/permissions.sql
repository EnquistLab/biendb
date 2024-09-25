-- -----------------------------------------------------------------
-- Permissions relevant to BIEN geoserver tables
-- -----------------------------------------------------------------

GRANT USAGE ON SCHEMA :sch TO public_bien3;
GRANT USAGE ON SCHEMA :sch TO jmcgann;

SET search_path to :sch;

REVOKE ALL ON TABLE observations_union FROM PUBLIC;
ALTER TABLE observations_union OWNER TO bien;
GRANT ALL ON TABLE observations_union TO bien;
GRANT ALL ON TABLE observations_union TO jmcgann;
GRANT SELECT ON TABLE observations_union TO bien_read;
GRANT SELECT ON TABLE observations_union TO public_bien3;
GRANT SELECT ON TABLE observations_union TO public_bien;

REVOKE ALL ON TABLE species FROM PUBLIC;
ALTER TABLE species OWNER TO bien;
GRANT ALL ON TABLE species TO bien;
GRANT ALL ON TABLE species TO jmcgann;
GRANT SELECT ON TABLE species TO bien_read;
GRANT SELECT ON TABLE species TO public_bien3;
GRANT SELECT ON TABLE species TO public_bien;