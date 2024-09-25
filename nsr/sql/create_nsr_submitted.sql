-- ---------------------------------------------------------
-- Create tables that hold data extract to be sent to NSR
-- ---------------------------------------------------------

SET search_path TO :sch;

--
-- nsr_submitted_raw
-- 

-- 1:1 extract, just the columns needed for NSR
DROP TABLE IF EXISTS nsr_submitted_raw;
CREATE TABLE nsr_submitted_raw (
tbl_name text,
tbl_id bigint,
taxon text,
country text,
state_province text,
county_parish text,
fk_taxon_poldiv text
);

--
-- nsr_submitted
-- 

-- A SELECT DISTINCT on the NSR columns in nsr_submitted_raw
-- Text PK taxon_poldiv is omitted when exported for NSR &
-- Re-created after importing results
DROP TABLE IF EXISTS nsr_submitted;
CREATE TABLE nsr_submitted (
user_id bigserial primary key,
taxon_poldiv text,
taxon text,
country text,
state_province text,
county_parish text
);