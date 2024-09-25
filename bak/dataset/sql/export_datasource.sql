-- 
-- Exports table datasource to data folder as csv file with header
-- 

SET search_path TO :dev_schema;

-- \copy datasource to :data_dir_local/datasource.csv csv header

\copy datasource to /home/boyle/bien3/analytical_db/private/data/datasource/datasource.csv csv header