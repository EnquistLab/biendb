-- 
-- Sets permissions on db geombien prior to running backup
-- No part of pipeline, run manually as user postgres
--

\c geombien
GRANT USAGE ON SCHEMA topology to bien;  
GRANT SELECT ON ALL SEQUENCES IN SCHEMA topology TO bien;  
GRANT SELECT ON ALL TABLES IN SCHEMA topology TO bien;  

GRANT USAGE ON SCHEMA public to bien;  
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO bien;  
GRANT SELECT ON ALL TABLES IN SCHEMA public TO bien;  