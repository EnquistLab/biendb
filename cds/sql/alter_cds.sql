-- ---------------------------------------------------------
-- Add & populate PK and FK columns
-- ---------------------------------------------------------

SET search_path TO :sch;

-- Remove old non-serial id column (contents not needed)
ALTER TABLE cds
DROP COLUMN id;

ALTER TABLE cds
ADD COLUMN id BIGSERIAL PRIMARY KEY,
ADD COLUMN latlong_verbatim text
;

DROP INDEX IF EXISTS cds_latitude_verbatim_idx;
DROP INDEX IF EXISTS cds_longitude_verbatim_idx;
CREATE INDEX cds_latitude_verbatim_idx ON cds (latitude_verbatim);
CREATE INDEX cds_longitude_verbatim_idx ON cds (longitude_verbatim);

DROP INDEX IF EXISTS cds_submitted_latitude_verbatim_idx;
DROP INDEX IF EXISTS cds_submitted_longitude_verbatim_idx;
CREATE INDEX cds_submitted_latitude_verbatim_idx ON cds_submitted (latitude_verbatim);
CREATE INDEX cds_submitted_longitude_verbatim_idx ON cds_submitted (longitude_verbatim);

UPDATE cds a
SET latlong_verbatim=b.latlong_verbatim
FROM cds_submitted b
WHERE a.latitude_verbatim=b.latitude_verbatim
AND a.longitude_verbatim=b.longitude_verbatim
;

-- Populate latlong_verbatim directly if either latitude_verbatim
-- or longitude_verbatim is null
UPDATE cds
SET latlong_verbatim=CONCAT_WS(', ',latitude_verbatim, longitude_verbatim)
WHERE latlong_verbatim='' OR latlong_verbatim IS NULL
;

-- Finally, remove any remaining rows with NULL/empty values of
-- latlong_verbatim. These will cause crash due to PK violation
-- when attempting to update original tables.
DELETE FROM cds
WHERE latlong_verbatim='' OR latlong_verbatim IS NULL
;
