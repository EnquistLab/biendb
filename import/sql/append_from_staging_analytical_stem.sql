-- -------------------------------------------------------------
-- Insert stem data from analytical_stem_staging to analytical_stem_dev, 
-- along with taxonobservation_id from vfoi_staging
-- -------------------------------------------------------------

SET search_path TO :sch;

-- Only populate stem-specific columns plus the FK to vfoi,
-- plus taxonobservation_id and datasource.
-- All remaining fields will be populated by joining to vfoi
-- at end of pipeline after all validations complete
INSERT INTO analytical_stem_dev (
taxonobservation_id,
datasource,
individual_id,
individual_count,
tag,
relative_x_m,
relative_y_m,
stem_code,
stem_dbh_cm_verbatim,
stem_dbh_cm,
stem_height_m_verbatim,
stem_height_m
)
SELECT
b.taxonobservation_id,
a.datasource,
a.individual_id,
a.individual_count,
a.tag,
a.relative_x_m,
a.relative_y_m,
a.stem_code,
a.stem_dbh_cm_verbatim,
a.stem_dbh_cm,
a.stem_height_m_verbatim,
a.stem_height_m
FROM analytical_stem_staging a JOIN vfoi_staging b 
ON a.vfoi_staging_id=b.vfoi_staging_id
;
