-- ----------------------------------------------------------------
-- Add aliases for columns "order" and "class"
-- 
-- Aliases provide alternative access to these columns for third
-- party applications (such as BIEN API) if the above column names
-- trigger reserved word errors.
-- ----------------------------------------------------------------

SET search_path TO :dev_schema;

ALTER TABLE bien_taxonomy
ADD COLUMN IF NOT EXISTS taxon_order text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS taxon_class text DEFAULT NULL
;

UPDATE bien_taxonomy
SET taxon_order="order",
taxon_class="class"
;