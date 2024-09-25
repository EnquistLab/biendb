-- ----------------------------------------------------------------
-- Create table plot_provenance
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

-- Create table activity_log
-- Holds selected info extracted from merged postgres CSV log files
DROP TABLE IF EXISTS plot_provenance;
CREATE TABLE plot_provenance AS (
SELECT DISTINCT 
datasource,
plot_name
FROM view_full_occurrence_individual_dev
WHERE observation_type='plot'
AND datasource IS NOT NULL
AND plot_name IS NOT NULL
);

ALTER TABLE plot_provenance
ADD COLUMN dataset VARCHAR(150) DEFAULT NULL,
ADD COLUMN primary_dataowner VARCHAR(150) DEFAULT NULL,
ADD COLUMN primary_dataowner_email VARCHAR(250) DEFAULT NULL
;

-- Add indexes on currently-populated columns
CREATE INDEX plot_provenance_datasource_idx ON plot_provenance(datasource);
CREATE INDEX plot_provenance_plot_name_idx ON plot_provenance(plot_name);

-- Adjust ownership and permissions
ALTER TABLE plot_provenance OWNER TO bien;