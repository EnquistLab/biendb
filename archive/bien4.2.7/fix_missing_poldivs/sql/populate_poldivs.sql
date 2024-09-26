-- --------------------------------------------------------------------
-- Update FK plot_metadata_id in view_full_occurrence_individual_dev
-- --------------------------------------------------------------------

SET search_path TO :sch;

UPDATE view_full_occurrence_individual_dev a
SET country_verbatim=
CASE
WHEN datasource='CVS' THEN 'United States'
WHEN datasource='Madidi' THEN 'Bolivia'
WHEN datasource='NVS' THEN 'New Zealand'
ELSE country_verbatim
END
WHERE datasource IN ('CVS','Madidi','NVS')
AND (country_verbatim IS NULL OR TRIM(country_verbatim)='')
;
