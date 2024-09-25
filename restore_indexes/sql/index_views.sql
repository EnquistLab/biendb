-- 
-- Handy views for summarizing indexes
--

SET search_path TO :sch;

DROP VIEW IF EXISTS view_indexes;
CREATE VIEW view_indexes AS
SELECT n.nspname AS schema,
t.relname AS "table",
c.relname AS index,
pg_get_indexdef(i.indexrelid) AS def
FROM pg_class c
 JOIN pg_namespace n ON n.oid = c.relnamespace
 JOIN pg_index i ON i.indexrelid = c.oid
 JOIN pg_class t ON i.indrelid = t.oid
WHERE c.relkind = 'i'::"char" AND (n.nspname <> ALL (ARRAY['pg_catalog'::name, 'pg_toast'::name])) AND pg_table_is_visible(c.oid)
ORDER BY n.nspname, t.relname, c.relname;
