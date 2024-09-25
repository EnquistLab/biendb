-- ----------------------------------------------------------------
-- Add aliases for columns "order" and "class" to table bien_taxonomy.
-- 
-- Aliases provide alternative access to these columns for third
-- party applications (such as BIEN API) if the above column names
-- trigger reserved word errors.
-- 
-- Date executed: 26 May 2020
-- DB version before: 4.1.1
-- DB version after: 4.1.1 (no update needed; minor schema addition)
-- ADDED TO BIEN 4.2 PIPELINE
-- ----------------------------------------------------------------

\c vegbien
SET search_path TO analytical_db;

ALTER TABLE bien_taxonomy
ADD COLUMN IF NOT EXISTS taxon_order text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS taxon_class text DEFAULT NULL
;

UPDATE bien_taxonomy
SET taxon_order="order",
taxon_class="class"
;

\c public_vegbien

ALTER TABLE bien_taxonomy
ADD COLUMN IF NOT EXISTS taxon_order text DEFAULT NULL,
ADD COLUMN IF NOT EXISTS taxon_class text DEFAULT NULL
;

UPDATE bien_taxonomy
SET taxon_order="order",
taxon_class="class"
;