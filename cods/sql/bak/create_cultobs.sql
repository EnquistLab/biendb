-- ---------------------------------------------------------
-- Create tables that hold data extract to be sent to CULTOBS
-- ---------------------------------------------------------

SET search_path TO :sch;

-- 1:1 extract, just the columns needed for CULTOBS
DROP TABLE IF EXISTS cultobs;
CREATE TABLE cultobs (
cultobs_id bigserial primary key,
tbl_name text,
tbl_id bigint,
description text,
country text,
state_province text,
latitude double precision,
longitude double precision,
is_cultivated_observation smallint,
is_cultivated_observation_basis text,
loc_done smallint default 0,
herb_done smallint default 0
);
