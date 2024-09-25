-- --------------------------------------------------------
-- Add verbatim columns for columns we're about to change
-- Shouldn't take too long as table has no indexes yet.
-- --------------------------------------------------------

set search_path to :sch;

ALTER TABLE traits_raw
ADD COLUMN elevation_m_verbatim TEXT DEFAULT NULL,
ADD COLUMN visiting_date_verbatim TEXT DEFAULT NULL,
ADD COLUMN observation_date_verbatim TEXT DEFAULT NULL
;
UPDATE traits_raw
SET 
elevation_m_verbatim=elevation_m,
visiting_date_verbatim=visiting_date,
observation_date_verbatim=observation_date
;