-- ---------------------------------------------------------
-- Add column continent to table plot_metadata
-- ---------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE plot_metadata
DROP COLUMN IF EXISTS continent
;
ALTER TABLE plot_metadata
ADD COLUMN continent TEXT DEFAULT NULL
;

UPDATE plot_metadata a
SET continent=b.continent
FROM country b
WHERE a.country=b.country
;

DROP INDEX IF EXISTS plot_metadata_continent_idx;
CREATE INDEX plot_metadata_continent_idx ON plot_metadata (continent);