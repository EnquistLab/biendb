-- -------------------------------------------------------------------------
-- Import world_geom tables from previous BIEN database (analytical_db, =4.1.1)
--
-- Doing this manually as the table needs to be imported from scratch
-- from GADM. Postponing the full import & rebuild until BIEN 5.0
-- -------------------------------------------------------------------------

\c vegbien
set search_path to analytical_db_dev;

DROP TABLE IF EXISTS world_geom_country;
CREATE TABLE world_geom_country (LIKE analytical_db.world_geom_country INCLUDING ALL);
INSERT INTO world_geom_country SELECT * FROM analytical_db.world_geom_country;

DROP TABLE IF EXISTS world_geom_state;
CREATE TABLE world_geom_state (LIKE analytical_db.world_geom_state INCLUDING ALL);
INSERT INTO world_geom_state SELECT * FROM analytical_db.world_geom_state;

DROP TABLE IF EXISTS world_geom_county;
CREATE TABLE world_geom_county (LIKE analytical_db.world_geom_county INCLUDING ALL);
INSERT INTO world_geom_county SELECT * FROM analytical_db.world_geom_county;

DROP TABLE IF EXISTS world_geom;
CREATE TABLE world_geom (LIKE analytical_db.world_geom INCLUDING ALL);
INSERT INTO world_geom SELECT * FROM analytical_db.world_geom;

ALTER TABLE world_geom OWNER TO bien;
ALTER TABLE world_geom_country OWNER TO bien;
ALTER TABLE world_geom_state OWNER TO bien;
ALTER TABLE world_geom_county OWNER TO bien;