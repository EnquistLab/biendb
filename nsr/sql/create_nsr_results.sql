-- -------------------------------------------------------------
-- Create nsr results table
-- -------------------------------------------------------------

SET search_path TO :sch;

-- Text PK taxon_poldiv will be added later
DROP TABLE IF EXISTS nsr;
CREATE TABLE nsr (
id bigint primary key,
family text,
genus text,
species text,
country text,
state_province text,
county_parish text,
poldiv_full text,
poldiv_type text,
native_status_country text,
native_status_state_province text,
native_status_county_parish text,
native_status text,
native_status_reason text,
native_status_sources text,
isintroduced text,
is_cultivated_in_region text,
is_cultivated_taxon text,
user_id bigint
);