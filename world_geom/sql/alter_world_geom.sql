-- -----------------------------------------------------------------
-- Add columns for verbatim and scrubbed political division names
-- -----------------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE world_geom DROP COLUMN IF EXISTS poldiv_full;
ALTER TABLE world_geom DROP COLUMN IF EXISTS country_verbatim;
ALTER TABLE world_geom DROP COLUMN IF EXISTS state_province_verbatim;
ALTER TABLE world_geom DROP COLUMN IF EXISTS county_verbatim;
ALTER TABLE world_geom DROP COLUMN IF EXISTS country;
ALTER TABLE world_geom DROP COLUMN IF EXISTS state_province;
ALTER TABLE world_geom DROP COLUMN IF EXISTS county;
ALTER TABLE world_geom DROP COLUMN IF EXISTS match_status;

-- Add the columns
ALTER TABLE world_geom
ADD COLUMN poldiv_full text DEFAULT '',
ADD COLUMN country_verbatim text DEFAULT '',
ADD COLUMN state_province_verbatim text DEFAULT '',
ADD COLUMN county_verbatim text DEFAULT '',
ADD COLUMN country text DEFAULT NULL,
ADD COLUMN state_province text DEFAULT NULL,
ADD COLUMN county text DEFAULT NULL,
ADD COLUMN match_status text DEFAULT NULL
;

-- Insert verbatim values
UPDATE world_geom
SET 
country_verbatim=name_0,
state_province_verbatim=name_1,
county_verbatim=name_2
;

-- Generate the text FK
UPDATE world_geom
SET poldiv_full=CONCAT_WS('@',
coalesce(trim(country_verbatim),''), 
coalesce(trim(state_province_verbatim),''), 
coalesce(trim(county_verbatim),'')
)
;

-- Index the FK
DROP INDEX IF EXISTS world_geom_poldiv_full_idx;
CREATE INDEX world_geom_poldiv_full_idx ON world_geom (poldiv_full);