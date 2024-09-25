-- 
--  Update misc plot metadata in table plot_metadata
--

SET search_path TO :dev_schema;

DROP TABLE IF EXISTS metadata_bien2;
DROP TABLE IF EXISTS metadata_cvs;
DROP TABLE IF EXISTS metadata_vegbank;
DROP TABLE IF EXISTS existing_plot_metadata_temp;
