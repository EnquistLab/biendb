-- UNDER CONSTRUCTION!!! 

-- Drops all indexes on table _tbl
-- Usage: 
-- SELECT f_drop_indexes('mytable');
-- SELECT f_empty2null('myschema.mytable');

CREATE OR REPLACE FUNCTION some_f(_tbl regclass) RETURNS BOOLEAN AS $func$
BEGIN
   EXECUTE (
   SELECT 'DROP INDEX ' || string_agg(indexrelid::regclass::text, ', ')
   FROM   pg_index  i
   LEFT   JOIN pg_depend d ON d.objid = i.indexrelid
                          AND d.deptype = 'i'
   WHERE  i.indrelid = '_tbl'  
   AND    d.objid IS NULL                                
   ) ;
   RETURN TRUE;
END
$func$  LANGUAGE plpgsql;
