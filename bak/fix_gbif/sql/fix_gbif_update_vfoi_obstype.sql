-- -----------------------------------------------------------------
-- Make sure vfoi has index on observation_type ONLY
-- -----------------------------------------------------------------

SET search_path to :sch;

UPDATE view_full_occurrence_individual_dev
SET observation_type=
CASE
WHEN observation_type='checklist occurrence' THEN 'checklist'
WHEN observation_type='occurrence' THEN 'literature'
WHEN observation_type='plot occurrence' THEN 'plot'
WHEN observation_type='trait occurrence' THEN 'trait'
END
WHERE observation_type IN (
'checklist occurrence',
'occurrence',
'plot occurrence',
'trait occurrence'
)
;