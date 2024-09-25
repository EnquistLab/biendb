-- ---------------------------------------------------------------
-- Manual update of doi, date_accessed, etc.
-- For some reason, this was incorrect for BIEN 4.2
-- Automate for next version of DB
-- Date: 30 Apr 2021
-- ---------------------------------------------------------------


\c vegbien
set search_path to analytical_db_dev;
update datasource
set source_citation='GBIF.org (16 November 2020) GBIF Occurrence Download https://doi.org/10.15468/dl.87zyez',
doi='https://doi.org/10.15468/dl.87zyez',
date_accessed='2020-10-16'
where source_name='GBIF'
;

\c public_vegbien
set search_path to analytical_db_dev;
update datasource
set source_citation='GBIF.org (16 November 2020) GBIF Occurrence Download https://doi.org/10.15468/dl.87zyez',
doi='https://doi.org/10.15468/dl.87zyez',
date_accessed='2020-10-16'
where source_name='GBIF'
;
