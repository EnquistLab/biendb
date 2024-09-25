-- ---------------------------------------------------------
-- Create tables that hold data extract to be sent to CULTOBS
-- ---------------------------------------------------------

SET search_path TO :sch;

DROP TABLE IF EXISTS cods_proximity;
CREATE TABLE cods_proximity (
id INTEGER NOT NULL PRIMARY KEY,
user_id text,
latitude double precision,
longitude double precision,
dist_min_km  double precision,
dist_threshold_km integer,
institution_code text,
institution_name text,
is_cultivated_observation smallint,
is_cultivated_observation_reason text
);

DROP TABLE IF EXISTS cods_keyword;
CREATE TABLE cods_keyword (
id INTEGER NOT NULL PRIMARY KEY,
user_id text,
description text,
is_cultivated_observation smallint,
is_cultivated_observation_reason text
);
