-- -----------------------------------------------------------------
-- Please ensure that vfoi has indexes on datasource and occurrence_id only.
-- -----------------------------------------------------------------

SET search_path to :sch;

UPDATE view_full_occurrence_individual_dev a
SET observation_type=
CASE
WHEN b."basisOfRecord"='FOSSIL_SPECIMEN' THEN 'fossil specimen'
WHEN b."basisOfRecord"='HUMAN_OBSERVATION' THEN 'human observation'
WHEN b."basisOfRecord"='LITERATURE' THEN 'literature'
WHEN b."basisOfRecord"='LIVING_SPECIMEN' THEN 'living specimen'
WHEN b."basisOfRecord"='MACHINE_OBSERVATION' THEN 'machine observation'
WHEN b."basisOfRecord"='MATERIAL_SAMPLE' THEN 'material sample'
WHEN b."basisOfRecord"='OBSERVATION' THEN 'unknown'
WHEN b."basisOfRecord"='PRESERVED_SPECIMEN' THEN 'specimen'
WHEN b."basisOfRecord"='xxx' THEN 'unknown'
ELSE observation_type
END
FROM gbif_all_plants_raw b
WHERE a.datasource='GBIF'
AND a.occurrence_id=b."gbifID"
;

UPDATE view_full_occurrence_individual_dev a
SET observation_type=
CASE
WHEN b."basisOfRecord"='FOSSIL_SPECIMEN' THEN 'fossil specimen'
WHEN b."basisOfRecord"='HUMAN_OBSERVATION' THEN 'human observation'
WHEN b."basisOfRecord"='LITERATURE' THEN 'literature'
WHEN b."basisOfRecord"='LIVING_SPECIMEN' THEN 'living specimen'
WHEN b."basisOfRecord"='MACHINE_OBSERVATION' THEN 'machine observation'
WHEN b."basisOfRecord"='MATERIAL_SAMPLE' THEN 'material sample'
WHEN b."basisOfRecord"='OBSERVATION' THEN 'unknown'
WHEN b."basisOfRecord"='PRESERVED_SPECIMEN' THEN 'specimen'
WHEN b."basisOfRecord"='xxx' THEN 'unknown'
ELSE observation_type
END
FROM gbif_fossils_raw b
WHERE a.datasource='GBIF'
AND a.occurrence_id=b."gbifID"
;