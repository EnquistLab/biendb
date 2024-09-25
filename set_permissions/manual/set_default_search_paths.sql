-- ------------------------------------------------------------------
-- Set default search_path for role in database
-- ------------------------------------------------------------------

-- Private database
\c vegbien
ALTER ROLE bien_private IN DATABASE vegbien SET search_path TO analytical_db,postgis,topology;


-- Public database
\c public_vegbien
ALTER ROLE bien_private IN DATABASE public_vegbien SET search_path TO public,postgis,topology;
ALTER ROLE public_bien IN DATABASE public_vegbien SET search_path TO public,postgis,topology;
ALTER ROLE bien_read IN DATABASE public_vegbien SET search_path TO public,postgis,topology;
