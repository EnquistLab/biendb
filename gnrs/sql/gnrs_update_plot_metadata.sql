-- ---------------------------------------------------------
-- Update plot_metadata with GNRS results
-- ---------------------------------------------------------

SET search_path TO :sch;

/*
-- Fix mystery error with plot_metadata
-- Investigate in more detail later
UPDATE plot_metadata
SET country_verbatim=country
WHERE country_verbatim IS NULL
AND country IS NOT NULL
;
UPDATE plot_metadata
SET state_province_verbatim=state_province
WHERE state_province_verbatim IS NULL
AND state_province IS NOT NULL
;
UPDATE plot_metadata
SET county_verbatim=county
WHERE county_verbatim IS NULL
AND county IS NOT NULL
;
UPDATE plot_metadata
SET country=NULL,
state_province=NULL,
county=NULL
;


ALTER TABLE plot_metadata DROP COLUMN IF EXISTS poldiv_full;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS fk_gnrs_id;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS gid_0;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS gid_1;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS gid_2;

ALTER TABLE plot_metadata
ADD COLUMN poldiv_full text DEFAULT NULL,
ADD COLUMN fk_gnrs_id INTEGER DEFAULT NULL,
ADD COLUMN gid_0 text DEFAULT NULL,
ADD COLUMN gid_1 text DEFAULT NULL,
ADD COLUMN gid_2 text DEFAULT NULL
;

UPDATE plot_metadata
SET poldiv_full=CONCAT_WS('@',
country_verbatim,
state_province_verbatim,
county_verbatim
);
UPDATE plot_metadata
SET poldiv_full=NULL
WHERE TRIM(poldiv_full)=''
;

DROP INDEX IF EXISTS plot_metadata_poldiv_full_idx;
CREATE INDEX plot_metadata_poldiv_full_idx ON plot_metadata (poldiv_full);
*/

ALTER TABLE plot_metadata DROP COLUMN IF EXISTS fk_gnrs_id;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS gid_0;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS gid_1;
ALTER TABLE plot_metadata DROP COLUMN IF EXISTS gid_2;

ALTER TABLE plot_metadata
ADD COLUMN fk_gnrs_id INTEGER DEFAULT NULL,
ADD COLUMN gid_0 text DEFAULT NULL,
ADD COLUMN gid_1 text DEFAULT NULL,
ADD COLUMN gid_2 text DEFAULT NULL
;

UPDATE plot_metadata a
SET
fk_gnrs_id=b.id::INTEGER,
country=b.country,
state_province=b.state_province,
county=b.county_parish,
gid_0=b.gid_0,
gid_1=b.gid_1,
gid_2=b.gid_2
FROM gnrs b
WHERE a.poldiv_full=b.poldiv_full
;

