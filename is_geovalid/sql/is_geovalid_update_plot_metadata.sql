-- ---------------------------------------------------------
-- Create & populate column is_geovalid in table plot_metadata
-- ---------------------------------------------------------

SET search_path TO :sch;

ALTER TABLE plot_metadata 
DROP COLUMN IF EXISTS is_geovalid;
ALTER TABLE plot_metadata
ADD COLUMN is_geovalid smallint default 0
;

UPDATE plot_metadata
SET is_geovalid=1
WHERE latitude IS NOT NULL AND longitude IS NOT NULL 
AND (
is_in_country=1 
AND (is_in_state_province=1 OR is_in_state_province IS NULL)
AND (is_in_county=1 OR is_in_county IS NULL)
)
AND is_invalid_latlong=0
; 


