-- 
-- Move postgis views and tables from public to schema postgis
--

/c public_vegbien

CREATE SCHEMA postgis;
ALTER DATABASE public_vegbien SET search_path="$user",public,postgis,topology;
GRANT ALL ON SCHEMA postgis TO public;
ALTER EXTENSION postgis SET SCHEMA postgis;