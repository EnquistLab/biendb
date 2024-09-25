-- 
-- Updates metadata from table datasource and populates fk
-- datasource_di
--

SET search_path TO :dev_schema;

UPDATE plot_metadata a
SET 
datasource_id=b.datasource_id,
dataowner=b.primary_contact_fullname,
primary_dataowner_email=b.primary_contact_email
FROM datasource b
WHERE a.datasource=b.proximate_provider_name
AND a.dataset=b.source_name
AND b.observation_type='plot'
;
