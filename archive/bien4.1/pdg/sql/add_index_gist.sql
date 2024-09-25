SET search_path TO :sch;

DROP INDEX IF EXISTS :idx_name;
CREATE INDEX :idx_name ON :tbl USING gist (:col)
WHERE :col IS NOT NULL
;